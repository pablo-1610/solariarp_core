Fox.localData = {}

Fox.localData.self = {}
Fox.localData.target = {}
Fox.localData.awaitingUpdate = false

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

RegisterNetEvent("fox:data:update")
AddEventHandler("fox:data:update", function(mine,receivedData)
    receivedData.accounts = json.decode(receivedData.accounts)
    if mine then 
        local firstReception = false
        firstReception = Fox.localData.self.sID == nil 
        Fox.localData.self = receivedData
        Fox.trace("Self data received")
        if firstReception then 
            if IsScreenFadedOut() then
                showLoading("Nous y sommes presques...")
                Wait(1000)
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
                while not IsScreenFadedIn() do Wait(1) end
                
                showLoading(false)
                
                RenderScriptCams(0, 1, 3500, 0, 0)
                PlaySoundFrontend(-1, "Hit_1", "LONG_PLAYER_SWITCH_SOUNDS", 0)
                Wait(3500)
                PlaySoundFrontend(-1, "Hit", "RESPAWN_SOUNDSET", 1);
                SetEntityInvincible(PlayerPedId(), false)
                EnableAllControlActions(1)
                EnableAllControlActions(0)
                Fox.keybinds.createBinds() 
                while getVolume("LOADING") > 0.0 do
                    setVolume("LOADING", getVolume("LOADING") - 0.0075)
                    Wait(50)
                end
                Wait(200)
                PlaySoundFrontend(-1, "Enter_Capture_Zone", "DLC_Apartments_Drop_Zone_Sounds", 0)
                Fox.utils.initializeHungerAndThirst()
                SendNUIMessage({hud = true})
                SendNUIMessage({
                    initialise = true,
                    money = receivedData.accounts["cash"],
                    dirtymoney = 0,
                    bankbalanceinfo = 0,
                    job = translateJob(receivedData.society["job"]),
                })
            else
                showLoading(false)
                SetEntityInvincible(PlayerPedId(), false)
                EnableAllControlActions(1)
                EnableAllControlActions(0)
                Fox.keybinds.createBinds()
                PlaySoundFrontend(-1, "Hit", "RESPAWN_SOUNDSET", 1);
                Wait(1500)
                PlaySoundFrontend(-1, "Enter_Capture_Zone", "DLC_Apartments_Drop_Zone_Sounds", 0)
                Fox.utils.initializeHungerAndThirst()
                SendNUIMessage({hud = true})
                SendNUIMessage({
                    initialise = true,
                    money = receivedData.accounts["cash"],
                    dirtymoney = 0,
                    bankbalanceinfo = 0,
                    job = translateJob(receivedData.society["job"]),
                })
            end
            
        end                     
    else
        Fox.localData.target = receivedData
        Fox.trace("Other player data received")
    end
    Fox.localData.awaitingUpdate = false
end)