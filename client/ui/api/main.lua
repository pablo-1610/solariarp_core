local NearZone = false

Fox.thread.tick(function()
    Citizen.Wait(1000)
    while true do
        if not NearZone then
            Wait(2500)
        else
            Wait(50)
        end
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)
        SendNUIMessage({
            status = "position",
            x = pos.x,
            y = pos.y,
            z = pos.z
        })
    end
end, "positionPlayer") 


MusicZone = {
    {
        name = "bar_ambience",
        link = "https://www.youtube.com/watch?v=ZcThrAU9yLk",
        dst = 15.0,
        starting = 35.0,
        pos = vector3(281.4, -973.0, 29.87),
        max = 0.05,
    },
    {
        name = "police_radio",
        link = "https://www.youtube.com/watch?v=eqnq5XF3CJ0",
        dst = 15.0,
        starting = 35.0,
        pos = vector3(440.81, -977.01, 30.68),
        max = 0.1,
    },
    {
        name = "police_radio_vesp",
        link = "https://www.youtube.com/watch?v=eqnq5XF3CJ0",
        dst = 5.0,
        starting = 15.0,
        pos = vector3(-1097.4, -840.0, 19.00),
        max = 0.1,
    },
    {
        name = "hopital_radio",
        link = "https://www.youtube.com/watch?v=lfEFo30J4eA",
        dst = 5.0,
        starting = 15.0,
        pos = vector3(357.0, -1416.9, 32.5),
        max = 0.1,
    },
    {
        name = "mafia_ambience",
        link = "https://www.youtube.com/watch?v=1aV9X2d-f5g",
        dst = 30.0,
        starting = 60.0,
        pos = vector3(-90.5, 994.2, 234.56),
        max = 0.05,
    },
    {
        name = "hopital_restaurant_ambience",
        link = "https://www.youtube.com/watch?v=h2zkV-l_TbY",
        dst = 15.0,
        starting = 35.0,
        pos = vector3(316.87, -1401.395, 32.5),
        max = 0.1,
    },
    {
        name = "vigneron_ambience",
        link = "https://www.youtube.com/watch?v=X-jdl9hcCeg",
        dst = 20.0,
        starting = 60.0,
        pos = vector3(-1881.66, 2067.446, 140.98),
        max = 0.2,
    },
    {
        name = "bean_ambience",
        link = "https://www.youtube.com/watch?v=MQpvtwgLMPo",
        dst = 23.0,
        starting = 60.0,
        pos = vector3(-631.9, 232.8, 81.88),
        max = 0.09,
    },
    {
        name = "accessoire_ambience",
        link = "https://www.youtube.com/watch?v=e_FddI2HI7A", -- https://www.youtube.com/watch?v=rBLuvEwIF5E
        dst = 9.0,
        starting = 60.0,
        pos = vector3(-1123.8, -1440.4, 6.2),
        max = 0.1,
    },
    {
        name = "office_ambience",
        link = "https://www.youtube.com/watch?v=CeLAeItGXaQ", 
        dst = 15.0,
        starting = 20.0,
        pos = vector3(-1043.65, -1382.8, 5.5),
        max = 0.2,
    },
    {
        name = "mecano_ambient",
        link = "https://www.youtube.com/watch?v=UxB0Um6F4gs", 
        dst = 35.0,
        starting = 60.0,
        pos = vector3(-88.1, -1800.9, 29.81),
        max = 0.02,
    },
    {
        name = "resto_chill",
        link = "https://www.youtube.com/watch?v=Si_f4Km3snQ", 
        dst = 10.0,
        starting = 40.0,
        pos = vector3(-95.99364, -1813.036, 29.55412),
        max = 0.03,
    },
    {
        name = "chiness_ambient",
        link = "https://www.youtube.com/watch?v=JuwJfDr36Kc", 
        dst = 25.0,
        starting = 60.0,
        pos = vector3(308.9, 222.8, 104.3),
        max = 0.09,
    },
    {
        name = "comedyclub_ambient",
        link = "https://www.youtube.com/watch?v=cUZbRc0lwjA", 
        dst = 25.0,
        starting = 100.0,
        pos = vector3(-448.02, 271.02, 83.02),
        max = 0.09,
    },
    {
        name = "shop_ambient",
        link = "https://www.youtube.com/watch?v=WoxnL5dakyA&t=6s", 
        dst = 10.0,
        starting = 30.0,
        pos = vector3(25.74, -1345.8, 29.49),
        max = 0.09,
    },
    {
        name = "radio_ambient",
        link = "https://www.youtube.com/watch?v=RfDf9DSZfD0", 
        dst = 15.0,
        starting = 100.0,
        pos = vector3(730.4, 2519.5, 73.5),
        max = 0.04,
    },
    {
        name = "weed_ambient",
        link = "https://www.youtube.com/watch?v=5qdTU3i6-XI", 
        dst = 15.0,
        starting = 50.0,
        pos = vector3(374.3, -826.14, 29.30),
        max = 0.04,
    },
    {
        name = "gouv_combine",
        link = "https://www.youtube.com/watch?v=Wu7PwGOOdtM", 
        dst = 10.0,
        starting = 50.0,
        pos = vector3(416.705, 4811.09, -58.99792),
        max = 0.10,
    },
}

--[[
Citizen.CreateThread(function()
    Wait(2000)
    while true do
        NearZone = false
        local pPed = GetPlayerPed(-1)
        local pCoords = GetEntityCoords(pPed)
        for k,v in pairs(MusicZone) do
            local dst = GetDistanceBetweenCoords(pCoords, v.pos, true)
            if not NearZone then
                if dst < v.starting then
                    NearZone = true
                    if soundExists(v.name) then
                        Resume(v.name)
                    else
                        PlayUrlPos(v.name, v.link, v.max, v.pos, true)
                        setVolumeMax(v.name, v.max)
                        Distance(v.name, v.dst)
                        print("Ambience "..v.name.." created and ^2started")
                    end
                else
                    if soundExists(v.name) then
                        if not isPaused(v.name) then
                            Pause(v.name)
                        end
                    end
                end
            end
        end

        if not NearZone then
            Wait(350)
        else
            Wait(50)
        end
    end
end)
--]]