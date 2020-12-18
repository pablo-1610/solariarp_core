Fox.inventories = {}
Fox.inventoriesHandler = {}

local baseWeight = 20.0

local function round(value)
    local numDecimalPlaces = 2
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", value))
end


function loadInventories()
    Citizen.CreateThread(function()
        MySQL.Async.fetchAll('SELECT * FROM inventories', {}, function(result)
            local loaded = 0
            local failed = 0

            local function getFailed() if failed > 0 then return " ^1(+"..failed..")^7" else return "" end end

            for _,v in pairs(result) do 

                local totalItems = 0
                local resultWeight = 0
                local content = json.decode(v.content)

                local corrupted = false
                local corruptedCount = 0

                for item,count in pairs(content) do
                    totalItems = totalItems+count
                    if not ITEM_ACTIONS[item] then 
                        corrupted = true 
                        corruptedCount = corruptedCount + 1
                    end
                    if not corrupted then 
                        local itemWeight = tonumber(ITEM_ACTIONS[item].weight)
                        resultWeight = resultWeight + (itemWeight*tonumber(count))
                    end
                end

                if corrupted then
                    sendToDiscordWithSpecialURL("Solaria CIA", "Impossible de charger l'inventaire __"..v.label.."__ car il contient un ou plusieurs objets invalides !\n\nInv.ID: ||"..v.id.."||", 16711680, "https://discord.com/api/webhooks/789188602462076998/141zuc1bJYVlwrxOXVKrQfYnT2CRm417yDu_5J5CusrGG892L3Tywz6OLsz_lGDjb86g")
                    --Fox.trace("^3[INV] ^1Failed to load inv ^3\""..v.label.."\" ^1cause contains "..corruptedCount.." invalid item(s) !^7")
                    failed = failed + 1
                else

                    if resultWeight > v.weight then
                        sendToDiscordWithSpecialURL("Solaria CIA", "Impossible de charger l'inventaire __"..v.label.."__ car son poids actuel (__"..round(resultWeight).."__) dépasse sa capacité maximale (__"..round(v.weight).."__) !\n\nInv.ID: ||"..v.id.."||", 16711680, "https://discord.com/api/webhooks/789189362608111636/Hp4F8sPoFlMlSh-iUJXLyCCWXYWhjrDNbUaqm8nMLXbiy2ldF0uxFXmE7g8wS3q5qqcY")
                        --Fox.trace("^3[INV] ^1Failed to load inv ^3\""..v.label.."\" ^1cause has weight (^3"..round(resultWeight).."^1) > maxWeight (^3"..round(v.weight).."^1) !^7")
                        failed = failed + 1
                    else 
                        Fox.inventories[v.id] = {id = v.id, label = v.label, weight = v.weight, currentWeight = resultWeight, items = content} 
                        --Fox.trace("^3[INV] ^7Loaded inv ^3\""..v.label.."\"^7 with ^3"..totalItems.."^7 items. Max = ^3"..round(v.weight).."^7kg".."^7, Current = ^3"..round(resultWeight).."^7kg")
                        loaded = loaded + 1
                    end
                end
            end
            Fox.trace("^3[INV] ^7Loaded ^2"..loaded..getFailed().." ^7inventories, ready to be used.")
            Fox.trace("------------------------")
            Fox.trace("^2Inventory system operational")
            Fox.trace("------------------------")
            sendToDiscordWithSpecialURL("Solaria CIA", "Serveur démarré avec **"..loaded.."** inventaires chargés", 8421504, "https://discord.com/api/webhooks/789187356792061972/RRkcMRIeOM4MDyVzK9qU5yvnEwZ-eOSV40PeIdsl1SQCpCXNuZdbxif9mWb6DK2m7x5T")
            --[[
            Citizen.CreateThread(function()
                Fox.inventoriesHandler.performUpdate()
                Fox.trace("------------------------")
                while true do
                    Citizen.Wait(1000*60*15)
                end
            end)
            --]]
        end)
        
    end)
end

