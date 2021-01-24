local connected = false

local function disconnectedText()
    local coloredVar = "~o~"
    Fox.thread.tick(function()
        while not connected do Wait(750) 
            if coloredVar == "~o~" then coloredVar = "~r~" else coloredVar = "~o~" end
        end
    end,"ts3Disconnected")
    Fox.thread.tick(function()
        while not connected do Wait(1) 
            RageUI.Text({message = coloredVar.."Vous n'êtes pas connecté au TeamSpeak de Solaria !"})
        end
    end,"ts3Disconnected")
end

AddEventHandler("fox:playerLoaded", function()
    disconnectedText()
end)

RegisterNetEvent("fox:ts3:disconnected")
RegisterNetEvent("fox:ts3:connected")

AddEventHandler("fox:ts3:disconnected", function()
    connected = false
    disconnectedText()
end)

AddEventHandler("fox:ts3:connected", function()
    connected = true
end)

