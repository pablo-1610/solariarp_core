Fox.inventories = {}
Fox.inventoriesHandler = {}

local baseWeight = 20.0

local function round(value)
    local numDecimalPlaces = 2
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", value))
end


Citizen.CreateThread(function()
    Citizen.Wait(3000)
    
    MySQL.Async.fetchAll('SELECT * FROM inventories', {}, function(result)
        local loaded = 0
        local failed = 0

        local function getFailed() if failed > 0 then return " ^1(+"..failed..")^7" else return "" end end

        for _,v in pairs(result) do 

            local totalItems = 0
            local resultWeight = 0
            local content = json.decode(v.content)

            for item,count in pairs(content) do
                totalItems = totalItems+count
                local itemWeight = tonumber(ITEM_ACTIONS[item].weight)
                resultWeight = resultWeight + (itemWeight*tonumber(count))
            end

            if resultWeight > v.weight then
                Fox.trace("^3[INV] ^1Failed to load inv ^3\""..v.label.."\" ^1cause has weight (^3"..round(resultWeight).."^1) > maxWeight (^3"..round(v.weight).."^1) !^7")
                failed = failed + 1
            else 
                Fox.inventories[v.id] = {id = v.id, label = v.label, weight = v.weight, currentWeight = resultWeight, items = content} 
                Fox.trace("^3[INV] ^7Loaded inv ^3\""..v.label.."\"^7 with ^3"..totalItems.."^7 items. Weight = ^3"..round(v.weight).."^7kg".."^7, Current = ^3"..round(resultWeight).."^7kg")
                loaded = loaded + 1
            end
        end
        Fox.trace("^3[INV] ^7Loaded ^2"..loaded..getFailed().." ^7inventories, ready to be used.")
    end)
    
end)

local function createInventory(id,title,currentWeight)
    if Fox.inventories[id] then return end
    if currentWeight == nil then currentWeight = baseWeight end 
    Fox.inventories[id] = {label = title, weight = baseWeight, currentWeight = 0, items = {}}
    return Fox.inventories[id]
end
Fox.inventoriesHandler.createInventory = createInventory


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



local function forceAdd(id,item,qty)

    if not Fox.inventories[id] then 
        Fox.trace("^3[INV] ^2[ADD] ^1Operation on an unknown inventory")
        return false 
    end
    local inventory = Fox.inventories[id]
    if not ITEM_ACTIONS[item] then 
        Fox.trace("^3[INV] ^2[ADD] ^1Invalid item ^3("..id..")^1 tried to be add in inv ^3\""..inventory.label.."\" ^1!")
        return false 
    end
    local maxWeight = inventory.weight
    local actualWeight = inventory.currentWeight
    local weight = ITEM_ACTIONS[item].weight * qty
    if (weight + actualWeight) > maxWeight then 
        Fox.trace("^3[INV] ^2[ADD] ^1Max weight exceeded inv ^3\""..inventory.label.."\" ^1! Max = ^3"..round(maxWeight).."^7, Total op. = ^3"..round(weight + actualWeight).."^7kg")
        return false 
    end
    if not inventory.items[item] then inventory.items[item] = qty else inventory.items[item] = (inventory.items[item] + qty) end
    Fox.inventories[id] = inventory
    local newWeight = updateCurrentWeight(id)
    
    Fox.inventories[id].currentWeight = newWeight
    Fox.trace("^3[INV] ^2[ADD] ^7Adding items in inventory ^3\""..inventory.label.."\"^2 ——[+]——> ^3"..ITEM_ACTIONS[item].display.." x "..qty.."^7, Now weight = ^3"..round(newWeight).."^7kg")
    return true
end
Fox.inventoriesHandler.forceAdd = forceAdd

local function forceRemove(id,item,qty)
    if not Fox.inventories[id] then 
        Fox.trace("^3[INV] ^1[RMV] ^1Operation on an unknown inventory")
        return false 
    end
    local inventory = Fox.inventories[id]
    if not ITEM_ACTIONS[item] then 
        Fox.trace("^3[INV] ^1[RMV] ^1Invalid item ^3("..item..")^1 tried to be removed from inv ^3\""..inventory.label.."\" ^1!")
        return false 
    end
    local maxWeight = inventory.weight
    local actualWeight = inventory.currentWeight

    local toRemove = ITEM_ACTIONS[item].weight * qty


    if not inventory.items[item] then 
        Fox.trace("^3[INV] ^1[RMV] ^1Operation cannot be completed: inv ^3\""..inventory.label.."\" ^1doesn't have this item ^3("..ITEM_ACTIONS[item].display..")^1 !")
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
    Fox.trace("^3[INV] ^1[RMV] ^7Removing items from inventory ^3\""..inventory.label.."\"^1 ——[-]——> ^3"..ITEM_ACTIONS[item].display.." x "..qty.."^7, Now weight = ^3"..round(newWeight).."^7kg")
    return true
end
Fox.inventoriesHandler.forceRemove = forceRemove

local function transfer(from,to,item,qty)
    if not Fox.inventories[from] or not Fox.inventories[to] then 
        Fox.trace("^3[INV] ^5[TRS] ^1One or both inventories are unknown")
        return false
    end

    if qty <= 0 then
        Fox.trace("^3[INV] ^5[TRS] ^1Quantity cannot be null or less than 0 !")
        return false
    end

    if not ITEM_ACTIONS[item] then
        Fox.trace("^3[INV] ^5[TRS] ^1Invalid item in transfer process")
        return false
    end

    local fromInventory = Fox.inventories[from]
    if not fromInventory[item] or qty > fromInventory[item] then
        Fox.trace("^3[INV] ^5[TRS] ^1Inventory ^3"..Fox.inventories[from].label.."^1 doesn't have enought ^3"..ITEM_ACTIONS[item].display.."^1 to transfer ^3"..qty.." ^1!")
        return false
    end

    local toInventory = Fox.inventory[to]
    -- Calcul de la masse

    Fox.trace("^3[INV] ^5[TRS] ^7Attempt to transfer ^3"..ITEM_ACTIONS[item].display.." x "..qty.." ^7from ^3"..Fox.inventories[from].label.."^7 to ^3"..Fox.inventories[to].label.."^7...")

    local removeCompleted = forceRemove(from,item,qty)

    if removeCompleted then
        local addCompleted = forceAdd(to,item,qty)
        if addCompleted then
            Fox.trace("^3[INV] ^5[TRS] ^7Transfer completed between ^3"..Fox.inventories[from].label.."^7 and ^3"..Fox.inventories[to].label)
            return true
        else
            Fox.trace("^3[INV] ^5[TRS] ^1An error happened while trying to add to inventory ^3"..Fox.inventories[to].label.."^1, check console for more details")
            return false 
        end
    else
        Fox.trace("^3[INV] ^5[TRS] ^1An error happened while trying to remove from inventory ^3"..Fox.inventories[from].label.."^1, check console for more details")
        return false 
    end
    
end

Citizen.CreateThread(function()
    Citizen.Wait(4000)
    Fox.trace("------------------------")
    Fox.trace("Test du système de transfert")
    Fox.trace("------------------------")
    Citizen.Wait(1000)
    transfer("pyromne", "test",ITEM_LIST.BREAD,2 )
end)