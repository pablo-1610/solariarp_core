AddEventHandler("fox:initialize", function()
    local zone = Fox.zones.create(
        "creditcardmanager",
        {r = 255, g = 0, b = 0},
        22,
        vector3(242.95, 223.67, 106.28),
        "Appuyez ~INPUT_CONTEXT~ pour gérer vos cartes bancaires",
        function()
            Fox.utils.openBankManagerMenu()
        end
    )

    Fox.zones.drawDist(zone,50.0)
end)