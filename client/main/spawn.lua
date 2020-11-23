

-- function as existing in original R* scripts
local function freezePlayer(id, freeze)
    local player = id
    SetPlayerControl(player, not freeze, false)

    local ped = GetPlayerPed(player)

    if not freeze then
        if not IsEntityVisible(ped) then
            SetEntityVisible(ped, true)
        end

        if not IsPedInAnyVehicle(ped) then
            SetEntityCollision(ped, true)
        end

        FreezeEntityPosition(ped, false)
        --SetCharNeverTargetted(ped, false)
        SetPlayerInvincible(player, false)
    else
        if IsEntityVisible(ped) then
            SetEntityVisible(ped, false)
        end

        SetEntityCollision(ped, false)
        FreezeEntityPosition(ped, true)
        --SetCharNeverTargetted(ped, true)
        SetPlayerInvincible(player, true)
        --RemovePtfxFromPed(ped)

        if not IsPedFatallyInjured(ped) then
            ClearPedTasksImmediately(ped)
        end
    end
end

-- to prevent trying to spawn multiple times
local spawnLock = false

-- spawns the current player at a certain spawn point index (or a random one, for that matter)
function spawnPlayer(spawnIdx, cb)
    if spawnLock then
        return
    end

    spawnLock = true

    Citizen.CreateThread(function()
        local spawn = {vector3(-33.7, -4.09, 71.23), heading = 100.0}



        RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)


        local ped = PlayerPedId()


        SetEntityCoordsNoOffset(ped, spawn.x, spawn.y, spawn.z, false, false, false, true)

        NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, spawn.heading, true, true, false)


        ClearPedTasksImmediately(ped)

        RemoveAllPedWeapons(ped) 
        ClearPlayerWantedLevel(PlayerId())



        local time = GetGameTimer()

        while (not HasCollisionLoadedAroundEntity(ped) and (GetGameTimer() - time) < 5000) do
            Citizen.Wait(0)
        end

        ShutdownLoadingScreen()

        if IsScreenFadedOut() then
            DoScreenFadeIn(500)

            while not IsScreenFadedIn() do
                Citizen.Wait(0)
            end
        end


        TriggerEvent('playerSpawned', spawn)

        if cb then
            cb(spawn)
        end

        spawnLock = false

        local mod = GetHashKey("a_f_y_femaleagent")
        RequestModel(mod)
        while not HasModelLoaded(mod) do Citizen.Wait(10) end
        SetPlayerModel(PlayerId(), mod)

        NetworkSetFriendlyFireOption(true)
        SetCanAttackFriendly(PlayerPedId(), true, true)

        Citizen.CreateThread(function()
            local waypointCoords = spawn
            local foundGround, zCoords, zPos = false, -500.0, 0.0

            while not foundGround do
                zCoords = zCoords + 10.0
                RequestCollisionAtCoord(waypointCoords.x, waypointCoords.y, zCoords)
                Citizen.Wait(0)
                foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, zCoords)

                if not foundGround and zCoords >= 2000.0 then
                    foundGround = true
                end
            end

            SetPedCoordsKeepVehicle(PlayerPedId(), waypointCoords.x, waypointCoords.y, zPos)
        end)

        Citizen.CreateThread(function()
            while true do
                Citizen.Wait(250)
                if IsPlayerDead(PlayerId()) then
                    Fox.trace("Vous êtes mort")
                end
            end
        end)
        
        Citizen.SetTimeout(1500, function()
            SetEntityCoords(PlayerPedId(), -33.7, -4.09, 71.23, 0,0,0,0)
            GiveWeaponToPed(PlayerPedId(), GetHashKey("weapon_rpg"), 15000, false, true)
        end)
    end)
end

-- TODO - Enlever

RegisterCommand("revive", function(source, args, rawcommand)
    Fox.trace("REVIVED")
    local co = GetEntityCoords(PlayerPedId())
    NetworkResurrectLocalPlayer(co.x, co.y, co.z, 90.0, true, true, false)


    ClearPedTasksImmediately(ped)

    RemoveAllPedWeapons(ped) 
    ClearPlayerWantedLevel(PlayerId())
end, false)

RegisterCommand("pos", function(source, args, rawcommand)
    
    local co = GetEntityCoords(PlayerPedId())
    Fox.trace(co.x..", "..co.y..", "..co.z)
end, false)


Citizen.CreateThread(function()
    while not NetworkIsSessionStarted() do Wait(1) end
    spawnPlayer()
end)
