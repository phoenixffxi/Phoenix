#!/usr/bin/env python3
"""Exercise AH access against a built search server and the dedicated test MariaDB.

Requires the Phoenix Platform test compose project named phoenix-search-ah-test,
with MariaDB published on localhost:3308. Only this isolated test database is reset.
"""

import argparse
import hashlib
import json
import os
from pathlib import Path
import re
import socket
import struct
import subprocess
import sys
import time

ROOT = Path(__file__).resolve().parents[2]
PORT: int
CONTAINER = "phoenix-search-ah-test-mariadb-test-1"
PREFIX = bytes.fromhex("30733d6d3c31495a327a424363387b7e")
MASK = 0xFFFFFFFF


def sql(text):
    result = subprocess.run(
        [
            "docker",
            "exec",
            "-i",
            CONTAINER,
            "mariadb",
            "-uroot",
            "-pphoenix_test",
            "xidb",
            "-N",
        ],
        input=text,
        text=True,
        capture_output=True,
        check=True,
    )
    return result.stdout.strip()


def encryptor():
    source = (ROOT / "src/common/blowfish.cpp").read_text()
    raw = bytes(
        int(x, 16)
        for x in re.findall(
            r"0x([0-9a-fA-F]{2})",
            source.split("uint8 subkey[4168] = {", 1)[1].split("};", 1)[0],
        )
    )
    words = list(struct.unpack("<1042I", raw))
    p, s = words[:18], words[18:]

    def tt(x):
        return (
            ((s[256 + ((x >> 8) & 255)] & 1) ^ 32)
            + ((s[768 + (x >> 24)] & 1) ^ 32)
            + s[512 + ((x >> 16) & 255)]
            + s[x & 255]
        ) & MASK

    def enc(left, right):
        for i in range(16):
            left ^= p[i]
            right ^= tt(left)
            left, right = right, left
        left, right = right, left
        return left ^ p[17], right ^ p[16]

    salt = struct.pack("<I", 0x12345678)
    key = hashlib.md5(PREFIX + salt).digest()
    j = 0
    for i in range(18):
        word = 0
        for _ in range(4):
            byte = key[j]
            word = ((word << 8) | (byte if byte < 128 else byte - 256)) & MASK
            j = (j + 1) % len(key)
        p[i] ^= word
    left = right = 0
    for i in range(0, 18, 2):
        left, right = enc(left, right)
        p[i : i + 2] = left, right
    for i in range(0, 1024, 2):
        left, right = enc(left, right)
        s[i : i + 2] = left, right
    return enc, salt


ENC, SALT = encryptor()


def packet(kind):
    raw = bytearray(48)
    struct.pack_into("<H", raw, 0, len(raw))
    struct.pack_into("<I", raw, 4, 0x46465849)
    raw[11] = kind
    struct.pack_into("<H", raw, 18, 4096)
    raw[21] = kind == 6
    raw[28:44] = hashlib.md5(raw[8:28]).digest()
    raw[44:48] = SALT
    for offset in range(8, 40, 8):
        left, right = ENC(*struct.unpack_from("<II", raw, offset))
        struct.pack_into("<II", raw, offset, left, right)
    return raw


def connect(ip="127.0.0.1"):
    client = socket.socket()
    client.settimeout(3)
    client.bind((ip, 0))
    client.connect(("127.0.0.1", PORT))
    return client


def request(client, kind, allowed):
    client.sendall(packet(kind))
    try:
        result = client.recv(4096)
    except ConnectionResetError:
        result = b""
    if allowed:
        assert result, f"expected AH response for type {kind}"
        assert len(result) >= 8
    else:
        assert not result, f"restricted AH response leaked for type {kind}"


def fresh(kind, allowed, ip="127.0.0.1"):
    with connect(ip) as client:
        request(client, kind, allowed)


def stored_ip(ip):
    return int.from_bytes(socket.inet_aton(ip), sys.byteorder)


