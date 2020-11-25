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

function getLicense(source)
	local steamid  = false
    local license  = false
    local discord  = false
    local xbl      = false
    local liveid   = false
    local ip       = false

	for k,v in pairs(GetPlayerIdentifiers(source))do
			
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamid = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xbl  = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			ip = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		end
	end

	return license:gsub("license:","")
end

RegisterNetEvent("fox:data:addPlayer")
AddEventHandler("fox:data:addPlayer", function(infos)
    local returnedInfos = infos
    returnedInfos.sID = source
    returnedInfos.license = getLicense(source)
    addPlayer(source,returnedInfos)
end)


RegisterNetEvent("fox:data:request")
AddEventHandler("fox:data:request", function()
    local _src = source
    if not Fox.players[_src] then 
        Fox.trace("^1[PLAYERS] ^7"..GetPlayerName(_src).." tryied to get player but doesnt exists")
        return 
    end
    local l = getLicense(_src)
    while l == nil do Citizen.Wait(10) end
    Fox.players[_src].inventory = getPlayerInventory(_src)
    while not Fox.players[_src].inventory do Citizen.Wait(10) end
    TriggerClientEvent("fox:data:update", _src, true, Fox.players[_src])
end)

AddEventHandler('playerDropped', function (reason)
    local _src = source
    Fox.trace("^1[PLAYERS] ^7"..GetPlayerName(_src).." disconnected: ^3"..reason.."^7")
    Fox.players[_src] = nil
  end)