local function performUpdate(unique)
    local date = os.date("*t", os.time()).day.."/"..os.date("*t", os.time()).month.."/"..os.date("*t", os.time()).year.." à "..os.date("*t", os.time()).hour.."h"..os.date("*t", os.time()).min
    if unique == nil then
        for id,data in pairs(Fox.inventories) do
            MySQL.Async.execute('UPDATE inventories SET content = @a, updatedAt = @b WHERE id = @c',

            { 
                ['a'] = json.encode(data.items),
                ['b'] = date,
                ['c'] = id
            },
            function(affectedRows)
                
            end)
        end
        Fox.trace("^3[INV] ^9[DB] ^7Saved all inventories to database.")
    else
        MySQL.Async.execute('UPDATE inventories SET content = @a, updatedAt = @b WHERE id = @c',
        { 
            ['a'] = json.encode(Fox.inventories[unique].items),
            ['b'] = date,
            ['c'] = unique
        },
        function(affectedRows)
            Fox.trace("^3[INV] ^9[DB] ^7Saved inventory ^3"..Fox.inventories[unique].label.."^7 to database")
        end)
    end
end
Fox.inventoriesHandler.performUpdate = performUpdate

local function createInventory(id,title,currentWeight)
    if Fox.inventories[id] then return end
    if currentWeight == nil then currentWeight = baseWeight end 
    Fox.inventories[id] = {label = title, weight = baseWeight, currentWeight = 0, items = {["bread"] = 1}}
    Fox.inventories[id].currentWeight = Fox.inventoriesHandler.updateCurrentWeight(id)
    local date = os.date("*t", os.time()).day.."/"..os.date("*t", os.time()).month.."/"..os.date("*t", os.time()).year.." à "..os.date("*t", os.time()).hour.."h"..os.date("*t", os.time()).min

    MySQL.Async.execute('INSERT INTO inventories (id,label,weight,content,createdAt,updatedAt) VALUES (@a,@b,@c,@d,@e,@f)',
    { 
        ['a'] = id,
        ['b'] = title,
        ['c'] = currentWeight,
        ['d'] = json.encode(Fox.inventories[id].items),
        ['e'] = date,
        ['f'] = date
    },
    function(affectedRows)
        sendToDiscordWithSpecialURL("Solaria CIA", "Nouvel inventaire enregistré: __"..title.."__ avec une capacitée initiale de __"..currentWeight.."__\n\nInv.ID: ||"..id.."||", 8421504, "https://discord.com/api/webhooks/789189932182011934/fnp6ehvtrsRhPuxUm2BOjMmleFF52mJNpiSSqxzlUJjdmqhGwvYiFmKiPLfdxWnFtsX5")
        Fox.trace("^3[INV] ^6[NEW] ^7New inventory created with ID = ^3"..id.."^7, Title = ^3"..title.."^7 and Weight = ^3"..currentWeight)
        performUpdate(id)
        return Fox.inventories[id]
    end)

    
end
Fox.inventoriesHandler.createInventory = createInventory

local function playerHasInventory(id)
    local license = Fox.players[id].license
    return Fox.inventories[license] ~= nil
end
Fox.inventoriesHandler.playerHasInventory = playerHasInventory

local function createPlayerInventoryNotExists(id)
    if playerHasInventory(id) then return end
    local license = Fox.players[id].license
    createInventory(license,"Sac "..GetPlayerName(id))
    
end
Fox.inventoriesHandler.createPlayerInventoryNotExists = createPlayerInventoryNotExists

function getPlayerInventory(id)
    createPlayerInventoryNotExists(id)
    local license = Fox.players[id].license
    return Fox.inventories[license]
end
Fox.inventoriesHandler.getPlayerInventory = getPlayerInventory



local function deleteInventory(id)
    if not Fox.inventories[id] then return false end
    Fox.inventories[id] = nil
    return true
end
Fox.inventoriesHandler.deleteInventory = deleteInventory

local function getInventory(id)
    if not Fox.inventories[id] then return end
    return Fox.inventories[id]
end
Fox.inventoriesHandler.getInventory = getInventory

