Fox.localData = {}

Fox.localData.self = {}
Fox.localData.target = {}
Fox.localData.awaitingUpdate = false

RegisterNetEvent("fox:data:updateInventory")
AddEventHandler("fox:data:updateInventory", function(receivedData)
    Fox.localData.self.inventory = receivedData
    Fox.trace("Inventory data updated")
    Fox.localData.awaitingUpdate = false
end)

RegisterNetEvent("fox:data:update")
AddEventHandler("fox:data:update", function(mine,receivedData)
    receivedData.accounts = json.decode(receivedData.accounts)
    if mine then 
        local firstReception = false
        firstReception = Fox.localData.self.sID == nil 
        Fox.localData.self = receivedData
        Fox.trace("Self data received")
        if firstReception then Fox.hud.init() end
    else
        Fox.localData.target = receivedData
        Fox.trace("Other player data received")
    end
    Fox.localData.awaitingUpdate = false
end)

RegisterCommand("testi", function(source, args, rawcommand)
    TriggerServerEvent("fox:data:requestUpdateSelfInventory")
end, false)