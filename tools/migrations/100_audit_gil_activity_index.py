import mariadb

# Final column lists for the indexes this migration owns.
INDEXES = {
    "idx_gil_date_activity": ["date", "charid", "source", "delta"],
    "idx_gil_source_date": ["source", "date", "charid", "delta"],
}

# Left prefix of idx_gil_date_activity.
REDUNDANT = "idx_gil_date"


def migration_name():
    return "Cover gil economy activity queries with audit_gil indexes"


def check_preconditions(cur):
    return


def _index_columns(cur):
    cur.execute("SHOW INDEX FROM audit_gil")
    columns = {}
    for row in sorted(cur.fetchall(), key=lambda row: (row[2], row[3])):
        columns.setdefault(row[2], []).append(row[4])
    return columns


def _pending_changes(cur):
    cur.execute("SHOW TABLES LIKE 'audit_gil'")
    if cur.fetchone() is None:
        return []

    existing = _index_columns(cur)
    changes = []
    for name, columns in INDEXES.items():
        if existing.get(name) == columns:
            continue
        if name in existing:
            changes.append("DROP INDEX {}".format(name))
        changes.append(
            "ADD INDEX {} ({})".format(
                name, ", ".join("`{}`".format(column) for column in columns)
            )
        )
    if REDUNDANT in existing:
        changes.append("DROP INDEX {}".format(REDUNDANT))
    return changes


def needs_to_run(cur):
    return len(_pending_changes(cur)) > 0


def migrate(cur, db):
    try:
        changes = _pending_changes(cur)
        if not changes:
            return

        cur.execute(
            "ALTER TABLE audit_gil {}, ALGORITHM=INPLACE, LOCK=NONE".format(
                ", ".join(changes)
            )
        )
        db.commit()
    except mariadb.Error as err:
        print("Something went wrong: {}".format(err))
