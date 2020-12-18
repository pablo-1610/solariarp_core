local display = false
local state = 0
local err = nil
local creditCardInfos = {}

Fox.utils.openBankManagerMenu = function()
    if display then return end
    local initialPos = GetEntityCoords(PlayerPedId())
    local point,variator = "","~y~"
    display = true
    state = 0
    RageUI.CloseAll()
    RMenu.Add('fox_bank', 'fox_bank_main', RageUI.CreateMenu(nil, "~b~Banque centrale", nil, nil, "root_cause" , "yougoutoucou"))
    RMenu:Get("fox_bank", "fox_bank_main").Closed = function()end
    RMenu:Get("fox_bank", "fox_bank_main").Closable = true

    RMenu.Add('fox_bank', 'fox_bank_my', RageUI.CreateSubMenu(RMenu:Get('fox_bank', 'fox_bank_main'), nil, "~b~Banque centrale"))
    RMenu:Get('fox_bank', 'fox_bank_my').Closed = function()end
    RMenu:Get("fox_bank", "fox_bank_my").Closable = true

    RMenu.Add('fox_bank', 'fox_bank_other', RageUI.CreateSubMenu(RMenu:Get('fox_bank', 'fox_bank_main'), nil, "~b~Banque centrale"))
    RMenu:Get('fox_bank', 'fox_bank_other').Closed = function()end
    RMenu:Get("fox_bank", "fox_bank_other").Closable = true
    

    RageUI.Visible(RMenu:Get("fox_bank",'fox_bank_main'), true)

    Fox.thread.tick(function()
        while display do Wait(750)
            if variator == "~y~" then variator = "~o~" else variator = "~y~" end
            if point == "" then point = "." elseif point == "." then point = ".." elseif point == ".." then point = "..." elseif point == "..." then point = "" end
        end
    end, "RageUIVariator")

    Fox.thread.tick(function()
        local totrash = 1
        local id,pass = "~b~Changer","~b~Changer"
        while display do Wait(1)
            local shouldEverBeOpened = false
            RageUI.IsVisible(RMenu:Get("fox_bank",'fox_bank_main'),true,true,true,function()
                shouldEverBeOpened = true
                RageUI.Separator("~b~Banque centrale Américaine")
                RageUI.ButtonWithStyle("Ma carte bancaire",nil, {RightLabel = "→→"}, true, function(_,a,s) 
                    if s then
                        state = 0
                        TriggerServerEvent("fox:data:bankRqSelf")
                    end
                end,RMenu:Get("fox_bank", "fox_bank_my"))
                RageUI.ButtonWithStyle("Autre carte bancaire",nil, {RightLabel = "→→"}, true, function(_,a,s) 
                end,RMenu:Get("fox_bank", "fox_bank_other"))

            end, function()   
            end)

            RageUI.IsVisible(RMenu:Get("fox_bank",'fox_bank_other'),true,true,true,function()
                shouldEverBeOpened = true
                if err ~= nil then RageUI.Separator(variator..err) end
                RageUI.Separator("~b~Banque centrale Américaine")
                RageUI.ButtonWithStyle("Identifiant",nil, {RightLabel = "~g~"..id.." ~s~→→"}, true, function(_,a,s) 
                    if s then
                        err = nil
                        local input = ""
                        AddTextEntry("FMMC_MPM_NA", "Identifiant de la carte")
                        DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Identifiant de la carte:", "", "", "", "", 5)
                        while (UpdateOnscreenKeyboard() == 0) do
                            DisableAllControlActions(0)
                            Wait(0)
                        end
                        if (GetOnscreenKeyboardResult()) then
                            local result = GetOnscreenKeyboardResult()
                            if result then
                                input = result
                                if string.len(input) > 5 then
                                    err = "Identifiant trop long !"
                                elseif string.len(input) < 5 then
                                    err = "Identifiant trop court !"
                                else
                                    id = input
                                end
                            else
                                err = "Vous n'avez rien indiqué !"
                            end
                        end
                    end
                end)
                RageUI.ButtonWithStyle("Code secret",nil, {RightLabel = "~g~"..pass.." ~s~→→"}, true, function(_,a,s) 
                    if s then
                        if s then
                            err = nil
                            local input = ""
                            AddTextEntry("FMMC_MPM_NA", "Code de la carte")
                            DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Code de la carte:", "", "", "", "", 35)
                            while (UpdateOnscreenKeyboard() == 0) do
                                DisableAllControlActions(0)
                                Wait(0)
                            end
                            if (GetOnscreenKeyboardResult()) then
                                local result = GetOnscreenKeyboardResult()
                                if result then
                                    input = result
                                    if string.len(input) > 35 then
                                        err = "Code trop long !"
                                    elseif string.len(input) < 2 then
                                        err = "Code trop court !"
                                    else
                                        pass = input
                                    end
                                else
                                    err = "Vous n'avez rien indiqué !"
                                end
                            end
                        end
                    end
                end)
                RageUI.Separator("")
                RageUI.ButtonWithStyle("~g~Connexion",nil, {RightLabel = "~s~→→"}, true, function(_,a,s) 
                    if s then
                        err = nil
                        if id == "~b~Changer" or pass == "~b~Changer" then err = "Completez les champs indiqués !" end
                    end
                end)

            end, function()   
            end)

            RageUI.IsVisible(RMenu:Get("fox_bank",'fox_bank_my'),true,true,true,function()
                shouldEverBeOpened = true
                if state == 0 then
                    RageUI.Separator("")
                    RageUI.Separator(variator.."Nous récupérons votre carte"..point)
                    RageUI.Separator("")
                elseif state == 1 then
                    RageUI.Separator("")
                    RageUI.Separator(variator.."Vous n'avez pas de carte !")
                    RageUI.Separator("")
                    RageUI.ButtonWithStyle("Créer ma carte",nil, {RightLabel = "~s~→→"}, true, function(_,a,s) 
                        if s then
                            state = 2
                        end
                    end)
                elseif state == 2 then
                end

            end, function()   
            end)

            if GetDistanceBetweenCoords(initialPos, GetEntityCoords(PlayerPedId())) > 2.0 then shouldEverBeOpened = false end

            if not shouldEverBeOpened then
                RageUI.CloseAll()
                RMenu:Delete("fox_bank", "fox_perso_main")
                RMenu:Delete("fox_bank", "fox_bank_my")
                RMenu:Delete("fox_bank", "fox_bank_other")
                display = false
            end
        end
    end,"bankMenu")
end

RegisterNetEvent("fox:data:bankRqCb")
AddEventHandler("fox:data:bankRqCb", function(data)
    if data == nil then 
        state = 1
        return 
    end
end)