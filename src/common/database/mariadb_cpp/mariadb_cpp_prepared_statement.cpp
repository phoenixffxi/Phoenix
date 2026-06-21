/*
===========================================================================

  Copyright (c) 2026 LandSandBoat Dev Teams

  This program is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  This program is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with this program.  If not, see http://www.gnu.org/licenses/

===========================================================================
*/

#include <common/database/mariadb_cpp/mariadb_cpp_prepared_statement.h>

#include <common/database/mariadb_cpp/mariadb_cpp_result_set.h>

#include <common/logging.h>
#include <common/tracy.h>

#include <memory>
#include <type_traits>
#include <variant>

auto db::MariaDBCppPreparedStatement::bind(int index, const BoundValue& value) -> void
{
    TracyZoneScoped;

    std::visit(
        [&](const auto& v)
        {
            using U = std::remove_cvref_t<decltype(v)>;
            if constexpr (std::is_same_v<U, std::shared_ptr<BlobWrapper>>)
            {
                DebugSQLFmt("binding {}: {}", index, v->toString());
                stmt_->setBlob(index, &v->istream);
            }
            else if constexpr (std::is_same_v<U, std::string>)
            {
                DebugSQLFmt("binding {}: {}", index, v);
                stmt_->setString(index, v.c_str());
            }
            else if constexpr (std::is_same_v<U, int8> || std::is_same_v<U, uint8>)
            {
                DebugSQLFmt("binding {}: {}", index, v);
                stmt_->setByte(index, v);
            }
            else if constexpr (std::is_same_v<U, int16>)
            {
                DebugSQLFmt("binding {}: {}", index, v);
                stmt_->setShort(index, v);
            }
            else if constexpr (std::is_same_v<U, uint16>)
            {
                DebugSQLFmt("binding {}: {}", index, v);
                stmt_->setUInt(index, v);
            }
            else if constexpr (std::is_same_v<U, int32>)
            {
                DebugSQLFmt("binding {}: {}", index, v);
                stmt_->setInt(index, v);
            }
            else if constexpr (std::is_same_v<U, uint32>)
            {
                DebugSQLFmt("binding {}: {}", index, v);
                stmt_->setUInt(index, v);
            }
            else if constexpr (std::is_same_v<U, bool>)
            {
                DebugSQLFmt("binding {}: {}", index, v);
                stmt_->setBoolean(index, v);
            }
            else if constexpr (std::is_same_v<U, float>)
            {
                DebugSQLFmt("binding {}: {}", index, v);
                stmt_->setFloat(index, v);
            }
            else if constexpr (std::is_same_v<U, double>)
            {
                DebugSQLFmt("binding {}: {}", index, v);
                stmt_->setDouble(index, v);
            }
        },
        value);
}

auto db::MariaDBCppPreparedStatement::executeQuery(const std::string& query) -> std::unique_ptr<ResultSet>
{
    auto rset = std::unique_ptr<sql::ResultSet>(stmt_->executeQuery());
    return std::make_unique<MariaDBCppResultSet>(std::move(rset), query);
}

auto db::MariaDBCppPreparedStatement::executeUpdate(const std::string& query) -> std::unique_ptr<ResultSet>
{
    const auto rowsAffected = stmt_->executeUpdate();
    return std::make_unique<MariaDBCppResultSet>(static_cast<std::size_t>(rowsAffected), query);
}
