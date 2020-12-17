local display = false
local act = false
local viewWeight = true
local alert = ""
local state = 0
local items = {}

local function round(value)
    local numDecimalPlaces = 2
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", value))
end
local function roundNorm(value)
    local numDecimalPlaces = 0
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", value))
end
local function byState(index,val)
    local infos = {
        [1] = {[true] = "~b~Donner l'objet au joueur le plus proche", [false] = "~r~Aucun joueur proche de vous !"},
        [2] = {[true] = "~b~Utiliser cet objet", [false] = "~r~Cet objet est inutilisable !"}
    }
    return infos[index][val]
end

Fox.utils.openSelfInventory = function()
    if display then return end
    alert = ""
    local selectedItem,point,variator = nil,"","~y~"
    items = {}
    display = true
    RageUI.CloseAll()
    RMenu.Add('fox_inv_self', 'fox_inv_self_main', RageUI.CreateMenu(nil, "~b~Inventaire personnel", nil, nil, "root_cause" , "yougoutoucou"))
    RMenu:Get("fox_inv_self", "fox_inv_self_main").Closed = function()end
    RMenu:Get("fox_inv_self", "fox_inv_self_main").Closable = true

    RMenu.Add('fox_inv_self', 'fox_inv_self_itemprecise', RageUI.CreateSubMenu(RMenu:Get('fox_inv_self', 'fox_inv_self_main'), nil, "~b~Inventaire personnel"))
    RMenu:Get('fox_inv_self', 'fox_inv_self_itemprecise').Closed = function()end
    RMenu:Get("fox_inv_self", "fox_inv_self_itemprecise").Closable = true

    RageUI.Visible(RMenu:Get("fox_inv_self",'fox_inv_self_main'), true)

    Fox.thread.tick(function()
        while display do Wait(750)
            if variator == "~y~" then variator = "~o~" else variator = "~y~" end
            if point == "" then point = "." elseif point == "." then point = ".." elseif point == ".." then point = "..." elseif point == "..." then point = "" end
        end
    end, "RageUIVariator")

    Fox.thread.tick(function()
        local totrash = 1
        while display do Wait(1)
            local shouldEverBeOpened = false
            local total = 1
            local selectedObject = nil
            RageUI.IsVisible(RMenu:Get("fox_inv_self",'fox_inv_self_main'),true,true,true,function()
                shouldEverBeOpened = true
                if not act then 
                    if alert ~= "" then RageUI.Separator(variator..alert) end
                    RageUI.Checkbox("Visualisation du poids", nil, viewWeight, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked) viewWeight = Checked; end, function() viewWeight = true end, function() viewWeight = false end)
                    RageUI.Separator("~b~Poids: ~s~"..round(Fox.localData.self.inventory.currentWeight).."~b~/~s~"..round(Fox.localData.self.inventory.weight).."kg")
                    for item,qty in pairs(Fox.localData.self.inventory.items) do
                        total = total + 1
                        RageUI.ButtonWithStyle("~b~"..ITEM_ACTIONS[item].display.." ~s~(~b~x"..qty.."~s~)","~b~Description: ~s~"..ITEM_ACTIONS[item].description, {RightLabel = "→→"}, true, function(_,a,s) if s then selectedItem = item end if a then selectedObject = item end  end, RMenu:Get("fox_inv_self","fox_inv_self_itemprecise"))
                    end
                    if (total-1) <= 0 then RageUI.Separator("") RageUI.Separator("~r~Oups ! Il semblerait que vous n'ayez rien") RageUI.Separator("~r~dans votre inventaire, il faudrait songer à") RageUI.Separator("~r~faire des courses.. et rapidement :/") RageUI.Separator("") end
                else
                    RageUI.Separator("")
                    RageUI.Separator("~r~- Inventaire temporairement indisponible -")
                    RageUI.Separator("~r~Re-synchronisation avec le serveur en cours"..point)
                    RageUI.Separator("")
                    RageUI.Separator(variator.."Si le problème persiste, contactez un administrateur")
                    RageUI.Separator("")
                end
            end, function()  
                if not act and viewWeight then
                    local ocAll = roundNorm((Fox.localData.self.inventory.currentWeight/Fox.localData.self.inventory.weight)*100)
                    RageUI.StatisticPanelAdvanced("Total ~s~[~r~"..ocAll.."%~s~]", (Fox.localData.self.inventory.currentWeight/Fox.localData.self.inventory.weight), nil, 0.0, nil, nil, 1) 
                    for i = 2,total+1 do --RageUI.PercentagePanel((Fox.localData.self.inventory.currentWeight/Fox.localData.self.inventory.weight), "Espace disponible", nil, nil, function(Hovered, Active, Percent)end, i) 
                    if selectedObject ~= nil then 
                        local ocOne = roundNorm(((Fox.localData.self.inventory.items[selectedObject]*ITEM_ACTIONS[selectedObject].weight)/Fox.localData.self.inventory.weight)*100)
                        RageUI.StatisticPanelAdvanced("Total ~s~[~r~"..ocAll.."%~s~]", (Fox.localData.self.inventory.currentWeight/Fox.localData.self.inventory.weight), nil, 0.0, nil, nil, i) 
                        RageUI.StatisticPanelAdvanced("Objets ~s~[~r~"..ocOne.."%~s~]", 0.0, nil, (Fox.localData.self.inventory.items[selectedObject]*ITEM_ACTIONS[selectedObject].weight)/Fox.localData.self.inventory.weight, nil, nil, i) 
                    end end
                end
            end)

            RageUI.IsVisible(RMenu:Get("fox_inv_self",'fox_inv_self_itemprecise'),true,true,true,function()
                shouldEverBeOpened = true
                if not act then
                    local canInteract = false
                    if not selectedItem or not Fox.localData.self.inventory.items[selectedItem] then Fox.trace("^1No more item of this type, returning to inv main") RageUI.GoBack() else
                        local closet, dst = Fox.clientutils.getClosestPlayer()
                        if closet ~= nil then 
                            local coOther = GetEntityCoords(GetPlayerPed(closet))
                            local coPerso = GetEntityCoords(PlayerPedId())
                            local distance = GetDistanceBetweenCoords(coOther, coPerso, 1)
                            if distance < 3.0 then 
                                canInteract = true 
                            end 
                            
                        end
                        if alert ~= "" then RageUI.Separator(variator..alert) end
                        RageUI.Separator("~b~Poids: ~s~"..round(Fox.localData.self.inventory.currentWeight).."~b~/~s~"..round(Fox.localData.self.inventory.weight).."kg")
                        RageUI.Separator("~b~Sélection: ~s~"..ITEM_ACTIONS[selectedItem].display.." (~b~x"..Fox.localData.self.inventory.items[selectedItem].."~s~)")
                        RageUI.Separator("↓ ~b~Actions ~s~↓")
                        RageUI.ButtonWithStyle("~b~Utiliser",byState(2,ITEMS_CAT_USE[ITEM_ACTIONS[selectedItem].category] ~= nil),{RightLabel = "→→"}, ITEMS_CAT_USE[ITEM_ACTIONS[selectedItem].category] ~= nil, function(_,_,s) if s then act = true TriggerServerEvent("fox:inv:use", selectedItem) end end)
                        local trashList = {}
                        for i = 1,tonumber(Fox.localData.self.inventory.items[selectedItem]) do trashList[i] = "~r~Jeter "..i.."~s~" end
                        if totrash > Fox.localData.self.inventory.items[selectedItem] then totrash = 1 end

                        RageUI.List("~b~Jeter", trashList, totrash, nil, {}, true, function(Hovered, Active, Selected, Index)
                            if Selected then
                                act = true TriggerServerEvent("fox:inv:trash", selectedItem,totrash)
                            end
                            totrash = Index
                        end)

                        trashList = {}
                        for i = 1,tonumber(Fox.localData.self.inventory.items[selectedItem]) do
                            trashList[i] = "~r~Donner "..i.."~s~"
                        end
                        if totrash > Fox.localData.self.inventory.items[selectedItem] then totrash = 1 end

                        RageUI.List("~b~Donner", trashList, totrash, byState(1,canInteract), {}, canInteract, function(Hovered, Active, Selected, Index)
                            if Active and canInteract then
                                local cCoords = GetEntityCoords(GetPlayerPed(closet))
                                DrawMarker(20, cCoords.x, cCoords.y, cCoords.z+1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.3, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)
                            end
                            if Selected and canInteract then
                
                                act = true TriggerServerEvent("fox:inv:giveToPlayer", GetPlayerServerId(closet),selectedItem,totrash)
                            end
                            totrash = Index
                        end)
                    end
                else
                    RageUI.Separator("")
                    RageUI.Separator("~r~- Inventaire temporairement indisponible -")
                    RageUI.Separator("~r~Re-synchronisation avec le serveur en cours"..point)
                    RageUI.Separator("")
                    RageUI.Separator(variator.."Si le problème persiste, contactez un administrateur")
                    RageUI.Separator("")
                end
            end, function()   

            end)

            

            if not shouldEverBeOpened then
                RageUI.CloseAll()
                RMenu:Delete("fox_inv_self", "fox_inv_self_main")
                display = false
            end
        end
    end,"inventorySelf")
