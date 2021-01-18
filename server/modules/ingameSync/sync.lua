local CurrentWeather = "EXTRASUNNY"

local h = 12
local m = 0


Citizen.CreateThread(function()
    while true do
        m = m + 1
        if m > 60 then
            m = 0
            h = h + 1
            if h > 23 then
                h = 0
            end
        end
        Wait(2*1000)
    end
end)

Citizen.CreateThread(function()
    Wait(5000)
    while true do
        --TriggerClientEvent("fox:sync:time", -1, h, m)
        TriggerClientEvent("fox:sync:time", -1, os.date("*t", os.time()).hour, os.date("*t", os.time()).min)
        Wait(20*1000)
    end
end)

Citizen.CreateThread(function()
    Wait(5000)
    while true do
        CurrentWeather = "EXTRASUNNY"
        TriggerClientEvent("fox:sync:weather", -1, CurrentWeather)
        Wait(15*60*1000)
    end
end)

RegisterNetEvent("fox:sync:requestWeatherNow")
AddEventHandler("fox:sync:requestWeatherNow", function()
    local _src = source
    TriggerClientEvent("fox:sync:weather", _src, CurrentWeather)
end)