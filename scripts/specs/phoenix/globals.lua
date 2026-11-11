---@meta

-- Global functions Phoenix's C++ modules add at runtime.
-- luacheck: ignore 111

-- Added by modules/phoenix/cpp/account_jail.cpp, oldest character first.
---@nodiscard
---@param charName string
---@return { name: string, played: boolean }[]
function GetAccountCharacters(charName)
end

-- Added by modules/phoenix/cpp/account_jail.cpp, false if the character never played.
---@param charId integer
---@return boolean
function PardonOffline(charId)
end

-- Added by modules/phoenix/cpp/fishing_history.cpp, newest first with limit clamped to 1-50.
---@nodiscard
---@param charName string
---@param limit integer
---@return { itemId: integer, itemName: string, count: integer, zoneId: integer, zoneName: string, caughtAt: integer }[]
function GetFishingHistory(charName, limit)
end

-- Added by modules/phoenix/cpp/fishing_history.cpp, zeros if the angler has no records.
---@nodiscard
---@param charName string
---@return { linesCast: integer, longestIlms: integer, longestName: string, heaviestPonzes: integer, heaviestName: string }
function GetFishingRecords(charName)
end

-- Added by modules/phoenix/cpp/player_count.cpp.
---@nodiscard
---@return integer
function GetOnlinePlayerCount()
end

-- Added by modules/phoenix/cpp/gil_audit.cpp.
---@param charId integer
---@param source integer
---@param detail string?
---@param counterparty integer?
function __gilAuditSetReason(charId, source, detail, counterparty)
end

-- Added by modules/phoenix/cpp/gil_audit.cpp.
function __gilAuditRetireReason()
end

-- A core binding (src/map/lua/luautils.cpp) missing from .vscode/settings.json, called by the era module.
function ReloadExperienceData()
end
