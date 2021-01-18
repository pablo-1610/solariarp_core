Fox.sync = {}

Fox.sync.forceWeather = function(weather)
    overrideLocalWeather = weather
    if weather == nil then weather = "EXTRASUNNY" end
    ClearOverrideWeather()
    ClearWeatherTypePersist()
    SetWeatherTypePersist(weather)
    SetWeatherTypeNow(weather)
    SetWeatherTypeNowPersist(weather)
end

Fox.sync.forceTime = function(ho,mi)
    overrideLocalTime = {h = ho, m = mi}
    if overrideLocalTime.h == nil then
        NetworkOverrideClockTime(h, m, 0)
    else 
        NetworkOverrideClockTime(overrideLocalTime.h, overrideLocalTime.m, 0)
    end
end

RegisterNetEvent("fox:sync:time")
AddEventHandler("fox:sync:time", function(h, m)
    if overrideLocalTime.h ~= nil then
        NetworkOverrideClockTime(overrideLocalTime.h, overrideLocalTime.m, 0)
    else
        NetworkOverrideClockTime(h, m, 0)
    end
    SendNUIMessage({
        time = h..":"..m
    })
end)

RegisterNetEvent("fox:sync:pos")
AddEventHandler("fox:sync:pos", function()
    local co = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("fox:sync:savePos", co)
end)

RegisterNetEvent("fox:sync:weather")
AddEventHandler("fox:sync:weather", function(weather)
    if overrideLocalWeather ~= nil then 
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(overrideLocalWeather)
        SetWeatherTypeNow(overrideLocalWeather)
        SetWeatherTypeNowPersist(overrideLocalWeather)
    else 
        ClearOverrideWeather()
        ClearWeatherTypePersist()
        SetWeatherTypePersist(weather)
        SetWeatherTypeNow(weather)
        SetWeatherTypeNowPersist(weather)
    end
end)