end

RegisterNetEvent("fox:inv:useBack")
AddEventHandler("fox:inv:useBack", function(item)
    alert = ""
    act = false
    ITEMS_CAT_USE[ITEM_ACTIONS[item].category](ITEM_ACTIONS[item].args)
end)

RegisterNetEvent("fox:inv:alert")
AddEventHandler("fox:inv:alert", function(str)
    act = false
    alert = str
end)

RegisterNetEvent("fox:inv:trashBack")
AddEventHandler("fox:inv:trashBack", function(item) alert = "" act = false end)



RegisterNetEvent("fox:inv:giveBack")
AddEventHandler("fox:inv:giveBack", function(item,qty,target)
    alert = "" act = false 
    Fox.clientutils.advancedNotif("Inventaire","~r~Don d'objet","Vous avez donné ~y~"..qty.." "..ITEM_ACTIONS[item].display.." ~s~à ~b~"..target,"CHAR_MILSITE",2)
end)

RegisterNetEvent("fox:inv:receive")
AddEventHandler("fox:inv:receive", function(item,qty,target)
    Fox.clientutils.advancedNotif("Inventaire","~r~Récéption d'objet","Vous avez reçu ~y~"..qty.." "..ITEM_ACTIONS[item].display.." ~s~de la part de ~b~"..target,"CHAR_MILSITE",2)
end)
