AddEventHandler("fox:initialize", function()
    local zone = Fox.zones.create("creditcardmanager1",{r = 255, g = 0, b = 0},vector3(242.02, 224.02, 106.28),"Appuyez ~INPUT_CONTEXT~ pour gérer vos cartes bancaires",
    function()
        Fox.utils.openBankManagerMenu()
    end)

    local zone2 = Fox.zones.create("creditcardmanager2",{r = 255, g = 0, b = 0},vector3(247.29, 222.12, 106.28),"Appuyez ~INPUT_CONTEXT~ pour gérer vos cartes bancaires",
    function()
        Fox.utils.openBankManagerMenu()
    end)

    local zone3 = Fox.zones.create("creditcardmanager3",{r = 255, g = 0, b = 0},vector3(252.44, 220.26, 106.28),"Appuyez ~INPUT_CONTEXT~ pour gérer vos cartes bancaires",
    function()
        Fox.utils.openBankManagerMenu()
    end)

    Fox.zones.drawDist(zone,50.0)
    Fox.zones.drawDist(zone2,50.0)
    Fox.zones.drawDist(zone3,50.0)
end)