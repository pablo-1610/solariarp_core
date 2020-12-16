local display = false
local state = 0
local items = {}

local function round(value)
    local numDecimalPlaces = 2
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", value))
end

Fox.utils.openSelfInventory = function()
    if display then return end
    local selectedItem = nil
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
        while display do Wait(1)
            local shouldEverBeOpened = false
            RageUI.IsVisible(RMenu:Get("fox_inv_self",'fox_inv_self_main'),true,true,true,function()
                shouldEverBeOpened = true
                RageUI.Separator("~b~Poids: ~s~"..round(Fox.localData.self.inventory.currentWeight).."~b~/~s~"..round(Fox.localData.self.inventory.weight).."kg")
                for item,qty in pairs(Fox.localData.self.inventory.items) do
                    RageUI.ButtonWithStyle("~b~"..ITEM_ACTIONS[item].display.." ~s~(~b~"..qty.."~s~)",nil, {RightLabel = "→→"}, true, function(_,_,s) if s then selectedItem = item end end, RMenu:Get("fox_inv_self","fox_inv_self_itemprecise"))
                end
            end, function()  
                zz = 0.5
                RageUI.PercentagePanel(zz, "Percentage", nil, nil, function(Hovered, Active, Percent)
                    if (Active) then
        
                    end
                    zz = Percent
                end, 2)
                RageUI.PercentagePanel(zz, "Percentage", nil, nil, function(Hovered, Active, Percent)
                    if (Active) then
        
                    end
                    zz = Percent
                end, 1)
            end)

            RageUI.IsVisible(RMenu:Get("fox_inv_self",'fox_inv_self_itemprecise'),true,true,true,function()
                shouldEverBeOpened = true
                local canInteract = false
                if not selectedItem then RageUI.GoBack() end
                local closet, dst = Fox.clientutils.getClosestPlayer(GetEntityCoords(PlayerPedId()))
                if closet == nil or dst == nil or dst >= 2.1 then canInteract = false else canInteract = true end
                RageUI.Separator("~b~Poids: ~s~"..round(Fox.localData.self.inventory.currentWeight).."~b~/~s~"..round(Fox.localData.self.inventory.weight).."kg")
                RageUI.Separator("~b~Sélection: ~s~"..ITEM_ACTIONS[selectedItem].display)
                RageUI.Separator("↓ ~b~Informations ~s~↓")
                RageUI.ButtonWithStyle("~b~Quantité: ~s~"..Fox.localData.self.inventory.items[selectedItem],nil, {}, true, function(_,_,s) end)
                RageUI.ButtonWithStyle("~b~Poids unitaire: ~s~"..round(ITEM_ACTIONS[selectedItem].weight).."kg",nil, {}, true, function(_,_,s) end)
                RageUI.ButtonWithStyle("~b~Poids occupé: ~s~"..round(ITEM_ACTIONS[selectedItem].weight*Fox.localData.self.inventory.items[selectedItem]).."kg",nil, {}, true, function(_,_,s) end)
                RageUI.Separator("↓ ~b~Actions ~s~↓")
                RageUI.ButtonWithStyle("~b~Donner",nil, {RightLabel = "→→"}, canInteract, function(_,_,s) end)
                RageUI.ButtonWithStyle("~b~Jeter",nil, {RightLabel = "→→"}, canInteract, function(_,_,s) end)
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

RegisterNetEvent("fox:inv:receiveSelf")
AddEventHandler("fox:inv:receiveSelf", function(inv)
end)
