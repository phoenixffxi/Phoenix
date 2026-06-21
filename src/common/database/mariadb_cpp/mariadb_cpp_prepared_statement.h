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

#pragma once

#include <common/database/bound_value.h>
#include <common/database/prepared_statement.h>
#include <common/database/result_set.h>

#include <common/database/mariadb_cpp/mariadb_cpp_include.h>

#include <memory>
#include <string>

namespace db
{

class MariaDBCppPreparedStatement final : public PreparedStatement
{
public:
    explicit MariaDBCppPreparedStatement(sql::PreparedStatement* stmt)
    : stmt_(stmt)
    {
    }

    auto bind(int index, const BoundValue& value) -> void override;
    auto executeQuery(const std::string& query) -> std::unique_ptr<ResultSet> override;
    auto executeUpdate(const std::string& query) -> std::unique_ptr<ResultSet> override;

private:
    std::unique_ptr<sql::PreparedStatement> stmt_;
};

} // namespace db
