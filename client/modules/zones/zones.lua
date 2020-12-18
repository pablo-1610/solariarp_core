local zones = {}
Fox.zones = {}

local function create(id, color, type, loc, helpMsg, onEnter)
    if zones[id] then id = #zones+1 end
    zones[id] = {
        rgb = color,
        sprite = type,
        handler = onEnter,
        pos = loc,
        help = helpMsg,
        isActive = true,
        restricted = "NONE",
        drawing = 10.0,
        interaction = 1.0,
        control = 51
    }
    Fox.trace("Creating new marker wich id is "..id)   
    return id
end
Fox.zones.create = create

local function getAccess(restriction)
    local access = {
        ["NONE"] = function() return true end
    }
    return access[restriction]
end
Fox.zones.getAccess = getAccess

local function delete(id)
    if not zones[id] then 
        Fox.trace("Trying to remove marker wich not exists ! Marker id is "..id)
        return
    end
    zones[id] = nil
    Fox.trace("Removing marker wich id is "..id)
end
Fox.zones.delete = delete

local function subscribe(id)
    if not zones[id] then return end
    zones[id].isActive = true
end
Fox.zones.subscribe = subscribe

local function unsubscribe(id)
    if not zones[id] then return end
    zones[id].isActive = false
end
Fox.zones.unsubscribe = unsubscribe

local function init()
    Fox.thread.tick(function()
        Fox.debug("Markers thread initialized")
        while true do
            local wait,closeTo,base = 1,false,GetEntityCoords(PlayerPedId())
            for markerID, zone in pairs(zones) do
                if GetDistanceBetweenCoords(base, zone.pos, true) <= zone.drawing and zone.isActive then
                    closeTo = true
                    DrawMarker(22, zone.pos, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, zone.rgb.r, zone.rgb.g, zone.rgb.b, 255, 55555, false, true, 2, false, false, false, false)
                    if GetDistanceBetweenCoords(base, zone.pos, true) <= zone.interaction then
                        if getAccess(zone.restricted) then
                            if zone.help then 
                                AddTextEntry("MARKER", zone.help)
                                DisplayHelpTextThisFrame("MARKER", false)
                            end
                            if IsControlJustPressed(0, zone.control) then
                                zone.handler()
                            end
                        end
                    end
                end
                if closeTo then wait = 1 else wait = 250 end
            end
            Wait(wait)
        end
    end, "markers")
end
Fox.zones.init = init