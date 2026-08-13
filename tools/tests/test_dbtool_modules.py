import unittest

from tools.dbtool_modules import parse_module_entries, select_module_sql_files


class ModuleSqlSelectionTests(unittest.TestCase):
    def test_parses_enabled_module_entries(self):
        contents = """
        # Disabled module
        phoenix/sql
        custom/example.sql
        """

        self.assertEqual(
            parse_module_entries(contents),
            ["phoenix/sql", "custom/example.sql"],
        )

    def test_selects_only_changed_enabled_sql(self):
        current_paths = [
            "abyssea/sql/guild_item_points.sql",
            "phoenix/sql/bazaar_tax.sql",
        ]

        selected = select_module_sql_files(
            current_paths,
            {"phoenix/sql/bazaar_tax.sql"},
            ["abyssea/sql", "phoenix/sql"],
        )

        self.assertEqual(selected, ["phoenix/sql/bazaar_tax.sql"])

    def test_selects_all_sql_from_newly_enabled_module(self):
        current_paths = [
            "abyssea/sql/guild_item_points.sql",
            "phoenix/sql/bazaar_tax.sql",
        ]

        selected = select_module_sql_files(
            current_paths,
            set(),
            ["phoenix/sql"],
        )

        self.assertEqual(
            selected,
            ["abyssea/sql/guild_item_points.sql"],
        )


if __name__ == "__main__":
    unittest.main()
