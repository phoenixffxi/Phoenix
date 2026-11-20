#!/usr/bin/python

# [Phoenix] Launch Token
# Checks that xi_connect accepts loader logins only with a Phoenix launch token
# while login.PHOENIX_REQUIRE_LAUNCH_TOKEN is on (the shipped default), and that
# turning it off brings back password logins for local use.
#
# Starts its own xi_connect from the server directory against the database in
# XI_NETWORK_SQL_*, adds throwaway "ltcheck_" accounts, and removes them after.
# Stop any other login server first; xi_connect needs ports 54001, 54230, 54231.
#
# Usage: python -m tools.ci.launch_token_checks

import hashlib
import json
import os
import secrets
import socket
import ssl
import subprocess
import sys
import threading

import mariadb

server_dir_path = os.path.normpath(
    os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
)

SETTING_ENV = "XI_LOGIN_PHOENIX_REQUIRE_LAUNCH_TOKEN"

# from src/login/auth_session.h
LOGIN_ATTEMPT = 0x10
LOGIN_FAIL = 0x00
LOGIN_SUCCESS = 0x01
LOGIN_ERROR_LAUNCH_TOKEN_INVALID = 0x14

# bcrypt of "admin1", as in startup_checks.py
PASSWORD = "admin1"
PASSWORD_HASH = "$2a$12$piFoDKvu80KK68xLgQFpt.ZCqVPTjPmhSUfA31.Yw9n404dTsrR6q"

REFUSED_MESSAGE = "Password login is disabled"

failures = []


def check(name, ok, detail=""):
    print(f"{'PASS' if ok else 'FAIL'}: {name}" + ("" if ok else f" ({detail})"))
    if not ok:
        failures.append(name)


def connect_db():
    db = mariadb.connect(
        host=os.getenv("XI_NETWORK_SQL_HOST", "127.0.0.1"),
        port=int(os.getenv("XI_NETWORK_SQL_PORT", "3306")),
        user=os.getenv("XI_NETWORK_SQL_LOGIN", "root"),
        passwd=os.getenv("XI_NETWORK_SQL_PASSWORD", "root"),
        db=os.getenv("XI_NETWORK_SQL_DATABASE", "xidb"),
    )
    # xi_connect writes the rows we assert on, so never read from a stale snapshot
    db.autocommit = True
    return db


def sha256(token):
    return hashlib.sha256(token.encode()).hexdigest()


def remove_accounts(cur):
    cur.execute("SELECT id FROM accounts WHERE login LIKE 'ltcheck\\_%'")
    for (accid,) in cur.fetchall():
        cur.execute("DELETE FROM accounts_totp WHERE accid = ?", (accid,))
        # tokens and the profile row cascade
        cur.execute("DELETE FROM accounts WHERE id = ?", (accid,))


def create_account(cur, login, status=1):
    cur.execute("SELECT COALESCE(MAX(id), 999) + 1 FROM accounts")
    (accid,) = cur.fetchone()
    cur.execute(
        "INSERT INTO accounts (id, login, password, timecreate, timelastmodify, status, priv) "
        "VALUES (?, ?, ?, NOW(), NOW(), ?, 1)",
        (accid, login, PASSWORD_HASH, status),
    )
    return accid


def mint_launch_token(cur, accid, expires="NOW() + INTERVAL 5 MINUTE"):
    token = secrets.token_hex(32)
    cur.execute(
        f"INSERT INTO accounts_login_tokens (token, accid, expires) VALUES (?, ?, {expires})",
        (sha256(token), accid),
    )
    return token


def count(cur, query, *args):
    cur.execute(query, args)
    return cur.fetchone()[0]


def start_connect(require_token):
    env = dict(os.environ)
    env.pop(SETTING_ENV, None)  # on: test the shipped default, not an override
    if not require_token:
        env[SETTING_ENV] = "false"

    proc = subprocess.Popen(
        [os.path.join(server_dir_path, "xi_connect")],
        cwd=server_dir_path,
        env=env,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
        encoding="utf-8",
        errors="replace",
    )

    output = []
    ready = threading.Event()

    def read():
        for line in proc.stdout:
            output.append(line)
            if "ready to work" in line.lower():
                ready.set()

    threading.Thread(target=read, daemon=True).start()

    if not ready.wait(120):
        stop_connect(proc)
        print("".join(output))
        raise RuntimeError("xi_connect did not become ready")

    return proc, output


def stop_connect(proc):
    proc.terminate()
    try:
        proc.wait(timeout=30)
    except subprocess.TimeoutExpired:
        proc.kill()
        proc.wait()


def login(**fields):
    request = {
        "command": LOGIN_ATTEMPT,
        "version": [2, 2, 0],
        "username": "",
        "password": "",
        "otp": "",
        "new_password": "",
    }
    request.update(fields)

    context = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
    context.minimum_version = ssl.TLSVersion.TLSv1_3
    context.check_hostname = False
    context.verify_mode = ssl.CERT_NONE

    try:
        with socket.create_connection(("127.0.0.1", 54231), timeout=10) as raw:
            with context.wrap_socket(raw) as sock:
                sock.sendall(json.dumps(request).encode())
                reply = sock.recv(8192)
        return json.loads(reply.decode())
    except (OSError, ValueError) as err:
        return {"no_reply": str(err)}