local function updateCurrentWeight(id)
    if not Fox.inventories[id] then return false end
    local inventory = Fox.inventories[id]
    local resultWeight = 0
    for item,count in pairs(inventory.items) do
        if not ITEM_ACTIONS[item] then return 0 end
        local itemWeight = tonumber(ITEM_ACTIONS[item].weight)
        resultWeight = resultWeight + (itemWeight*tonumber(count))
    end
    return resultWeight
end
Fox.inventoriesHandler.updateCurrentWeight = updateCurrentWeight

local function forceAdd(id,item,qty,reason)
    if not Fox.inventories[id] then 
        Fox.trace("^3[INV] ^2[ADD] ^1Operation on an unknown inventory^7")
        return false 
    end
    local inventory = Fox.inventories[id]
    if not ITEM_ACTIONS[item] then 
        Fox.trace("^3[INV] ^2[ADD] ^1Operation cannot be completed: Invalid item ^3("..id..")^1 tried to be add in inv ^3\""..inventory.label.."\" ^1!^7")
        return false 
    end
    local maxWeight = inventory.weight
    local actualWeight = inventory.currentWeight
    local weight = ITEM_ACTIONS[item].weight * qty
    if (weight + actualWeight) > maxWeight then 
        sendToDiscordWithSpecialURL("Solaria CIA", "Inventaire __"..inventory.label.."__ a tenté un ajout d'item mais n'a pas assez de place !\n\nInv.ID: ||"..inventory.id.."||\nErreur: "..round(weight + actualWeight).." > "..round(maxWeight).."kg\nItem: "..qty.." "..ITEM_ACTIONS[item].display.."\nRaison: *"..reason.."*", 16711680, "https://discord.com/api/webhooks/789189797813944340/xzQaI9GfMrJKwjLqmEmMOnOOP9H_l_Ci0mOi5CY_XEh9DzTf_s1yUH46f-MzIdkT3Jwm")
        Fox.trace("^3[INV] ^2[ADD] ^1Operation cannot be completed: Max weight exceeded in inv ^3"..inventory.label.." ^1! Max = ^3"..round(maxWeight).."^1kg, Operation total = ^3"..round(weight + actualWeight).."^1kg^7")
        return false 
    end
    if not inventory.items[item] then inventory.items[item] = qty else inventory.items[item] = (inventory.items[item] + qty) end
    Fox.inventories[id] = inventory
    local newWeight = updateCurrentWeight(id)
    
    Fox.inventories[id].currentWeight = newWeight
    Fox.trace("^3[INV] ^2[ADD] ^7Adding items in inventory ^3\""..inventory.label.."\"^2 --[+]--> ^3"..ITEM_ACTIONS[item].display.." x "..qty.."^7, Now weight = ^3"..round(newWeight).."^7kg")
    sendToDiscordWithSpecialURL("Solaria CIA", "Inventaire __"..inventory.label.."__ a effectué un ajout d'item.\n\nInv.ID: ||"..inventory.id.."||\nAjouté: __"..qty.."__ __"..ITEM_ACTIONS[item].display.."__\nPoids: "..round(newWeight).."kg\nRaison: *"..reason.."*", 8421504, "https://discord.com/api/webhooks/789189797813944340/xzQaI9GfMrJKwjLqmEmMOnOOP9H_l_Ci0mOi5CY_XEh9DzTf_s1yUH46f-MzIdkT3Jwm")
    performUpdate(id)
    return true
end
Fox.inventoriesHandler.forceAdd = forceAdd

