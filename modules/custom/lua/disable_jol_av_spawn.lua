-----------------------------------
require('modules/module_utils')
-----------------------------------
local m = Module:new('disable_jol_av_spawn')
-----------------------------------

m:addOverride('xi.zones.AlTaieu.mobs.Jailer_of_Love.onMobDespawn', function(mob)
end)

return m
