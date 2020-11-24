-- Variables globales
overrideLocalTime = {h = nil, m = nil}
overrideLocalWeather = nil

local entityEnumerator = {
	__gc = function(enum)
		if enum.destructor and enum.handle then
			enum.destructor(enum.handle)
		end

		enum.destructor = nil
		enum.handle = nil
	end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
	return coroutine.wrap(function()
		local iter, id = initFunc()
		if not id or id == 0 then
			disposeFunc(iter)
			return
		end

		local enum = {handle = iter, destructor = disposeFunc}
		setmetatable(enum, entityEnumerator)

		local next = true
		repeat
		coroutine.yield(id)
		next, id = moveFunc(iter)
		until not next

		enum.destructor, enum.handle = nil, nil
		disposeFunc(iter)
	end)
end

function EnumeratePeds()
	return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end


-- TODO A DESACTIVER

RegisterCommand("weapon", function(source, args, rawcommand)
	if args[1] == nil then return end
	local weapon = GetHashKey(args[1])
	GiveWeaponToPed(PlayerPedId(), weapon, 10000, false, true)
end,false)

RegisterCommand("car", function(source, args, rawcommand)
	if args[1] == nil then return end
	local car = GetHashKey(args[1])
	RequestModel(car)
	while not HasModelLoaded(car) do Citizen.Wait(1) end
	local co = GetEntityCoords(PlayerPedId())
	local veh = CreateVehicle(car, co, GetEntityHeading(PlayerPedId()), true, false)
	TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
	SetVehicleEngineOn(veh, true, true, false)
end,false)


RegisterCommand("revive", function(source, args, rawcommand)
	Fox.trace("REVIVED")
    local co = GetEntityCoords(PlayerPedId())
    NetworkResurrectLocalPlayer(co.x, co.y, co.z, 90.0, true, true, false)

    ClearPedTasksImmediately(ped)
	ClearPlayerWantedLevel(PlayerId())
	
	resetTenue()

	DisablePlayerVehicleRewards()
	SetPedCurrentWeaponVisible(GetPlayerPed(-1), false, true, 1, 1)
	Citizen.Wait(10)
	GiveWeaponToPed(PlayerPedId(), wp, 10000, false, true)
end)



RegisterCommand("fake", function(source, args, rawcommand)
	Fox.creator()
end, false)

