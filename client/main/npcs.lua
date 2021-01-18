local noNPCZones = {
    {base = vector3(974.14, -3173.79, 5.90), radius = 300.0}
}

local scenarios = {
    'WORLD_VEHICLE_ATTRACTOR',
    'WORLD_VEHICLE_AMBULANCE',
    'WORLD_VEHICLE_BICYCLE_BMX',
    'WORLD_VEHICLE_BICYCLE_BMX_BALLAS',
    'WORLD_VEHICLE_BICYCLE_BMX_FAMILY',
    'WORLD_VEHICLE_BICYCLE_BMX_HARMONY',
    'WORLD_VEHICLE_BICYCLE_BMX_VAGOS',
    'WORLD_VEHICLE_BICYCLE_MOUNTAIN',
    'WORLD_VEHICLE_BICYCLE_ROAD',
    'WORLD_VEHICLE_BIKE_OFF_ROAD_RACE',
    'WORLD_VEHICLE_BIKER',
    'WORLD_VEHICLE_BOAT_IDLE',
    'WORLD_VEHICLE_BOAT_IDLE_ALAMO',
    'WORLD_VEHICLE_BOAT_IDLE_MARQUIS',
    'WORLD_VEHICLE_BOAT_IDLE_MARQUIS',
    'WORLD_VEHICLE_BROKEN_DOWN',
    'WORLD_VEHICLE_BUSINESSMEN',
    'WORLD_VEHICLE_HELI_LIFEGUARD',
    'WORLD_VEHICLE_CLUCKIN_BELL_TRAILER',
    'WORLD_VEHICLE_CONSTRUCTION_SOLO',
    'WORLD_VEHICLE_CONSTRUCTION_PASSENGERS',
    'WORLD_VEHICLE_DRIVE_PASSENGERS',
    'WORLD_VEHICLE_DRIVE_PASSENGERS_LIMITED',
    'WORLD_VEHICLE_DRIVE_SOLO',
    'WORLD_VEHICLE_FIRE_TRUCK',
    'WORLD_VEHICLE_EMPTY',
    'WORLD_VEHICLE_MARIACHI',
    'WORLD_VEHICLE_MECHANIC',
    'WORLD_VEHICLE_MILITARY_PLANES_BIG',
    'WORLD_VEHICLE_MILITARY_PLANES_SMALL',
    'WORLD_VEHICLE_PARK_PARALLEL',
    'WORLD_VEHICLE_PARK_PERPENDICULAR_NOSE_IN',
    'WORLD_VEHICLE_PASSENGER_EXIT',
    'WORLD_VEHICLE_POLICE_BIKE',
    'WORLD_VEHICLE_POLICE_CAR',
    'WORLD_VEHICLE_POLICE',
    'WORLD_VEHICLE_POLICE_NEXT_TO_CAR',
    'WORLD_VEHICLE_QUARRY',
    'WORLD_VEHICLE_SALTON',
    'WORLD_VEHICLE_SALTON_DIRT_BIKE',
    'WORLD_VEHICLE_SECURITY_CAR',
    'WORLD_VEHICLE_STREETRACE',
    'WORLD_VEHICLE_TOURBUS',
    'WORLD_VEHICLE_TOURIST',
    'WORLD_VEHICLE_TANDL',
    'WORLD_VEHICLE_TRACTOR',
    'WORLD_VEHICLE_TRACTOR_BEACH',
    'WORLD_VEHICLE_TRUCK_LOGS',
    'WORLD_VEHICLE_TRUCKS_TRAILERS',
    'WORLD_VEHICLE_DISTANT_EMPTY_GROUND'
  }
  
for i, v in ipairs(scenarios) do
    SetScenarioTypeEnabled(v, false)
end

function SetWeaponDrops()
	local handle, ped = FindFirstPed()
	local finished = false

	repeat
		if not IsEntityDead(ped) then
			SetPedDropsWeaponsWhenDead(ped, false)
		end
		finished, ped = FindNextPed(handle)
	until not finished

	EndFindPed(handle)
end

Fox.thread.tick(function()
	while true do
		Citizen.Wait(1000)
		SetWeaponDrops()
	end
end,"antidrop")

Fox.thread.tick(function()
    local multiplier = 0.25
    for i = 1,15 do
        EnableDispatchService(i, false)
    end
    while true do
        Wait(1)
        SetPedDropsWeaponsWhenDead(PlayerPedId(), false)
        DisplayCash(false)
        SetPedMinGroundTimeForStungun(PlayerPedId(), 10000)
        DisablePlayerVehicleRewards(PlayerId())
        HideHudComponentThisFrame(3)
        for k,currentZone in pairs(noNPCZones) do
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), currentZone.base, true) <= currentZone.radius then
                SetVehicleDensityMultiplierThisFrame(0.0)
                SetPedDensityMultiplierThisFrame(0.0)
                SetRandomVehicleDensityMultiplierThisFrame(0.0)
                SetParkedVehicleDensityMultiplierThisFrame(0.0)
                SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
            else
                SetVehicleDensityMultiplierThisFrame(multiplier)
                SetPedDensityMultiplierThisFrame(multiplier)
                SetRandomVehicleDensityMultiplierThisFrame(multiplier)
                SetParkedVehicleDensityMultiplierThisFrame(multiplier)
                SetScenarioPedDensityMultiplierThisFrame(multiplier, multiplier)
            end
        end
        HudWeaponWheelIgnoreSelection()
    end
end, "npcs")

Fox.thread.tick(function()
    local iledefdp = vector3(4840.571, -5174.425, 2.0)
    while true do
        local pCoords = GetEntityCoords(GetPlayerPed(-1))        
            local ladistanceenculer = #(pCoords - iledefdp)
            if ladistanceenculer < 2000.0 then
            Citizen.InvokeNative("0x5E1460624D194A38", true) -- LA MINIMAP
            Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", true)  -- DESACTIVE LOS SANTOS & LOAD LA MAP
            else
            Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", false)
            Citizen.InvokeNative("0x5E1460624D194A38", false)
            end
        Citizen.Wait(5000)
    end
end, "perico")

Fox.thread.tick(function()
    while true do
		ClearPlayerWantedLevel(GetPlayerIndex())
		RestorePlayerStamina(PlayerId(), 1.0)
		for v in EnumeratePeds() do
			if not IsPedAPlayer(v) then
				SetPedAccuracy(v, 0.0)
				SetPedCombatAbility(v, 0)
				SetPedCombatAttributes(v, 1424, false)
				SetPedCombatAttributes(v, 5, false)
				SetPedCombatRange(v, 0)
			end
		end
		Wait(5000)
	end
end, "npcs")