def check_refused(name, reply):
    check(
        f"{name} is refused with a message",
        REFUSED_MESSAGE in reply.get("error_message", ""),
        reply,
    )


def check_result(name, reply, result):
    check(name, reply.get("result") == result and "error_message" not in reply, reply)


def check_success(name, reply, accid):
    check(
        name,
        reply.get("result") == LOGIN_SUCCESS
        and reply.get("account_id") == accid
        and len(reply.get("session_hash", [])) == 16,
        reply,
    )


def enforced_checks(cur, accounts):
    plain, two_fa, banned, trust_token = accounts
    has_profile = "SELECT COUNT(*) FROM accounts_profile WHERE accid = ?"
    has_token = "SELECT COUNT(*) FROM accounts_login_tokens WHERE token = ?"

    # Tokenless requests, including ones that pass every other factor
    check_refused("password only", login(username="ltcheck_plain", password=PASSWORD))
    check_refused(
        "password with an empty login_token",
        login(username="ltcheck_plain", password=PASSWORD, login_token=""),
    )
    check_refused(
        "password with a non-string login_token",
        login(username="ltcheck_plain", password=PASSWORD, login_token=12345),
    )
    check_refused("a request with no credentials", login())
    check_refused(
        "password, OTP, and a valid trust token",
        login(
            username="ltcheck_2fa",
            password=PASSWORD,
            otp="123456",
            trust_token=trust_token,
        ),
    )
    check(
        "refused logins create no session",
        count(cur, has_profile, plain) == 0 and count(cur, has_profile, two_fa) == 0,
    )

    # Bad tokens (3 lockout strikes, under the limit of 5)
    check_result(
        "malformed launch token is rejected",
        login(login_token="not-a-launch-token"),
        LOGIN_ERROR_LAUNCH_TOKEN_INVALID,
    )
    check_result(
        "unknown launch token is rejected",
        login(login_token=secrets.token_hex(32)),
        LOGIN_ERROR_LAUNCH_TOKEN_INVALID,
    )
    expired = mint_launch_token(cur, plain, expires="NOW() - INTERVAL 1 MINUTE")
    check_result(
        "expired launch token is rejected",
        login(username="ltcheck_plain", login_token=expired),
        LOGIN_ERROR_LAUNCH_TOKEN_INVALID,
    )

    # A valid token logs in, skips OTP, and is consumed
    valid = mint_launch_token(cur, two_fa)
    check_success(
        "valid launch token logs in without OTP",
        login(username="ltcheck_2fa", login_token=valid),
        two_fa,
    )
    check("valid launch token is consumed", count(cur, has_token, sha256(valid)) == 0)
    check("valid launch token creates a session", count(cur, has_profile, two_fa) == 1)
    check_result(
        "reused launch token is rejected",
        login(username="ltcheck_2fa", login_token=valid),
        LOGIN_ERROR_LAUNCH_TOKEN_INVALID,
    )

    # Account status still applies after the token is accepted
    banned_token = mint_launch_token(cur, banned)
    check_result(
        "banned account with a valid launch token is refused",
        login(username="ltcheck_banned", login_token=banned_token),
        LOGIN_FAIL,
    )
    check(
        "banned account's launch token is consumed",
        count(cur, has_token, sha256(banned_token)) == 0,
    )
    check("banned account gets no session", count(cur, has_profile, banned) == 0)


def opt_out_checks(accounts):
    plain, two_fa, _, trust_token = accounts

    check_success(
        "password only logs in when enforcement is off",
        login(username="ltcheck_plain", password=PASSWORD),
        plain,
    )
    check_success(
        "password and trust token log in when enforcement is off",
        login(username="ltcheck_2fa", password=PASSWORD, trust_token=trust_token),
        two_fa,
    )


def main():
    db = connect_db()
    cur = db.cursor()
    remove_accounts(cur)

    try:
        plain = create_account(cur, "ltcheck_plain")
        two_fa = create_account(cur, "ltcheck_2fa")
        banned = create_account(cur, "ltcheck_banned", status=2)
        cur.execute(
            "INSERT INTO accounts_totp (accid, secret, recovery_code, validated) VALUES (?, ?, ?, 1)",
            (two_fa, "JBSWY3DPEHPK3PXP", "LTCHECKRECOVERY"),
        )
        trust_token = secrets.token_hex(32)
        cur.execute(
            "INSERT INTO accounts_trust_tokens (token, accid, expires) VALUES (?, ?, NOW() + INTERVAL 1 DAY)",
            (sha256(trust_token), two_fa),
        )
        accounts = (plain, two_fa, banned, trust_token)

        print("== Default settings (enforcement on)")
        proc, output = start_connect(require_token=True)
        try:
            check(
                "startup reports enforcement on",
                any("Launch tokens are required" in line for line in output),
            )
            enforced_checks(cur, accounts)
        finally:
            stop_connect(proc)

        print(f"== {SETTING_ENV}=false (enforcement off)")
        proc, output = start_connect(require_token=False)
        try:
            check(
                "startup warns that enforcement is off",
                any("Launch tokens are NOT required" in line for line in output),
            )
            opt_out_checks(accounts)
        finally:
            stop_connect(proc)
    finally:
        remove_accounts(cur)
        cur.close()
        db.close()

    if failures:
        print(f"{len(failures)} check(s) failed")
        sys.exit(1)

    print("All launch token checks passed")


if __name__ == "__main__":
    main()
