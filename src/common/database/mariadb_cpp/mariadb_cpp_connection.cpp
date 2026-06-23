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

#include <common/database/mariadb_cpp/mariadb_cpp_connection.h>

#include <common/database/mariadb_cpp/mariadb_cpp_prepared_statement.h>

#include <common/logging.h>
#include <common/settings.h>

#include <thread>
#include <utility>
#include <vector>

#include <chrono>
using namespace std::chrono_literals;

namespace
{

const std::vector<std::string> connectionIssues = {
    "Lost connection",
    "Server has gone away",
    "Connection refused",
    "Can't connect to server",
};

} // namespace

db::MariaDBCppConnection::MariaDBCppConnection(std::unique_ptr<sql::Connection> connection)
: connection_(std::move(connection))
{
}

auto db::MariaDBCppConnection::prepare(const std::string& query) -> std::unique_ptr<PreparedStatement>
{
    return std::make_unique<MariaDBCppPreparedStatement>(connection_->prepareStatement(query.c_str()));
}

auto db::MariaDBCppConnection::schema() -> std::string
{
    return connection_->getSchema().c_str();
}

auto db::MariaDBCppConnection::version() -> std::string
{
    const std::unique_ptr<sql::DatabaseMetaData> metadata(connection_->getMetaData());
    return fmt::format("{} {}", metadata->getDatabaseProductName().c_str(), metadata->getDatabaseProductVersion().c_str());
}

auto db::MariaDBCppConnection::driverVersion() -> std::string
{
    const std::unique_ptr<sql::DatabaseMetaData> metadata(connection_->getMetaData());
    return fmt::format("{} {}", metadata->getDriverName().c_str(), metadata->getDriverVersion().c_str());
}

auto db::MariaDBCppConnection::isConnectionError(const std::exception& e) const -> bool
{
    const auto message = fmt::format("{}", e.what());
    for (const auto& issue : connectionIssues)
    {
        if (message.find(issue) != std::string::npos)
        {
            return true;
        }
    }

    return false;
}

auto db::MariaDBCppConnection::connect() -> std::unique_ptr<Connection>
{
    try
    {
        const auto login  = settings::get<std::string>("network.SQL_LOGIN");
        const auto passwd = settings::get<std::string>("network.SQL_PASSWORD");
        const auto host   = settings::get<std::string>("network.SQL_HOST");
        const auto port   = settings::get<uint16>("network.SQL_PORT");
        const auto schema = settings::get<std::string>("network.SQL_DATABASE");
        const auto url    = fmt::format("tcp://{}:{}/{}", host, port, schema);

        auto connection = std::unique_ptr<sql::Connection>(
            sql::mariadb::get_driver_instance()->connect(url.c_str(), login.c_str(), passwd.c_str()));

        return std::make_unique<MariaDBCppConnection>(std::move(connection));
    }
    catch (const std::exception& e)
    {
        // If we can't establish a connection to the database we can't do anything.
        // Time to die!
        ShowCritical("!!! Failed to connect to database, terminating server !!!");
        ShowCritical(e.what());
        std::this_thread::sleep_for(1s);
        std::terminate();
    }
}
