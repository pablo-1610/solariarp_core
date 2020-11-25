local initialPosition = {vec = vector3(683.75, 570.67, 129.40), heading = 162.34}
local lights = {{vec = vector3(689.96, 569.25, 130.46), heading = 252.61},{vec = vector3(685.23, 575.07, 130.46), heading = 343.05},{vec = vector3(678.39, 573.47, 130.46), heading = 67.71},{vec = vector3(681.08, 562.99, 129.69+2.30), heading = 163.81}}
local createdLights = {}

local PedIndex, DadIndex, MotherIndex, ArmsIndex, CheuveuxIndex, CouleurIndex, OeilIndex, BarbeIndex, TshirtIndex, TshirtIndex2, VesteIndex, VesteIndex2, PantalonIndex, PantalonIndex2, ChaussureIndex, ChaussureIndex2 = 'mp_m_freemode_01', 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
local DadNumber = {"Benjamin", "Daniel", "Joshua", "Noah", "Andrew", "Juan", "Alex", "Isaac", "Evan", "Ethan", "Vincent", "Angel", "Diego", "Adrian", "Gabriel", "Michael", "Santiago", "Kevin", "Louis", "Samuel", "Anthony", "Pierre", "Niko"}
local MotherNumber = {"Adelyn", "Emily", "Abigail", "Beverly", "Kristen", "Hailey", "June", "Daisy", "Elizabeth", "Addison", "Ava", "Cameron", "Samantha", "Madison", "Amber", "Heather", "Hillary", "Courtney", "Ashley", "Alyssa", "Mia", "Brittany"}
local creatorMenus = {}


coloredVariator = "~r~"

Fox.thread.tick(function()
    while true do
        Citizen.Wait(600)
        if coloredVariator == "~r~" then
            coloredVariator = "~o~"
        else
            coloredVariator = "~r~"
        end
    end
end, "creator")

local function isint(n)
    return n==math.floor(n)
end

