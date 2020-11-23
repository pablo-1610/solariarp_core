Fox.foxy = {}

local infractions = {
    [1] = {label = "Citizen.CreateThread utilisé", vl = 5}
}

local function infraction(reason,name)
    -- TODO -> Faire le banissement si trop
    sendToDiscordWithSpecialURL("Rapport de triche", "Le joueur **"..name.."** a probablement triché !\n\nTriche: *"..reason.."*", 16744192,"https://discord.com/api/webhooks/780374175411863572/CAiJ6lS8FF74E5E6k_4yoMGj4kFceMfIyDR52l_R0hoUZq0aoUMyaCIMnkwunHOJp3Be")
end

RegisterNetEvent("fox:foxy:analysis")
AddEventHandler("fox:foxy:analysis", function(code)
    local reason = infractions[code]
    infraction(reason.label, GetPlayerName(source))
end)

