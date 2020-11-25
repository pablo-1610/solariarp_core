Fox.hud = {}

local shouldBeDisplayed = true

local function drawText2D(x, y, text, scale)
    SetTextFont(4)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end
    
local function loading(message)
    if type(message) == "string" then
        Citizen.InvokeNative(0xABA17D7CE615ADBF, "STRING")
        AddTextComponentSubstringPlayerName(message)
        Citizen.InvokeNative(0xBD12F8228410D9B4, 3)
    else
        Citizen.InvokeNative(0xABA17D7CE615ADBF, "STRING")
        AddTextComponentSubstringPlayerName("")
        Citizen.InvokeNative(0xBD12F8228410D9B4, -1)
    end
end
    
local hudTop = 0.805
local hudMargin = 0.160


local hudSpace = 0.028


local function initialize()

    Fox.thread.tick(function()
        while true do
            if shouldBeDisplayed then
                drawText2D(hudMargin, hudTop, "Argent: ~g~"..Fox.localData.self.accounts["cash"].."$", 0.55)
                drawText2D(hudMargin, hudTop+(1*hudSpace), "Banque: ~b~"..Fox.localData.self.accounts["bank"].."$", 0.55)       
                drawText2D(hudMargin, hudTop+(2*hudSpace), "Sale: ~r~"..Fox.localData.self.accounts["black"].."$", 0.55)      
                drawText2D(hudMargin, hudTop+(3*hudSpace), "Sac: ~o~"..Fox.localData.self.inventory.currentWeight.."~s~/~y~"..Fox.localData.self.inventory.weight.."kg", 0.55)              
            end
            Citizen.Wait(1)
        end
    end, "hud")
end
Fox.hud.init = initialize

local function alterVisibility()
     shouldBeDisplayed = not shouldBeDisplayed 
     DisplayRadar(shouldBeDisplayed)
end
Fox.hud.switch = alterVisibility

local function forceVisibility(switch) 
    shouldBeDisplayed = switch 
    DisplayRadar(shouldBeDisplayed)
end
Fox.hud.force = forceVisibility