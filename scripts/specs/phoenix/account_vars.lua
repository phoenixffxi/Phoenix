---@meta

-- Added at runtime by modules/phoenix/cpp/account_vars.cpp.
-- luacheck: ignore 241
---@class CBaseEntity
local CBaseEntity = {}

---@nodiscard
---@param varName string
---@return integer
function CBaseEntity:getAccountVar(varName)
end

-- A value of 0 deletes the variable.
---@param varName string
---@param value integer
---@param expiry integer?
---@return nil
function CBaseEntity:setAccountVar(varName, value, expiry)
end
