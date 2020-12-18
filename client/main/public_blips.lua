Fox.blips = {}

local alreadyInitialized = false

-- Zones initials
Fox.blips.zones = {

}
-- Blips initials
Fox.blips.list = {
    {name = "Banque centrale", sprite = 108, colour = 11, shortRange = true, scale = 0.9, position = vector3(249.25, 217.78, 106.28)},
    {name = "Commissariat", sprite = 461, colour = 38, shortRange = true, scale = 0.9, position = vector3(437.87, -981.95, 30.30)},
    {name = "Hôpital", sprite = 61, colour = 2, shortRange = true, scale = 0.9, position = vector3(299.29, -584.74, 43.26)},
    {name = "Magasin De Masque", sprite = 362, colour = 2, shortRange = true, scale = 0.9, position = vector3(-1336.60, -1277.84, 4.87)}
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