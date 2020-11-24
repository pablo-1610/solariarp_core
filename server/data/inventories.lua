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

        local function getFailed()
            if failed > 0 then
                return " ^1(+"..failed..")^7"
            else
                return ""
            end
        end
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
                Fox.trace("^3[INV] ^1Failed to load inv ^3\""..v.label.."^7\" ^1cause has weight (^3"..round(resultWeight).."^1) > maxWeight (^3"..round(v.weight).."^1) !^7")
                failed = failed + 1
            else 
                Fox.inventories[v.id] = {label = v.label, weight = v.weight, currentWeight = resultWeight, items = content} 
                Fox.trace("^3[INV] ^7Loaded inv ^3\""..v.label.."^7\" with ^3"..totalItems.."^7 items. Weight = ^3"..round(v.weight).."^7, Current = ^3"..round(resultWeight).."^7")
                loaded = loaded + 1
            end
        end
        Fox.trace("^3[INV] ^7Loaded ^2"..loaded..getFailed().." ^7inventories")
    end)
    
end)

local function createInventory(id,title,currentWeight)
    if Fox.inventories[id] then return end
    if currentWeight == nil then currentWeight = baseWeight end 
    Fox.inventories[id] = {label = title, weight = baseWeight, currentWeight = 0, items = {}}
end
Fox.inventoriesHandler.createInventory = createInventory


local function deleteInventory(id)
    if not Fox.inventories[id] then return end
    Fox.inventories[id] = nil
end
Fox.inventoriesHandler.deleteInventory = deleteInventory