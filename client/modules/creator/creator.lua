local initialPosition = {vec = vector3(683.75, 570.67, 130.46), heading = 162.34}

local lights = {
    {vec = vector3(689.96, 569.25, 130.46), heading = 67.71},
    {vec = vector3(685.23, 575.07, 130.46), heading = 162.97},
    {vec = vector3(678.39, 573.47, 130.46), heading = 252.61}
}

local function requestGround(vector)
    local found,z = GetGroundZFor_3dCoord(vector.x, vector.y, vector.z, 0)    
    return found,vector3(vector.x, vector.y, z)
end

local function initiCreator()
    Fox.sync.forceTime(00,00)
    local ped = PlayerPedId()
    RequestCollisionAtCoord(initialPosition.vec)
    SetEntityCoords(ped, initialPosition.vec, 0,0,0,0)
    SetEntityHeading(ped, initialPosition.heading)
    Citizen.Wait(1500)
    local light = GetHashKey("prop_worklight_03a")
    RequestModel(light)
    while not HasModelLoaded(light) do Citizen.Wait(10) end

    for k,v in pairs(lights) do
        local c = v.vec
        local currentLight = CreateObject(light, c.x, c.y, c.z-1.50, false, false, true)
        SetEntityHeading(currentLight, v.heading)
    end

end

RegisterCommand("fake", function(source, args, rawcommand)
    initiCreator()
end, false)