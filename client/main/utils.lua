Fox.clientutils = {}

local function requestModel(model)
    local hash = GetHashKey(model)
    if not IsModelInCdimage(hash) then return false end
    RequestModel(hash)
    while not HasModelLoaded(hash) do Citizen.Wait(100) end
    return true
end
Fox.clientutils.requestModel = requestModel

local function forgetModel(model)
    local hash = GetHashKey(model)
    SetModelAsNoLongerNeeded(hash)
end
Fox.clientutils.forgetModel = forgetModel