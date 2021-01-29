Fox.blips = {}

local alreadyInitialized = false

-- Zones initials
Fox.blips.zones = {

}
-- Blips initials
Fox.blips.list = {
    {name = "Banque centrale", sprite = 108, colour = 11, shortRange = true, scale = 0.9, position = vector3(249.25, 217.78, 106.28)},
    {name = "Commissariat de police", sprite = 137, colour = 38, shortRange = true, scale = 0.9, position = vector3(437.87, -981.95, 30.30)},
    {name = "Hôpital", sprite = 61, colour = 2, shortRange = true, scale = 0.9, position = vector3(299.29, -584.74, 43.26)},
    {name = "Magasin De Masque", sprite = 362, colour = 2, shortRange = true, scale = 0.9, position = vector3(-1336.60, -1277.84, 4.87)},
    {name = "Concessionnaire", sprite = 225, colour = 4, shortRange = true, scale = 0.9, position = vector3(-38.34, -1108.92, 26.43)},
    {name = "Taxi", sprite = 198, colour = 5, shortRange = true, scale = 0.9, position = vector3(894.97, -179.17, 74.70)},
    {name = "Karting", sprite = 127, colour = 44, shortRange = true, scale = 0.9, position = vector3(898.63, -3129.66, 5.91)}
    
}

Fox.blips.initialize = function()
    if not alreadyInitialized then
        for k,v in pairs(Fox.blips.list) do
            local blip = AddBlipForCoord(v.position)
            SetBlipSprite(blip, v.sprite)
            SetBlipAsShortRange(blip, false)
            SetBlipColour(blip, v.colour)
            SetBlipScale(blip, v.scale)
            SetBlipCategory(blip, 12)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.name)
            EndTextCommandSetBlipName(blip)
            SetBlipFlashes(blip, true)
            SetTimeout(6500, function() SetBlipFlashes(blip, false) SetBlipAsShortRange(blip,v.shortRange)  end)
            Wait(180)
        end
        alreadyInitialized = true
    end
end