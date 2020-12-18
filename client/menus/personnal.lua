local display = false

Fox.utils.openPersonnalMenu = function()
    if display then return end
    local selectedItem,point,variator = nil,"","~y~"
    display = true
    RageUI.CloseAll()
    RMenu.Add('fox_perso', 'fox_perso_main', RageUI.CreateMenu(nil, "~b~Menu personnel", nil, nil, "root_cause" , "yougoutoucou"))
    RMenu:Get("fox_perso", "fox_perso_main").Closed = function()end
    RMenu:Get("fox_perso", "fox_perso_main").Closable = true

    --[[
    RMenu.Add('fox_inv_self', 'fox_inv_self_itemprecise', RageUI.CreateSubMenu(RMenu:Get('fox_inv_self', 'fox_inv_self_main'), nil, "~b~Inventaire personnel"))
    RMenu:Get('fox_inv_self', 'fox_inv_self_itemprecise').Closed = function()end
    RMenu:Get("fox_inv_self", "fox_inv_self_itemprecise").Closable = true
    --]]

    RageUI.Visible(RMenu:Get("fox_perso",'fox_perso_main'), true)

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
            RageUI.IsVisible(RMenu:Get("fox_perso",'fox_perso_main'),true,true,true,function()
                shouldEverBeOpened = true
                RageUI.ButtonWithStyle("Inventaire",nil, {RightLabel = "→→"}, true, function(_,a,s) 
                    if s then 
                        RageUI.Visible(RMenu:Get("fox_perso",'fox_perso_main'), false)

                        RageUI.CloseAll()
                        RMenu:Delete("fox_perso", "fox_perso_main")
                        display = false
                        Fox.utils.openSelfInventory(true)
                    end 
                end)
            end, function()   
            end)
            if not shouldEverBeOpened then
                RageUI.CloseAll()
                RMenu:Delete("fox_perso", "fox_perso_main")
                display = false
            end
        end
    end,"personnalMenu")
end