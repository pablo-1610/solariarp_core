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

RegisterCommand("test", function(source, args, rawcommand)
    print("Ok")
    Fox.thread.tick(function()
        print("SALU")
    end)
end, false)