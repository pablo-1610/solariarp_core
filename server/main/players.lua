Fox.players = {}

local function getPlayers()
    return Fox.players
end 

local function getPlayer(source)
    return Fox.utils.tableNotNil(Fox.players[source])
end

local function getAccount(source,account)
    local player = Fox.utils.tableNotNil(Fox.players[source])
    return Fox.utils.tableNotNil(player.accounts[account])
end

local function getAccountMoney(source,account)
    local player = Fox.utils.tableNotNil(Fox.players[source])
    local account = getAccount(source,account)
    return account.value
end

local function addMoney(source,account,ammount)
    local player = getPlayer(source)
    local account = getAccount(source,account)
    account.value = account.value + ammount
    return true
end

local function removeMoney(source,account,ammount)
    local player = getPlayer(source)
    local account = getAccount(source,account)
    local dest = account.value - ammount
    if dest >= 0 then account.value = dest end
    return true
end