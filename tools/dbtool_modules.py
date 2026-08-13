def parse_module_entries(contents):
    entries = []
    for line in contents.splitlines():
        entry = line.strip()
        if entry and not entry.startswith("#"):
            entries.append(entry.replace("\\", "/").strip("/"))
    return entries


def module_path_enabled(path, entries):
    normalized_path = path.replace("\\", "/").strip("/")
    return any(
        normalized_path == entry or normalized_path.startswith(entry + "/")
        for entry in entries
    )


def select_module_sql_files(current_paths, changed_paths, previous_entries):
    changed = {path.replace("\\", "/").strip("/") for path in changed_paths}
    return sorted(
        path
        for path in current_paths
        if path in changed or not module_path_enabled(path, previous_entries)
    )
