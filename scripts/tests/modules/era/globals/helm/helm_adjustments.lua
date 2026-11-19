-----------------------------------
-- Era HELM: removes the 2008-2011 additions from existing zone gathering pools.
-----------------------------------
local moduleTest = require('scripts.tests.helpers.modules')

describe('Era HELM adjustments', function()
    local function expectRemoved(helmType, zoneId, itemIds)
        local drops = xi.helm.dataTable[helmType].zone[zoneId].drops
        assert(#drops > 0, string.format('zone %d: the pool is empty', zoneId))

        for _, itemId in ipairs(itemIds) do
            for _, entry in ipairs(drops) do
                assert(entry[2] ~= itemId, string.format('zone %d still gives item %d', zoneId, itemId))
            end
        end
    end

    it('applies its overrides', function()
        moduleTest.assertOverridesApplied('modules/era/lua/globals/helm/helm_adjustments.lua')
    end)

    it('removes Butterpear and the late logs from Yhoator Jungle logging', function()
        expectRemoved(xi.helmType.LOGGING, xi.zone.YHOATOR_JUNGLE, { xi.item.BUTTERPEAR, xi.item.AQUILARIA_LOG, xi.item.KAPOR_LOG })
    end)

    describe('every removal #exhaustive', function()
        it('removes the Abyssea era logging additions', function()
            expectRemoved(xi.helmType.LOGGING, xi.zone.YUHTUNGA_JUNGLE, { xi.item.BUTTERPEAR, xi.item.AQUILARIA_LOG, xi.item.KAPOR_LOG })
        end)

        it('removes the WotG era harvesting additions', function()
            expectRemoved(xi.helmType.HARVESTING, xi.zone.BHAFLAU_THICKETS, { xi.item.EASTERN_GINGER_ROOT })
            expectRemoved(xi.helmType.HARVESTING, xi.zone.WAJAOM_WOODLANDS, { xi.item.EASTERN_GINGER_ROOT })
            expectRemoved(xi.helmType.HARVESTING, xi.zone.GIDDEUS, { xi.item.SPRIG_OF_DYERS_WOAD })
            expectRemoved(xi.helmType.HARVESTING, xi.zone.WEST_SARUTABARUTA, { xi.item.SPRIG_OF_DYERS_WOAD })
        end)

        it('removes the WotG era mining additions', function()
            expectRemoved(xi.helmType.MINING, xi.zone.HALVUNG, { xi.item.SLAB_OF_PLUMBAGO })
            expectRemoved(xi.helmType.MINING, xi.zone.MOUNT_ZHAYOLM, { xi.item.SLAB_OF_PLUMBAGO })
        end)
    end)
end)
