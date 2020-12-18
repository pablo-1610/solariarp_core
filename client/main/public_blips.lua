Fox.blips = {}

local alreadyInitialized = false

-- Zones initials
Fox.blips.zones = {

}
-- Blips initials
Fox.blips.list = {
    {name = "Banque centrale", sprite = 108, colour = 11, shortRange = true, scale = 0.9, position = vector3(249.25, 217.78, 106.28)}
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