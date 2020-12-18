Citizen.SetTimeout(1500, function()
for i = 1,3 do print("") end
Fox.trace("^3Solaria • launching...^7")
print("")
loadInventories()
end)

RegisterCommand("forcePos", function(source, args, rawcommand)
    if source == 0 then
        Fox.trace("^1[ADMIN] ^7Forced players to save their positions")
        TriggerClientEvent("fox:data:forcePos", -1)
    end
end, false)