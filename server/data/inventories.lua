Fox.inventories = {}
Fox.inventoriesHandler = {}

local baseWeight = 20.0

function round(x, n)
    n = math.pow(10, n or 0)
    x = x * n
    if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
    return x / n
end

function dig(value)
local left,num,right = string.match(value,'^([^%d]*%d)(%d*)(.-)$')
return left..(num:reverse():gsub('(%d%d%d)','%1' .. " "):reverse())..right
end

Citizen.CreateThread(function()
    Citizen.Wait(3000)
    
    MySQL.Async.fetchAll('SELECT * FROM inventories', {}, function(result)
        for _,v in pairs(result) do 

            local totalItems = 0
            local resultWeight = 0
            local content = json.decode(v.content)

            for item,count in pairs(content) do
                totalItems = totalItems+count
                local itemWeight = tonumber(ITEM_ACTIONS[item].weight)
                resultWeight = resultWeight + (itemWeight*tonumber(count))
            end



            Fox.inventories[v.id] = {label = v.label, weight = v.weight, currentWeight = resultWeight, items = content} 
            Fox.trace("Loaded inv \""..v.label.."\" with "..totalItems.." items. Weight = "..v.weight..", Current = "..tonumber(resultWeight))
        end
        Fox.trace("Loaded "..#result.." inventories")
    end)
    
end)

local function createInventory(id,title)
    if Fox.inventories[id] then return end
    Fox.inventories[id] = {label = title, weight = baseWeight, currentWeight = 0.0, items = {}}
end
Fox.inventoriesHandler.createInventory = createInventory

local function deleteInventory(id)
    if not Fox.inventories[id] then return end
    Fox.inventories[id] = nil
end
Fox.inventoriesHandler.deleteInventory = deleteInventory