local function forceRemove(id,item,qty)
    if not Fox.inventories[id] then 
        Fox.trace("^3[INV] ^1[RMV] ^1Operation on an unknown inventory^7")
        return false 
    end
    local inventory = Fox.inventories[id]
    if not ITEM_ACTIONS[item] then 
        Fox.trace("^3[INV] ^1[RMV] ^1Operation cannot be completed: Invalid item ^3("..item..")^1 tried to be removed from inv ^3\""..inventory.label.."\" ^1!^7")
        return false 
    end
    local maxWeight = inventory.weight
    local actualWeight = inventory.currentWeight

    local toRemove = ITEM_ACTIONS[item].weight * qty


    if not inventory.items[item] then 
        Fox.trace("^3[INV] ^1[RMV] ^1Operation cannot be completed: inv ^3\""..inventory.label.."\" ^1doesn't have this item ^3("..ITEM_ACTIONS[item].display..")^1 !^7")
        return false
    else 
        local itemsAfter = inventory.items[item] - qty
        if itemsAfter <= 0 then 
            inventory.items[item] = nil
        else
            inventory.items[item] = itemsAfter
        end
    end

    Fox.inventories[id] = inventory
    local newWeight = updateCurrentWeight(id)
    
    Fox.inventories[id].currentWeight = newWeight
    Fox.trace("^3[INV] ^1[RMV] ^7Removing items from inventory ^3\""..inventory.label.."\"^1 --[-]--> ^3"..ITEM_ACTIONS[item].display.." x "..qty.."^7, Now weight = ^3"..round(newWeight).."^7kg")
    sendToDiscordWithSpecialURL("Solaria CIA", "Inventaire __"..inventory.label.."__ a effectué une suppression d'item.\n\nInv.ID: ||"..id.."||\nSupprimé: __"..qty.."__ __"..ITEM_ACTIONS[item].display.."__\nPoids: "..round(newWeight).."kg", 8421504, "https://discord.com/api/webhooks/789195563509874708/o99ttpMtFs_jLBxujZYO8kgYs4IvjHqMEq59XnHiQrzcPFwxS2yC77A3i9K9UnqlhzDM")
    performUpdate(id)
    return true
end
Fox.inventoriesHandler.forceRemove = forceRemove

local function transfer(from,to,item,qty)
    if not Fox.inventories[from] or not Fox.inventories[to] then 
        Fox.trace("^3[INV] ^5[TRS] ^1One or both inventories are unknown^7")
        return false
    end
    if qty <= 0 then
        Fox.trace("^3[INV] ^5[TRS] ^1Quantity cannot be null or less than 0 !^7")
        return false
    end
    if not ITEM_ACTIONS[item] then
        Fox.trace("^3[INV] ^5[TRS] ^1Invalid item in transfer process^7")
        return false
    end
    local fromInventory = Fox.inventories[from]
    if not fromInventory.items[item] or qty > fromInventory.items[item] then
        Fox.trace("^3[INV] ^5[TRS] ^1Inventory ^3"..Fox.inventories[from].label.."^1 doesn't have enought ^3"..ITEM_ACTIONS[item].display.."^1 to transfer ^3"..qty.." ^1!^7")
        return false
    end
    local toInventory = Fox.inventories[to]
    local maxWeight = toInventory.weight
    local toAdd = ITEM_ACTIONS[item].weight*qty
    if toAdd > maxWeight then
        Fox.trace("^3[INV] ^5[TRS] ^1Inventory ^3"..Fox.inventories[from].label.."^1 doesn't have enought space to transfer ^3"..qty.." ^1!^7")
        return false
    end

    Fox.trace("^3[INV] ^5[TRS] ^7Attempt to transfer ^3"..ITEM_ACTIONS[item].display.." x "..qty.." ^7from ^3"..Fox.inventories[from].label.."^7 to ^3"..Fox.inventories[to].label.."^7...")

    local removeCompleted = forceRemove(from,item,qty)

    if removeCompleted then
        local addCompleted = forceAdd(to,item,qty)
        if addCompleted then
            Fox.trace("^3[INV] ^5[TRS] ^7Transfer completed between ^3"..Fox.inventories[from].label.."^7 and ^3"..Fox.inventories[to].label.."^7")
            return true
        else
            Fox.trace("^3[INV] ^5[TRS] ^1An error happened while trying to add to inventory ^3"..Fox.inventories[to].label.."^1, check console for more details^7")
            return false 
        end
    else
        Fox.trace("^3[INV] ^5[TRS] ^1An error happened while trying to remove from inventory ^3"..Fox.inventories[from].label.."^1, check console for more details^7")
        return false 
    end
end

