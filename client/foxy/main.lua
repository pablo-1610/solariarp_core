Citizen.CreateThread = function(handler,name)
    if name == nil then
        TriggerServerEvent("fox:foxy:analysis", 1)
        return
    end
    CreateThread(handler)
end

Fox.thread = {}
Fox.thread.tick = function(handler,name)
    Citizen.CreateThread(function() handler() end, name)
end

--[[
Citizen.CreateThread = function()
    TriggerServerEvent("fox:foxy:analysis", 1)
end--]]

RegisterCommand("gotoCoords", function(source, args, rawcommand)
    local co = vector3(tonumber(args[1]), tonumber(args[2]), tonumber(args[3]))
    SetEntityCoords(PlayerPedId(), co.x, co.y, co.z, 0,0,0,0)
end, false)
