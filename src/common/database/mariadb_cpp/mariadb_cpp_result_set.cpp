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

#include <common/database/mariadb_cpp/mariadb_cpp_result_set.h>

#include <utility>

db::MariaDBCppResultSet::MariaDBCppResultSet(std::unique_ptr<sql::ResultSet>&& resultSet, const std::string& query)
: ResultSet(query, ResultSetType::Select)
, resultSet_(std::move(resultSet))
{
}

db::MariaDBCppResultSet::MariaDBCppResultSet(std::size_t rowsAffected, const std::string& query)
: ResultSet(query, ResultSetType::Update, rowsAffected)
{
}

auto db::MariaDBCppResultSet::rawNext() -> bool
{
    return resultSet_->next();
}

auto db::MariaDBCppResultSet::rawRowsCount() const -> std::size_t
{
    return resultSet_->rowsCount();
}

auto db::MariaDBCppResultSet::rawColumnCount() const -> std::size_t
{
    const std::unique_ptr<sql::ResultSetMetaData> metadata(resultSet_->getMetaData());
    return static_cast<std::size_t>(metadata->getColumnCount());
}

auto db::MariaDBCppResultSet::rawIsNull(const std::string& key) const -> bool
{
    return resultSet_->isNull(key.c_str());
}

auto db::MariaDBCppResultSet::rawColumnLabel(uint32 index) const -> std::string
{
    const std::unique_ptr<sql::ResultSetMetaData> metadata(resultSet_->getMetaData());
    return metadata->getColumnLabel(index).c_str();
}

auto db::MariaDBCppResultSet::rawGetInt64(const std::string& key) const -> int64
{
    return resultSet_->getInt64(key.c_str());
}

auto db::MariaDBCppResultSet::rawGetUInt64(const std::string& key) const -> uint64
{
    return resultSet_->getUInt64(key.c_str());
}

auto db::MariaDBCppResultSet::rawGetInt32(const std::string& key) const -> int32
{
    return resultSet_->getInt(key.c_str());
}

auto db::MariaDBCppResultSet::rawGetUInt32(const std::string& key) const -> uint32
{
    return resultSet_->getUInt(key.c_str());
}

auto db::MariaDBCppResultSet::rawGetInt16(const std::string& key) const -> int16
{
    return static_cast<int16>(resultSet_->getInt(key.c_str()));
}

auto db::MariaDBCppResultSet::rawGetUInt16(const std::string& key) const -> uint16
{
    return static_cast<uint16>(resultSet_->getUInt(key.c_str()));
}

auto db::MariaDBCppResultSet::rawGetInt8(const std::string& key) const -> int8
{
    // There is only a signed byte accessor
    return static_cast<int8>(resultSet_->getByte(key.c_str()));
}

auto db::MariaDBCppResultSet::rawGetUInt8(const std::string& key) const -> uint8
{
    // There isn't an unsigned byte accessor, so we'll just use getUInt
    return static_cast<uint8>(resultSet_->getUInt(key.c_str()));
}

auto db::MariaDBCppResultSet::rawGetBool(const std::string& key) const -> bool
{
    return resultSet_->getBoolean(key.c_str());
}

auto db::MariaDBCppResultSet::rawGetFloat(const std::string& key) const -> float
{
    return resultSet_->getFloat(key.c_str());
}

auto db::MariaDBCppResultSet::rawGetDouble(const std::string& key) const -> double
{
    return resultSet_->getDouble(key.c_str());
}

auto db::MariaDBCppResultSet::rawGetString(const std::string& key) const -> std::string
{
    return resultSet_->getString(key.c_str()).c_str();
}

auto db::MariaDBCppResultSet::rawGetBlobBytes(const std::string& key) const -> std::string
{
    // Preserve the full blob length, including embedded nulls, rather than truncating at the first
    // null the way a c_str()-based conversion would.
    const auto blob = resultSet_->getString(key.c_str());
    return std::string(blob.c_str(), blob.length());
}
