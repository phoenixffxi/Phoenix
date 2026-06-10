-----------------------------------
-- Guild Shop Price Floor
-----------------------------------
xi = xi or {}

---@enum xi.guildPriceFloor
xi.guildPriceFloor =
{
    THREE_QUARTER_MAX = 0, -- buy-price floor at 3/4 * maxStock
    TARGET_STOCK      = 1, -- buy-price floor at targetStock
}
