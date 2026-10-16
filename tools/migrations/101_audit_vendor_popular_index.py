INDEX_NAME = "idx_vendor_date_popular"
COLUMNS = [
    "date",
    "npcid",
    "seller",
    "quantity",
    "direction",
    "applied_gil",
    "npc_name",
]


def migration_name():
    return "Cover vendor popularity queries with a date-first index"


def check_preconditions(cur):
    return


def needs_to_run(cur):
    cur.execute("SHOW TABLES LIKE 'audit_vendor'")
    if cur.fetchone() is None:
        return False
    cur.execute("SHOW INDEX FROM audit_vendor")
    columns = [
        row[4]
        for row in sorted(cur.fetchall(), key=lambda row: row[3])
        if row[2] == INDEX_NAME
    ]
    return columns != COLUMNS


def migrate(cur, db):
    if not needs_to_run(cur):
        return
    cur.execute("SHOW INDEX FROM audit_vendor")
    replace = any(row[2] == INDEX_NAME for row in cur.fetchall())
    changes = "DROP INDEX {}, ".format(INDEX_NAME) if replace else ""
    changes += "ADD INDEX {} ({})".format(
        INDEX_NAME, ", ".join("`{}`".format(column) for column in COLUMNS)
    )
    cur.execute(
        "ALTER TABLE audit_vendor {}, ALGORITHM=INPLACE, LOCK=NONE".format(changes)
    )
    db.commit()
