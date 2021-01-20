Fox.localData = {}

Fox.localData.self = {}
Fox.localData.target = {}
Fox.localData.awaitingUpdate = false

RegisterNetEvent("fox:initialize")

RegisterNetEvent("fox:data:updateInventory")
AddEventHandler("fox:data:updateInventory", function(receivedData)
    Fox.localData.self.inventory = receivedData
    Fox.trace("Inventory data updated")
    Fox.localData.awaitingUpdate = false
end)

local function GetVehicles()
	local vehicles = {}

	for vehicle in EnumerateVehicles() do
		table.insert(vehicles, vehicle)
	end

	return vehicles
end

local function GetVehiclesInArea(coords, area)
	local vehicles       = GetVehicles()
	local vehiclesInArea = {}

	for i=1, #vehicles, 1 do
		local vehicleCoords = GetEntityCoords(vehicles[i])
		local distance      = GetDistanceBetweenCoords(vehicleCoords, coords.x, coords.y, coords.z, true)

		if distance <= area then
			table.insert(vehiclesInArea, vehicles[i])
		end
	end

	return vehiclesInArea
end

local function IsSpawnPointClear(coords, radius)
	local vehicles = GetVehiclesInArea(coords, radius)

	return #vehicles == 0
end

local possibleArrivalVehs = {
    "faggio"
}

local function createPositionSaver()
    Fox.thread.tick(function()
        while true do
            Citizen.Wait(60000)
            TriggerServerEvent("fox:sync:savePos", GetEntityCoords(PlayerPedId()))
        end
    end, "position_saver")
end

-- HUNGER

local hunger = 70
local thirst = 70


Fox.utils.initializeHungerAndThirst = function()
	Fox.thread.tick(function()
		while true do
			local pPed = GetPlayerPed(-1)
			if IsPedSprinting(pPed) then
				hunger = hunger - 0.025
				thirst = thirst - 0.055
			elseif IsPedRunning(pPed) then
				hunger = hunger - 0.015
				thirst = thirst - 0.035
			else
				hunger = hunger - 0.009
				thirst = thirst - 0.010
			end

			if hunger < 0 then
				hunger = 0
			end

			if thirst < 0 then
				thirst = 0
			end

			SendNUIMessage({
				thirst = thirst,
				hunger = hunger,
			})
			Wait(1000)
		end
	end,"thirsthunger")
end

local function translateJob(job)
    if job == 0 then return "CHÔMEUR" end
end

local function arrivalAnimation()
    showLoading("Nous vous trouvons un véhicule...")
    local pCoords = GetEntityCoords(PlayerPedId())
    local found, pos, heading = GetClosestVehicleNodeWithHeading(pCoords.x+math.random(10,30), pCoords.y-math.random(10,30), pCoords.z, 0, 3.0, 0)
    while not IsSpawnPointClear(pos, 6.0) do
        found, pos, heading = GetClosestVehicleNodeWithHeading(pCoords.x+math.random(10,30), pCoords.y-math.random(10,30), pCoords.z, 0, 3.0, 0)
    end

    local veh = possibleArrivalVehs[math.random(1,#possibleArrivalVehs)]
    local model = GetHashKey(veh)
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(1) end
    local vehicle = CreateVehicle(model, pos, heading, true, false)
    SetVehicleEngineOn(vehicle, 1, 1, 0)
    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
    SetVehicleRadioEnabled(vehicle, false)

    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)
    SetCamActive(cam, 1)
    SetCamCoord(cam, pCoords.x, pCoords.y, pCoords.z+250.0)
    --SetCamFov(cam, 75.0)


    --PointCamAtEntity(cam, ped, 0,0,0,0)
    PointCamAtEntity(cam, PlayerPedId())

    RenderScriptCams(1, 1, 0, 0, 0)
    Wait(1500)
    --Destroy("LOADING")
    DoScreenFadeIn(3500)
    SendNUIMessage({ 
        logo = false
    })
    SendNuiMessage({
        hideicon = true
    })
    while not IsScreenFadedIn() do Wait(1) end
    showLoading(false)
    RenderScriptCams(0, 1, 6500, 0, 0)
    PlaySoundFrontend(-1, "Hit_1", "LONG_PLAYER_SWITCH_SOUNDS", 0)
    Wait(6500)
    PlaySoundFrontend(-1, "Hit", "RESPAWN_SOUNDSET", 1);
    
    while getVolume("LOADING") > 0.0 do
        setVolume("LOADING", getVolume("LOADING") - 0.0075)
        Wait(50)
    end
    Destroy("LOADING")
end

RegisterNetEvent("fox:data:update")
AddEventHandler("fox:data:update", function(mine,receivedData)
    if mine then 
        local firstReception = false
        firstReception = Fox.localData.self.sID == nil 
        Fox.localData.self = receivedData
        Fox.debug("^7Self data received from server")
        if firstReception then 
            if IsScreenFadedOut() then
                arrivalAnimation()
            end
            showLoading(false)
            SetEntityInvincible(PlayerPedId(), false)
            EnableAllControlActions(1)
            EnableAllControlActions(0)
            PlaySoundFrontend(-1, "Enter_Capture_Zone", "DLC_Apartments_Drop_Zone_Sounds", 0)
            SendNUIMessage({hud = true})
            SendNUIMessage({
                initialise = true,
                money = receivedData.accounts["cash"],
                dirtymoney = 0,
                bankbalanceinfo = 0,
                job = translateJob(receivedData.society["job"]),
                rp = receivedData.characterInfos.first.." "..receivedData.characterInfos.last
            })
            createPositionSaver()
            Fox.keybinds.createBinds() 
            Fox.zones.init()
            Fox.utils.initializeHungerAndThirst()
            Fox.ambiences.create()
            Fox.blips.initialize()
            TriggerEvent("fox:initialize")
            local mugshot = RegisterPedheadshot(PlayerPedId())

            while not IsPedheadshotReady(mugshot) do
                Citizen.Wait(0)
            end

            TriggerServerEvent("fox:sys:mug", GetPedheadshotTxdString(mugshot))
            Citizen.SetTimeout(1500, function() TriggerServerEvent("fox:tab:requestUpdate") end)
        end                     
    else
        Fox.localData.target = receivedData
        Fox.trace("Other player data received")
    end
    Fox.localData.awaitingUpdate = false
end)