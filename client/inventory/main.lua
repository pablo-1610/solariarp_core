local display = false
local act = false
local viewWeight = false
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
        while display do Wait(1)
            local shouldEverBeOpened = false
            local total = 1
            local selectedObject = nil
            RageUI.IsVisible(RMenu:Get("fox_inv_self",'fox_inv_self_main'),true,true,true,function()
                shouldEverBeOpened = true
                if not act then 
                    RageUI.Checkbox("Visualisation du poids", nil, viewWeight, { Style = RageUI.CheckboxStyle.Tick }, function(Hovered, Selected, Active, Checked) viewWeight = Checked; end, function() viewWeight = true end, function() viewWeight = false end)
                    RageUI.Separator("~b~Poids: ~s~"..round(Fox.localData.self.inventory.currentWeight).."~b~/~s~"..round(Fox.localData.self.inventory.weight).."kg")
                    for item,qty in pairs(Fox.localData.self.inventory.items) do
                        total = total + 1
                        RageUI.ButtonWithStyle("~b~"..ITEM_ACTIONS[item].display.." ~s~(~b~"..qty.."~s~)","~b~Description: ~s~"..ITEM_ACTIONS[item].description, {RightLabel = "→→"}, true, function(_,a,s) if s then selectedItem = item end if a then selectedObject = item end  end, RMenu:Get("fox_inv_self","fox_inv_self_itemprecise"))
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
                        local closet, dst = Fox.clientutils.getClosestPlayer(GetEntityCoords(PlayerPedId()))
                        if closet == nil or dst == nil or dst >= 2.1 then canInteract = false else canInteract = true end
                        RageUI.Separator("~b~Poids: ~s~"..round(Fox.localData.self.inventory.currentWeight).."~b~/~s~"..round(Fox.localData.self.inventory.weight).."kg")
                        RageUI.Separator("~b~Sélection: ~s~"..ITEM_ACTIONS[selectedItem].display.." (~b~x"..Fox.localData.self.inventory.items[selectedItem].."~s~)")
                        --[[RageUI.Separator("↓ ~b~Informations ~s~↓")
                        RageUI.ButtonWithStyle("~b~Quantité: ~s~"..Fox.localData.self.inventory.items[selectedItem],nil, {}, true, function(_,_,s) end)
                        RageUI.ButtonWithStyle("~b~Poids unitaire: ~s~"..round(ITEM_ACTIONS[selectedItem].weight).."kg",nil, {}, true, function(_,_,s) end)
                        RageUI.ButtonWithStyle("~b~Poids occupé: ~s~"..round(ITEM_ACTIONS[selectedItem].weight*Fox.localData.self.inventory.items[selectedItem]).."kg",nil, {}, true, function(_,_,s) end)
                        --]]
                        RageUI.Separator("↓ ~b~Actions ~s~↓")
                        RageUI.ButtonWithStyle("~b~Utiliser",byState(2,ITEMS_CAT_USE[ITEM_ACTIONS[selectedItem].category] ~= nil),{RightLabel = "→→"}, ITEMS_CAT_USE[ITEM_ACTIONS[selectedItem].category] ~= nil, function(_,_,s) if s then act = true TriggerServerEvent("fox:inv:use", selectedItem) end end)
                        RageUI.ButtonWithStyle("~b~Jeter",byState(1,canInteract), {RightLabel = "→→"}, true, function(_,_,s) if s then act = true TriggerServerEvent("fox:inv:trash", selectedItem) end end)
                        RageUI.ButtonWithStyle("~b~Donner",byState(1,canInteract), {RightLabel = "→→"}, canInteract, function(_,_,s) end)
                        
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
    act = false
    ITEMS_CAT_USE[ITEM_ACTIONS[item].category](ITEM_ACTIONS[item].args)
end)

RegisterNetEvent("fox:inv:trashBack")
AddEventHandler("fox:inv:trashBack", function(item) act = false end)
