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

#include <common/database/connection.h>

#include <common/database/mariadb_cpp/mariadb_cpp_include.h>

#include <exception>
#include <memory>
#include <string>

namespace db
{

class MariaDBCppConnection final : public Connection
{
public:
    explicit MariaDBCppConnection(std::unique_ptr<sql::Connection> connection);

    auto prepare(const std::string& query) -> std::unique_ptr<PreparedStatement> override;
    auto schema() -> std::string override;
    auto version() -> std::string override;
    auto driverVersion() -> std::string override;
    auto isConnectionError(const std::exception& e) const -> bool override;

    static auto connect() -> std::unique_ptr<Connection>;

private:
    std::unique_ptr<sql::Connection> connection_;
};

} // namespace db