def main():
    global PORT
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--log-dir", type=Path, default=ROOT / "build/search-ah-smoke")
    args = parser.parse_args()
    EVIDENCE = args.log_dir
    EVIDENCE.mkdir(parents=True, exist_ok=True)
    label = subprocess.run(
        [
            "docker",
            "inspect",
            "--format",
            '{{index .Config.Labels "com.docker.compose.project"}}',
            CONTAINER,
        ],
        text=True,
        capture_output=True,
        check=True,
    ).stdout.strip()
    if label != "phoenix-search-ah-test":
        raise RuntimeError(
            "Refusing to reset a database outside the dedicated test project"
        )
    published = subprocess.run(
        ["docker", "port", CONTAINER, "3306/tcp"],
        text=True,
        capture_output=True,
        check=True,
    ).stdout.strip()
    if published != "127.0.0.1:3308":
        raise RuntimeError("Expected the dedicated MariaDB on 127.0.0.1:3308")
    with socket.socket() as probe:
        probe.bind(("127.0.0.1", 0))
        PORT = probe.getsockname()[1]
    environment = os.environ.copy()
    environment.update(
        {
            "XI_NETWORK_SQL_HOST": "127.0.0.1",
            "XI_NETWORK_SQL_PORT": "3308",
            "XI_NETWORK_SQL_LOGIN": "root",
            "XI_NETWORK_SQL_PASSWORD": "phoenix_test",
            "XI_NETWORK_SQL_DATABASE": "xidb",
            "XI_NETWORK_SEARCH_PORT": str(PORT),
            "XI_SEARCH_EXPIRE_AUCTIONS": "false",
            "XI_SEARCH_AH_REQUESTS_PER_ACCOUNT_PER_MINUTE": "4",
        }
    )
    checks = []
    server = None
    renamed = False
    try:
        sql(
            "DELETE FROM accounts_sessions; DELETE FROM accounts WHERE id IN (99500,99501);"
        )
        output = (EVIDENCE / "search-packet-server.log").open("w")
        server = subprocess.Popen(
            [str(ROOT / ("xi_search.exe" if os.name == "nt" else "xi_search"))],
            cwd=ROOT,
            env=environment,
            stdin=subprocess.PIPE,
            stdout=output,
            stderr=subprocess.STDOUT,
            creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0),
        )
        for _ in range(100):
            if server.poll() is not None:
                raise RuntimeError(f"search server exited with {server.returncode}")
            try:
                with connect():
                    break
            except ConnectionRefusedError:
                time.sleep(0.1)
        else:
            raise RuntimeError("search listener did not start")

        for kind in (5, 6, 16, 21):
            fresh(kind, False)
        checks.append(
            "all four AH packet types deny anonymous/connection-whitelisted loopback callers"
        )

        sql(
            "INSERT INTO accounts(id,login,password,current_email,registration_email,timecreate,status) VALUES(99500,'ahguardqa1','','fixture@test.local','fixture@test.local',NOW(),1),(99501,'ahguardqa2','','fixture@test.local','fixture@test.local',NOW(),2);"
        )
        sql(
            "INSERT INTO accounts_sessions(accid,charid,client_addr) VALUES(99500,99500,INET_ATON('127.0.0.1'));"
        )
        fresh(5, False)
        sql(
            f'UPDATE accounts_sessions SET client_addr={stored_ip("127.0.0.1")} WHERE accid=99500;'
        )
        with connect() as client:
            request(client, 5, True)
            sql("UPDATE accounts SET status=0 WHERE id=99500;")
            request(client, 5, False)
        checks.append(
            "native game IP encoding admits an active account and an existing socket is denied after ban"
        )

        for status in (2, 3, 4):
            sql(f"UPDATE accounts SET status={status} WHERE id=99500;")
            fresh(5, False)
        checks.append(
            "banned, mixed NORMAL+BANNED, and non-normal account states are denied"
        )

        sql("UPDATE accounts SET status=1 WHERE id=99500;")
        with connect() as client:
            request(client, 6, True)
            sql("DELETE FROM accounts_sessions WHERE accid=99500;")
            request(client, 6, False)
        checks.append(
            "stack history succeeds and logout revokes an already-open connection"
        )

        sql(
            f'INSERT INTO accounts_sessions(accid,charid,client_addr) VALUES(99500,99500,{stored_ip("127.0.0.1")}),(99501,99501,{stored_ip("127.0.0.1")});'
        )
        fresh(5, True)
        fresh(5, True)
        fresh(5, False)
        sql("UPDATE accounts SET status=1 WHERE id=99501;")
        for _ in range(4):
            fresh(5, True)
        fresh(5, False)
        fresh(5, False)
        checks.append(
            "shared-IP budget counts allowed live accounts only and reconnecting does not reset it"
        )

        sql(
            f'UPDATE accounts_sessions SET client_addr={stored_ip("127.0.0.3")} WHERE accid=99500;'
        )
        for kind in (5, 6, 16, 21):
            fresh(kind, True, "127.0.0.3")
        checks.append("active players receive all four AH response types")

        sql("RENAME TABLE accounts_sessions TO ah_access_sessions_saved;")
        renamed = True
        fresh(5, False, "127.0.0.3")
        sql("RENAME TABLE ah_access_sessions_saved TO accounts_sessions;")
        renamed = False
        checks.append(
            "database lookup failure closes the connection without market data"
        )
        print(json.dumps({"passed": checks, "serverPort": PORT}, indent=2))
    finally:
        if renamed:
            sql("RENAME TABLE ah_access_sessions_saved TO accounts_sessions;")
        if server is not None:
            server.terminate()
            server.wait(timeout=10)
        sql(
            "DELETE FROM accounts_sessions WHERE accid IN (99500,99501); DELETE FROM accounts WHERE id IN (99500,99501);"
        )


if __name__ == "__main__":
    main()
