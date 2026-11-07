-----------------------------------
-- Phoenix version of the systems/guild_shops/price_curves.lua case for Tsutsuroon's Iron Sand.
-- phoenix/lua/data/era_guild_shops.lua sets its era price ceiling (buyMax 3074), the price at empty stock.
-----------------------------------
describe('Guild shop price curves', function()
    describe('Tsutsuroon', function()
        it('buy -- Iron Sand at the era price ceiling', function()
            local player = xi.test.world:spawnPlayer({ zone = xi.zone.NASHMAU })
            player:addKeyItem(xi.keyItem.TENSHODO_MEMBERS_CARD)
            player.entities:gotoAndTrigger('Tsutsuroon')

            local state = xi.guildShops.state['Tsutsuroon']
            state.items[xi.item.HANDFUL_OF_IRON_SAND].stock = 1
            state.lastRoll = -1 -- the next roll locks the price from the seeded stock, with no restock

            local entry = player.actions:guildBuyList()[xi.item.HANDFUL_OF_IRON_SAND]
            assert(entry and entry.price == 3074, 'Iron Sand @ stock 1: got ' .. tostring(entry and entry.price))
        end)
    end)
end)
