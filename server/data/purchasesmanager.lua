Fox.purchases = {}

local function getCash(_src)
    return Fox.players[_src].accounts["cash"]
end
Fox.purchases.getCash = getCash

local function canAfford(_src,price)
    return Fox.players[_src].accounts["cash"] >= price
end
Fox.purchases.canAfford = canAfford