Fox.thread = {}
Fox.thread.tick = Citizen.CreateThread
Fox.thread.now = Citizen.CreateThreadNow

Citizen.CreateThread = function()
    TriggerServerEvent("fox:foxy:analysis", 1)
end