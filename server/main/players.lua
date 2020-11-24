Fox.players = {}
Fox.playersHandler = {}

local function getOtherPlayerData(target)
    if not Fox.players[target] or not Fox.players[source]  then return end
    TriggerClientEvent("fox:data:update", source, false, Fox.players[target])
end
Fox.playersHandler.getOtherPlayerData = getOtherPlayerData

local function forceUpdate(target)
    if not Fox.players[target] then return end
    TriggerClientEvent("fox:data:update", target, true, Fox.players[target])
end
Fox.playersHandler.forceUpdate = forceUpdate

local function getPlayers()
    return Fox.players
end 
Fox.playersHandler.getPlayers = getPlayers

local function getPlayer(source)
    return Fox.utils.tableNotNil(Fox.players[source])
end
Fox.playersHandler.getPlayer = getPlayer

local function addPlayer(source,receivedData) 
    if Fox.players[source] then return end
    Fox.players[source] = receivedData
end
Fox.playersHandler.addPlayer = addPlayer

local function getAccount(source,account)
    local player = Fox.utils.tableNotNil(Fox.players[source])
    return Fox.utils.tableNotNil(player.accounts[account])
end
Fox.playersHandler.getAccount = getAccount

local function getAccountMoney(source,account)
    local player = Fox.utils.tableNotNil(Fox.players[source])
    local account = getAccount(source,account)
    return account.value
end
Fox.playersHandler.getAccountMoney = getAccountMoney

local function addMoney(source,account,ammount)
    local player = getPlayer(source)
    local account = getAccount(source,account)
    account.value = account.value + ammount
    return true
end
Fox.playersHandler.addMoney = addMoney

local function removeMoney(source,account,ammount)
    local player = getPlayer(source)
    local account = getAccount(source,account)
    local dest = account.value - ammount
    if dest >= 0 then account.value = dest end
    return true
end
Fox.playersHandler.removeMoney = removeMoney


RegisterNetEvent("fox:data:addPlayer")
AddEventHandler("fox:data:addPlayer", function(infos)
    local returnedInfos = infos
    returnedInfos.sID = source
    addPlayer(source,returnedInfos)
end)

RegisterNetEvent("fox:data:request")
AddEventHandler("fox:data:request", function()
    if not Fox.players[source] then return end
    TriggerClientEvent("fox:data:update", source, true, Fox.players[source])
end)