def migration_name():
    return "Add covering index for gil economy activity queries"


def check_preconditions(cur):
    return


def needs_to_run(cur):
    cur.execute("SHOW TABLES LIKE 'audit_gil'")
    if cur.fetchone() is None:
        return False

    cur.execute("SHOW INDEX FROM audit_gil WHERE Key_name = 'idx_gil_date_activity'")
    return cur.fetchone() is None


def migrate(cur, db):
    if not needs_to_run(cur):
        return

    cur.execute(
        "ALTER TABLE audit_gil "
        "ADD INDEX idx_gil_date_activity (date, charid, source, delta), "
        "ALGORITHM=INPLACE, LOCK=NONE"
    )
    db.commit()
