local initialPosition = {vec = vector3(683.75, 570.67, 129.40), heading = 162.34}

local lights = {
    {vec = vector3(689.96, 569.25, 130.46), heading = 252.61},
    {vec = vector3(685.23, 575.07, 130.46), heading = 343.05},
    {vec = vector3(678.39, 573.47, 130.46), heading = 67.71},
    {vec = vector3(681.08, 562.99, 129.69+2.30), heading = 163.81}
}

local createdLights = {}

local function requestGround(vector)
    local found,z = GetGroundZFor_3dCoord(vector.x, vector.y, vector.z, 0)    
    return found,vector3(vector.x, vector.y, z)
end

local function initiCreator()
    DoScreenFadeOut(1200)
    while not IsScreenFadedOut() do Citizen.Wait(10) end
    Citizen.Wait(1000)
    
    Fox.sync.forceTime(00,00)
    local ped = PlayerPedId()
    DisplayRadar(false)
    local blockControls = true

    

    RequestCollisionAtCoord(initialPosition.vec)
    SetEntityCoords(ped, initialPosition.vec, 0,0,0,0)
    SetEntityHeading(ped, initialPosition.heading)
    FreezeEntityPosition(ped, true)
    
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_AA_SMOKE", 0, false)

    local modcu = GetHashKey("s_m_m_hairdress_01")
    RequestModel(modcu)
    while not HasModelLoaded(modcu) do Citizen.Wait(10) end
    local hair = CreatePed(9, modcu, 682.91, 571.01, 130.46, 246.72, false, false)
    createdLights[450] = hair
    TaskStartScenarioInPlace(hair, "WORLD_HUMAN_CLIPBOARD", 0, false)

    Fox.thread.tick(function()
        while blockControls do
            DisableControlAction(1, 1, true)
            DisableControlAction(1, 2, true)
            DisableControlAction(1, 4, true)
            DisableControlAction(1, 6, true)
            DisableControlAction(1, 270, true)
            DisableControlAction(1, 271, true)
            DisableControlAction(1, 272, true)
            DisableControlAction(1, 273, true)
            DisableControlAction(1, 282, true)
            DisableControlAction(1, 283, true)
            DisableControlAction(1, 284, true)
            DisableControlAction(1, 285, true)
            DisableControlAction(1, 286, true)
            DisableControlAction(1, 290, true)
            DisableControlAction(1, 291, true)
            Wait(1)
            for v in EnumeratePeds() do
                if v ~= ped and v ~= hair then
                    SetEntityAlpha(v, 0, 0)
                    SetEntityNoCollisionEntity(ped, v, false)
                    NetworkConcealPlayer(NetworkGetPlayerIndexFromPed(v), true, 1)
                end
            end
        end
        for v in EnumeratePeds() do
            if v ~= ped then
                ResetEntityAlpha(v)
                SetEntityNoCollisionEntity(v, ped, true)
                NetworkConcealPlayer(NetworkGetPlayerIndexFromPed(v), false, 1)
            end
        end
    end, "creapero")
    

    local light = GetHashKey("prop_worklight_03a")
    RequestModel(light)
    while not HasModelLoaded(light) do Citizen.Wait(10) end

    for k,v in pairs(lights) do
        local c = v.vec
        local currentLight = CreateObject(light, c.x, c.y, c.z-3.50, false, false, true)
        FreezeEntityPosition(currentLight, true)
        SetEntityHeading(currentLight, v.heading)
        createdLights[k] = currentLight
    end

    local cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 0)
    SetCamActive(cam, 1)
    SetCamCoord(cam, 681.08, 562.99, 129.69+2.30)
    --SetCamFov(cam, 75.0)
    PointCamAtEntity(cam, ped, 0,0,0,0)

    RenderScriptCams(1, 1, 0, 0, 0)
    Citizen.Wait(1000)
    DoScreenFadeIn(1200)
    while not IsScreenFadedIn() do Citizen.Wait(10) end
    local fovDest = GetCamFov(cam)
    PlaySoundFrontend(-1, "FocusIn", "HintCamSounds", false)
    while GetCamFov(cam) > 15.0 do
        fovDest = fovDest - 0.1
        
        SetCamFov(cam, fovDest)
        Citizen.Wait(1)
    end
    PlaySoundFrontend(-1, "FocusOut", "HintCamSounds", false)
    PlaySoundFrontend(-1, "Boss_Message_Orange", "GTAO_Boss_Goons_FM_Soundset", false)
    PlayAmbientSpeech1(hair, "GENERIC_HI", "SPEECH_PARAMS_FORCE_NORMAL_CLEAR")
end

RegisterCommand("fake", function(source, args, rawcommand)
    initiCreator()
end, false)