local function initiCreator()
    PlayUrl("creator", "https://youtu.be/8DSeZji2x-Y", 0.30, true)
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
    SetBlockingOfNonTemporaryEvents(hair, true)
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
                if v ~= PlayerPedId() and v ~= hair then
                    SetEntityAlpha(v, 0, 0)
                    SetEntityNoCollisionEntity(PlayerPedId(), v, false)
                    NetworkConcealPlayer(NetworkGetPlayerIndexFromPed(v), true, 1)
                end
            end
        end
        for v in EnumeratePeds() do
            if v ~= PlayerPedId() then
                ResetEntityAlpha(v)
                SetEntityNoCollisionEntity(v, PlayerPedId(), true)
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

    local baseCam = GetEntityCoords(PlayerPedId())

    --PointCamAtEntity(cam, ped, 0,0,0,0)
    PointCamAtCoord(cam, baseCam)

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


    RMenu.Add('fox_creator', 'fox_creator_main', RageUI.CreateMenu(nil, "~b~Customisation du personnage", nil, nil, "root_cause" , "shopui_title_vangelico"))
    RMenu:Get("fox_creator", "fox_creator_main").Closed = function()end
    RMenu:Get("fox_creator", "fox_creator_main").Closable = false

    RMenu.Add('fox_creator', 'fox_identity', RageUI.CreateSubMenu(RMenu:Get('fox_creator', 'fox_creator_main'), nil, "~b~Customisation du personnage"))
    RMenu:Get('fox_creator', 'fox_identity').Closed = function()end
    RMenu:Get("fox_creator", "fox_identity").Closable = true

    local infos = {first = "", last = "", age = ""}
    local err = nil

    RageUI.Visible(RMenu:Get("fox_creator",'fox_creator_main'), true)

    local vars = {
        [1] = {var = "Sexe", menuDest = "sexe"},
        [2] = {var = "Hérédité", menuDest = "heredite"},
        [3] = {var = "Tête", menuDest = "tete"},
        [4] = {var = "Hauts", menuDest = "haut"},
        [5] = {var = "Bas", menuDest = "bas"}
    }

    for k,v in pairs(vars) do
        RMenu.Add('fox_creator', 'fox_'..v.menuDest, RageUI.CreateSubMenu(RMenu:Get('fox_creator', 'fox_creator_main'), nil, "~b~Customisation du personnage"))
        RMenu:Get('fox_creator', 'fox_'..v.menuDest).Closed = function()end
        RMenu:Get("fox_creator", 'fox_'..v.menuDest).Closable = true
    end

    
    local antispam = false
    local menuShouldBeOpened = true
    local rotation = false

    Fox.thread.tick(function()

        local baseHeading = initialPosition.heading
        local additioneer = 0.0
        while blockControls do
            Citizen.Wait(1)
            if rotation then 
                SetEntityHeading(PlayerPedId(), tonumber(baseHeading+additioneer))
                additioneer = additioneer + 0.5
                --Fox.trace("Add: "..additioneer.." | Current: "..GetEntityHeading(PlayerPedId()))
            end
        end
    end, "custom")

    local toReset = "~r~Appuyez sur ~b~entrer ~r~pour la variation ~y~0 ~r~!"

    Fox.thread.tick(function()
       while menuShouldBeOpened do 
            RageUI.IsVisible(RMenu:Get("fox_creator",'fox_creator_main'),true,true,true,function()

                RageUI.Checkbox("Rotation sur place", nil, rotation, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked)
                    rotation = Checked;
                end, function() end, function() end)
                

                RageUI.Separator("↓ ~b~Identité ~s~↓")
                RageUI.ButtonWithStyle("Créer votre identité",nil, {RightLabel = "~r~Créer ~s~→→"}, true, function(_,_,s) if s then err = nil end end, RMenu:Get('fox_creator', 'fox_identity'))
                RageUI.Separator("↓ ~b~Customisation ~s~↓")
                for k,v in pairs(vars) do RageUI.ButtonWithStyle(v.var,nil, {RightLabel = "~r~Customiser ~s~→→"}, true, function(_,_,s) end, RMenu:Get('fox_creator', 'fox_'..v.menuDest)) end
                RageUI.Separator("↓ ~o~Actions ~s~↓")
                RageUI.ButtonWithStyle("~g~C'est parti !",nil, {RightLabel = "→→"}, infos.age ~= "" and infos.first ~= "" and infos.last ~= "", function(_,_,s)
                    if s then
                        RageUI.CloseAll()
                        local PlySkin = {
				        	PedIndex = PedIndex, 
				        	DadIndex = DadIndex, 
				        	MotherIndex = MotherIndex, 
				        	ArmsIndex = ArmsIndex, 
				        	CheuveuxIndex = CheuveuxIndex, 
				        	CouleurIndex = CouleurIndex, 
				        	OeilIndex = OeilIndex, 
				        	BarbeIndex = BarbeIndex, 
				        	TshirtIndex = TshirtIndex, 
				        	TshirtIndex2 = TshirtIndex2, 
				        	VesteIndex = VesteIndex, 
				        	VesteIndex2 = VesteIndex2, 
				        	PantalonIndex = PantalonIndex, 
				        	PantalonIndex2 = PantalonIndex2, 
				        	ChaussureIndex = ChaussureIndex, 
				        	ChaussureIndex2 = ChaussureIndex2
				        }
                        TriggerServerEvent("fox:creator:create", PlySkin,infos,GetEntityCoords(PlayerPedId()))
                        local spawn = vector3(648.166, 590.63, 128.91)
                        local heading = 75.83
                        DoScreenFadeOut(1000)
                        while not IsScreenFadedOut() do Citizen.Wait(10) end
                        Fox.sync.forceTime(nil,00)
                        RenderScriptCams(0, 1, 0, 0, 0)
                        SetEntityCoords(PlayerPedId(), spawn, 0,0,0,0)
                        local model = GetHashKey("ratbike")
                        RequestModel(model)
                        while not HasModelLoaded(model) do Citizen.Wait(10) end
                        local bike = CreateVehicle(model, spawn,heading, true, false)
                        SetModelAsNoLongerNeeded(model)
                        SetVehicleEngineOn(bike, true, true, false)
                        TaskWarpPedIntoVehicle(PlayerPedId(), bike, -1)
                        blockControls = false
                        while getVolume("creator") > 0.0 do
                            setVolume("creator", getVolume("creator") - 0.01)
                            Wait(100)
                        end
                        Destroy("creator")
                        DoScreenFadeIn(1000)
                        
                        FreezeEntityPosition(PlayerPedId(), false)
                        NetworkSetFriendlyFireOption(true)
                        SetCanAttackFriendly(PlayerPedId(), true, true)
                        DisplayRadar(true)
                        for v in EnumeratePeds() do
                            if v ~= PlayerPedId() then
                                ResetEntityAlpha(v)
                                SetEntityNoCollisionEntity(v, pPed, true)
                                NetworkConcealPlayer(NetworkGetPlayerIndexFromPed(v), false, 1)
                                SetEntityVisible(v, true, 0)
                            end
                        end
                        Citizen.Wait(1200)
                        TriggerServerEvent("fox:data:request")
                    end
                 end)

            end, function()    
            end, 1)

            SetPedHeadBlendData(PlayerPedId(), DadIndex, MotherIndex, nil, DadIndex, MotherIndex, nil, 0.5, 0.5, nil, true)
            
            RageUI.IsVisible(RMenu:Get("fox_creator",'fox_heredite'),true,true,true,function()
                RageUI.HeritageWindow(MotherIndex, DadIndex)
                RageUI.Separator("↓ ~b~Héridité ~s~↓")
                RageUI.List("Mère:", MotherNumber, MotherIndex, nil, {}, true, function(Hovered, Active, Selected, Index)
                    if Active then 
                        MotherIndex = Index
                        --SetPedDefaultComponentVariation(PlayerPedId())
                        --SetPedHeadBlendData(PlayerPedId(), DadIndex, MotherIndex, nil, DadIndex, MotherIndex, nil, 0.5, 0.5, nil, true)
                    end
                    
                end)
                RageUI.List("Père:", DadNumber, DadIndex, nil, {}, true, function(Hovered, Active, Selected, Index)
                    if Active then 
                        DadIndex = Index
                        --SetPedDefaultComponentVariation(PlayerPedId())
                        --SetPedHeadBlendData(PlayerPedId(), DadIndex, MotherIndex, nil, DadIndex, MotherIndex, nil, 0.5, 0.5, nil, true)
                    end
                    
                end)
                RageUI.Separator("↓ ~o~Actions ~s~↓")
                RageUI.ButtonWithStyle("~g~Valider",nil, {RightLabel = "→→"}, true, function(_,_,s) if s then RageUI.GoBack() end end)
            end, function()    
            end, 1)

            RageUI.IsVisible(RMenu:Get("fox_creator",'fox_haut'),true,true,true,function()
                RageUI.Separator("↓ ~b~Customisation ~s~↓")
                
                SetPedComponentVariation(PlayerPedId(), 8, TshirtIndex, TshirtIndex2, 2)
                SetPedComponentVariation(PlayerPedId(), 11, VesteIndex, VesteIndex2, 2)
                SetPedComponentVariation(PlayerPedId(), 3, ArmsIndex, 0, 2)

                local TshirtFound = {}
                local TshirtColorFound = {}
                local VesteFound = {}
                local VesteColorFound = {}
                local ArmsFound = {}

                for i = 0 , GetNumberOfPedDrawableVariations(PlayerPedId(), 8), 1 do TshirtFound[i] = i end
                for i = 0 , GetNumberOfPedTextureVariations(PlayerPedId(), 8, TshirtIndex), 1 do TshirtColorFound[i] = i end
                for i = 0 , GetNumberOfPedDrawableVariations(PlayerPedId(), 11), 1 do VesteFound[i] = i end
                for i = 0 , GetNumberOfPedTextureVariations(PlayerPedId(), 11, VesteIndex), 1 do VesteColorFound[i] = i end

                for i = 0, GetNumberOfPedDrawableVariations(PlayerPedId(), 3)-1, 1 do 
                    ArmsFound[i] = i 
                end

                RageUI.List("T-Shirt:", TshirtFound, TshirtIndex, toReset, {}, true, function(Hovered, Active, Selected, Index)
                    TshirtIndex = Index
                    if Selected then 
                        TshirtIndex = 0
                        --SetPedComponentVariation(PlayerPedId(), 8, TshirtIndex, TshirtIndex2, 2)
                    end
                end)

                RageUI.List("Couleur:", TshirtColorFound, TshirtIndex2, toReset, {}, true, function(Hovered, Active, Selected, Index)
                    TshirtIndex2 = Index
                    if Selected then 
                        TshirtIndex2 = 0
                        --SetPedComponentVariation(PlayerPedId(), 8, TshirtIndex, TshirtIndex2, 2)
                    end
                end)

                RageUI.List("Veste:", VesteFound, VesteIndex, toReset, {}, true, function(Hovered, Active, Selected, Index)
                    VesteIndex = Index
                    if Selected then 
                        VesteIndex = 0
                        
                        --SetPedComponentVariation(PlayerPedId(), 11, VesteIndex, VesteIndex2, 2)
                    end
                end)

                RageUI.List("Couleur:", VesteColorFound, VesteIndex2, toReset, {}, true, function(Hovered, Active, Selected, Index)
                    VesteIndex2 = Index
                    if Selected then 
                        VesteIndex2 = 0
                        --SetPedComponentVariation(PlayerPedId(), 11, VesteIndex, VesteIndex2, 2)
                    end
                end)

                RageUI.List("Bras:", ArmsFound, ArmsIndex, toReset, {}, true, function(Hovered, Active, Selected, Index)
                    ArmsIndex = Index
                    if Selected then 
                        ArmsIndex = 0
                        --SetPedComponentVariation(PlayerPedId(), 3, ArmsIndex, 0, 2)
                    end
                end)


                RageUI.Separator("↓ ~o~Actions ~s~↓")
                RageUI.ButtonWithStyle("~g~Valider",nil, {RightLabel = "→→"}, true, function(_,_,s) if s then RageUI.GoBack() end end)
            end, function()    
            end, 1)

            SetPedComponentVariation(PlayerPedId(), 4, PantalonIndex, PantalonIndex2, 2)
            SetPedComponentVariation(PlayerPedId(), 6, ChaussureIndex, ChaussureIndex2, 2)

            RageUI.IsVisible(RMenu:Get("fox_creator",'fox_bas'),true,true,true,function()
                RageUI.Separator("↓ ~b~Customisation ~s~↓")

                local PantalonFound = {}
                local PantalonColorFound = {}
                local ChaussureFound = {}
                local ChaussureColorFound = {}

                for i = 0 , GetNumberOfPedDrawableVariations(PlayerPedId(), 4), 1 do PantalonFound[i] = i end
                for i = 0 , GetNumberOfPedTextureVariations(PlayerPedId(), 4, PantalonIndex), 1 do PantalonColorFound[i] = i end
                for i = 0 , GetNumberOfPedDrawableVariations(PlayerPedId(), 6), 1 do ChaussureFound[i] = i end
                for i = 0 , GetNumberOfPedTextureVariations(PlayerPedId(), 6, ChaussureIndex), 1 do ChaussureColorFound[i] = i end

                RageUI.List("Pantalon:", PantalonFound, PantalonIndex, toReset, {}, true, function(Hovered, Active, Selected, Index)
                    PantalonIndex = Index
                    if Selected then 
                        PantalonIndex = 0
                        --SetPedComponentVariation(PlayerPedId(), 4, PantalonIndex, PantalonIndex2, 2)
                    end
                end)

                RageUI.List("Couleur:", PantalonColorFound, PantalonIndex2, toReset, {}, true, function(Hovered, Active, Selected, Index)
                    PantalonIndex2 = Index
                    if Selected then 
                        PantalonIndex2 = 0
                        --SetPedComponentVariation(PlayerPedId(), 4, PantalonIndex, PantalonIndex2, 2)
                    end
                end)

                RageUI.List("Chaussures:", ChaussureFound, ChaussureIndex, toReset, {}, true, function(Hovered, Active, Selected, Index)
                    ChaussureIndex = Index
                    if Selected then 
                        ChaussureIndex = 0
                        --SetPedComponentVariation(PlayerPedId(), 6, ChaussureIndex, ChaussureIndex2, 2)
                    end
                end)

                RageUI.List("Couleur:", ChaussureColorFound, ChaussureIndex2, toReset, {}, true, function(Hovered, Active, Selected, Index)
                    ChaussureIndex2 = Index
                    if Selected then 
                        ChaussureIndex2 = 0
                        --SetPedComponentVariation(PlayerPedId(), 6, ChaussureIndex, ChaussureIndex2, 2)
                    end
                end)



                RageUI.Separator("↓ ~o~Actions ~s~↓")
                RageUI.ButtonWithStyle("~g~Valider",nil, {RightLabel = "→→"}, true, function(_,_,s) if s then RageUI.GoBack() end end)
            end, function()    
            end, 1)

            SetPedEyeColor(PlayerPedId(), OeilIndex, 0, 1)
            SetPedComponentVariation(PlayerPedId(), 2, CheuveuxIndex, 1, 2)
            SetPedHeadOverlay(PlayerPedId(), 1, BarbeIndex, 1 + 0.0)
            SetPedHeadOverlayColor(PlayerPedId(), 1, 1, CouleurIndex, CouleurIndex)
            SetPedHairColor(PlayerPedId(), CouleurIndex, CouleurIndex)
		        

            RageUI.IsVisible(RMenu:Get("fox_creator",'fox_tete'),true,true,true,function()
                RageUI.Separator("↓ ~b~Customisation ~s~↓")

                local OeilFound = {}
                local CoiffureFound = {}
                local BarbeFound = {}
                local CouleurFound = {}

                for i = 0 , GetNumHeadOverlayValues(2)-1, 1 do OeilFound[i] = i end
                for i = 0 , GetNumberOfPedDrawableVariations(PlayerPedId(), 2)-1, 1 do CoiffureFound[i] = i end
                for i = 0 , GetNumHeadOverlayValues(1)-1, 1 do BarbeFound[i] = i end
                for i = 0 , GetNumHairColors()-1 do CouleurFound[i] = i end

                RageUI.List("Couleur des yeux:", OeilFound, OeilIndex, toReset, {}, true, function(Hovered, Active, Selected, Index)
                    OeilIndex = Index
                    if Selected then 
                        Index = 0
                        OeilIndex = 0
                    end
                end)

                RageUI.List("Cheveux:", CoiffureFound, CheuveuxIndex, toReset, {}, true, function(Hovered, Active, Selected, Index)
                    CheuveuxIndex = Index
                    if Selected then 
                        Index = 0
                        CheuveuxIndex = 0
                    end
                end)

                RageUI.List("Barbe:", BarbeFound, BarbeIndex, toReset, {}, true, function(Hovered, Active, Selected, Index)
                    BarbeIndex = Index
                    if Selected then 
                        Index = -1
                        BarbeIndex = -1
                    end

                end)

                RageUI.List("Teinte:", CouleurFound, CouleurIndex, toReset, {}, true, function(Hovered, Active, Selected, Index)
                    CouleurIndex = Index
                    if Selected then 
                        Index = 0
                        CouleurIndex = 0
                    end
                end)


                RageUI.Separator("↓ ~o~Actions ~s~↓")
                RageUI.ButtonWithStyle("~g~Valider",nil, {RightLabel = "→→"}, true, function(_,_,s) if s then RageUI.GoBack() end end)
            end, function()    
            end, 1)

            RageUI.IsVisible(RMenu:Get("fox_creator",'fox_sexe'),true,true,true,function()
                RageUI.Separator("↓ ~b~Sexe ~s~↓")
                RageUI.ButtonWithStyle("Homme",nil, {}, not antispam, function(_,_,s) 
                    if s then 
                        antispam = true
                        while not HasModelLoaded("mp_m_freemode_01") do
                            RequestModel("mp_m_freemode_01")
                            Citizen.Wait(0)
                        end
                        if IsModelInCdimage("mp_m_freemode_01") and IsModelValid("mp_m_freemode_01") then
                            SetPlayerModel(PlayerId(), "mp_m_freemode_01")
                            SetPedDefaultComponentVariation(PlayerPedId())
                        end
                        SetModelAsNoLongerNeeded("mp_m_freemode_01")
                        PedIndex = "mp_m_freemode_01"
                        antispam = false
                        ResetEntityAlpha(PlayerPedId())
                        NetworkConcealPlayer(NetworkGetPlayerIndexFromPed(PlayerPedId()), false, 1)
                    end 
                end)

                RageUI.ButtonWithStyle("Femme",nil, {}, not antispam, function(_,_,s) 
                    if s then 
                        antispam = true
                        while not HasModelLoaded("mp_f_freemode_01") do
                            RequestModel("mp_f_freemode_01")
                            Citizen.Wait(0)
                        end
                        if IsModelInCdimage("mp_f_freemode_01") and IsModelValid("mp_f_freemode_01") then
                            SetPlayerModel(PlayerId(), "mp_f_freemode_01")
                            SetPedDefaultComponentVariation(PlayerPedId())
                        end
                        SetModelAsNoLongerNeeded("mp_f_freemode_01")
                        PedIndex = "mp_f_freemode_01"
                        antispam = false
                        ResetEntityAlpha(PlayerPedId())
                        NetworkConcealPlayer(NetworkGetPlayerIndexFromPed(PlayerPedId()), false, 1)
                    end 
                end)
                RageUI.Separator("↓ ~o~Actions ~s~↓")
                RageUI.ButtonWithStyle("~g~Valider",nil, {RightLabel = "→→"}, true, function(_,_,s) if s then RageUI.GoBack() end end)
            end, function()    
            end, 1)

            RageUI.IsVisible(RMenu:Get("fox_creator",'fox_identity'),true,true,true,function()
                if err ~= nil then RageUI.Separator(coloredVariator..err) end
                RageUI.Separator("↓ ~b~Customisation ~s~↓")
                RageUI.ButtonWithStyle("Définir votre prénom",nil, {RightLabel = "~g~"..infos.first}, true, function(_,_,s)
                    if s then
                        err = nil
                        local prenom = ""
                        AddTextEntry("FMMC_MPM_NA", "Votre prénom")
                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Votre prénom:", "", "", "", "", 30)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0)
                            Wait(0)
                        end
                        if (GetOnscreenKeyboardResult()) then
                            local result = GetOnscreenKeyboardResult()
                            if result then
                                prenom = result
                                if string.len(prenom) < 3 then
                                    err = "Votre prénom est trop court !"
                                elseif string.len(prenom) > 20 then
                                    err = "Votre prénom est trop long !"
                                elseif tonumber(prenom) ~= nil then
                                    err = "Les nombres sont interdits !"
                                else
                                    infos.first = prenom
                                end
                            else
                                err = "Vous n'avez rien indiqué !"
                            end
                        end
                    end
                 end)
                RageUI.ButtonWithStyle("Définir votre nom",nil, {RightLabel = "~g~"..infos.last}, true, function(_,_,s) 
                    if s then
                        err = nil
                        local prenom = ""
                        AddTextEntry("FMMC_MPM_NA", "Votre nom")
                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Votre nom:", "", "", "", "", 30)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0)
                            Wait(0)
                        end
                        if (GetOnscreenKeyboardResult()) then
                            local result = GetOnscreenKeyboardResult()
                            if result then
                                prenom = result
                                if string.len(prenom) < 3 then
                                    err = "Votre nom est trop court !"
                                elseif string.len(prenom) > 20 then
                                    err = "Votre nom est trop long !"
                                elseif tonumber(prenom) ~= nil then
                                    err = "Les nombres sont interdits !"
                                else
                                    infos.last = prenom
                                end
                            else
                                err = "Vous n'avez rien indiqué !"
                            end
                        end
                    end
                end)
                RageUI.ButtonWithStyle("Définir votre age",nil, {RightLabel = "~g~"..infos.age}, true, function(_,_,s) 
                    if s then
                        err = nil
                        local prenom = ""
                        AddTextEntry("FMMC_MPM_NA", "Votre nom")
                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Votre nom:", "", "", "", "", 30)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0)
                            Wait(0)
                        end
                        if (GetOnscreenKeyboardResult()) then
                            local result = GetOnscreenKeyboardResult()
                            if result then
                                prenom = result
                                if string.len(prenom) < 2 then
                                    err = "Vous êtes trop jeune !"
                                elseif string.len(prenom) > 2 then
                                    err = "Vous êtes trop vieux !"
                                else
                                    infos.age = prenom
                                end
                            else
                                err = "Vous n'avez rien indiqué !"
                            end
                        end
                    end
                end)
                RageUI.Separator("↓ ~o~Actions ~s~↓")
                RageUI.ButtonWithStyle("~g~Valider",nil, {RightLabel = "→→"}, true, function(_,_,s) if s then RageUI.GoBack() end end)
            end, function()    
            end, 1)

            Citizen.Wait(0)
        end
    end, "creatorperso")

   -- GetNumberOfPedDrawableVariations
end

Fox.creator = initiCreator

