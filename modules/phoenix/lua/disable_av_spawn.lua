-----------------------------------
-- Disables the chance for Absolute Virtue to spawn after defeating Jailer of Love
-- For use while Absolute Virtue code is experimental
-- phoenix/lua/disable_av_spawn.lua
-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('disable_jol_av_spawn')

m:addOverride('xi.zones.AlTaieu.mobs.Jailer_of_Love.onMobDespawn', function(mob)
end)

return m