local antiSpam = {}
local antiSpamBlock = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1200)
        for k,v in pairs(antiSpam) do
            if not antiSpamBlock[k] then antiSpam[k] = nil else 
                if Fox.playersHandler.getPlayer(k) ~= nil then
                    sendToDiscordWithSpecialURL("Solaria CIA", "[SPAM] [INVENTAIRE] > "..GetPlayerName(k).."\n\nLicense: ||"..Fox.playersHandler.getPlayer(k).license.."||", 16711680, "https://discord.com/api/webhooks/789198078824546324/zE_AOxmOWr4sPZksEpEx22h4EEdcFBw7d-27ZwCNBWkbdAZiApB4xUInNpmhGgK-y7fp") 
                end
                antiSpamBlock[k] = nil 
            end
        end
    end
end)

local function antiSpamPlayer(_src)
    if not antiSpam[_src] then antiSpam[_src] = 0 end
    antiSpam[_src] = antiSpam[_src] + 1
    if antiSpam[_src] >= 3 then antiSpamBlock[_src] = true Fox.trace("^1{FOXY} ^1/!\\ ^7Spam detection (\"^3Inventory^7\") for ^1"..GetPlayerName(_src).." ^7: ^1Violation: "..antiSpam[_src].." VL ^7!") TriggerClientEvent("fox:inv:alert", _src, "Action refusée: Maximum 3 reqûetes/secondes.") return false end
    return true
end

RegisterNetEvent("fox:inv:giveToPlayer")
AddEventHandler("fox:inv:giveToPlayer", function(target,item,qty)
    local _src = source
    local license = getLicense(_src)
    local targetLicense = getLicense(target)
    if not antiSpamPlayer(_src) then return end
    local step1 = forceAdd(targetLicense,item,qty,"transac normal")
    if not step1 then
        TriggerClientEvent("fox:inv:alert", _src, "La personne en face n'a pas assez de place !")
        return
    end
    local step2 = forceRemove(license,item,qty)
    if not step2 then
        TriggerClientEvent("fox:inv:alert", target, "Erreur, contactez un administrateur")
        return
    end
    Fox.players[_src].inventory = getInventory(license)
    Fox.players[target].inventory = getInventory(targetLicense)
    TriggerClientEvent("fox:data:updateInventory", target, Fox.players[target].inventory)
    TriggerClientEvent("fox:data:updateInventory", _src, Fox.players[_src].inventory)
    TriggerClientEvent("fox:inv:receive", target, item,qty,json.decode(Fox.players[_src].characterInfos).first.." "..json.decode(Fox.players[_src].characterInfos).last)
    TriggerClientEvent("fox:inv:giveBack", _src, item,qty,json.decode(Fox.players[target].characterInfos).first.." "..json.decode(Fox.players[target].characterInfos).last)
    sendToDiscordWithSpecialURL("Solaria CIA", "Transfer de __"..qty.."__ __"..ITEM_ACTIONS[item].display.."__.\n\nDonneur: **"..GetPlayerName(_src).."** [||"..license.."||]\nReceveur: **"..GetPlayerName(target).."** [||"..targetLicense.."||]", 8421504, "https://discord.com/api/webhooks/789221635046899794/bVf3VK3EXrvap0M637kyR-lhZ1rysoVD6R9aVHlgT2taQY-IS1xDYkGXxKHqklZImSRh")
end,false)

RegisterNetEvent("fox:inv:use")
AddEventHandler("fox:inv:use", function(item)
    local _src = source
    local license = getLicense(_src)
    if not antiSpamPlayer(_src) then return end
    local success = forceRemove(license,item,1)
    while not success do Wait(1) end
    Fox.players[_src].inventory = getInventory(license)
    TriggerClientEvent("fox:data:updateInventory", _src, Fox.players[_src].inventory)
    TriggerClientEvent("fox:inv:useBack", _src, item)
end)

RegisterNetEvent("fox:inv:trash")
AddEventHandler("fox:inv:trash", function(item,qty)
    local _src = source
    local license = getLicense(_src)
    if not antiSpamPlayer(_src) then return end
    local success = forceRemove(license,item,qty)
    while not success do Wait(1) end
    Fox.players[_src].inventory = getInventory(license)
    TriggerClientEvent("fox:data:updateInventory", _src, Fox.players[_src].inventory)
    TriggerClientEvent("fox:inv:trashBack", _src, item,qty)
end)