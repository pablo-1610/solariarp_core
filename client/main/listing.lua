local playersCache = {}

local currentScaleform = nil

local function orderByRank(a,b)
    return a.rankID > b.rankID
end

RegisterNetEvent("fox:tab:updtate")
AddEventHandler("fox:tab:updtate", function(data)
    Fox.trace("Tablist updated")
    playersCache = data
end)

Fox.thread.tick(function()
    Fox.trace("Listing OK")
    function drawscaleform(scaleform)
        scaleform = RequestScaleformMovie(scaleform)
        while not HasScaleformMovieLoaded(scaleform) do
            Citizen.Wait(0)
        end
        currentScaleform = scaleform
        
        
        PushScaleformMovieFunction(scaleform, "SET_ICON")
        PushScaleformMovieFunctionParameterInt(100)
        PushScaleformMovieFunctionParameterInt(7)
        PushScaleformMovieFunctionParameterInt(66)
        PopScaleformMovieFunctionVoid()

        PushScaleformMovieFunction(scaleform, "SET_TITLE")
        PushScaleformMovieFunctionParameterString("~o~Solaria ~s~•~b~ "..#playersCache.."~s~/~b~"..Fox.globalInfos.slots)
        PushScaleformMovieFunctionParameterString("~r~Le futur du RolePlay")
        PushScaleformMovieFunctionParameterInt(20)
        PopScaleformMovieFunctionVoid()

        for i = 0, (Fox.globalInfos.slots+1) do
            PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT_EMPTY")
            PushScaleformMovieFunctionParameterInt(i)
            PopScaleformMovieFunctionVoid()
        end

        if #playersCache > 0 then
            table.sort(playersCache,orderByRank)
        end
        for position,data in pairs(playersCache) do
            PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
            PushScaleformMovieFunctionParameterInt(position-1)
            PushScaleformMovieFunctionParameterString("ID "..data.sID)
            PushScaleformMovieFunctionParameterString(Fox.ranks[data.rankID].genericColor..Fox.ranks[data.rankID].genericName.."~s~"..data.name)
            PushScaleformMovieFunctionParameterInt(Fox.ranks[data.rankID].genericListingColor)
            -- 111 = Bleu
            -- 255 = Bleu
            PushScaleformMovieFunctionParameterInt(1)
            PushScaleformMovieFunctionParameterString("")
            PushScaleformMovieFunctionParameterString("")
            PushScaleformMovieFunctionParameterString("")
            PushScaleformMovieFunctionParameterInt(2)
            if data.mug then 
                Fox.trace("Mugshot defined")
                PushScaleformMovieFunctionParameterString(data.mug)
                PushScaleformMovieFunctionParameterString(data.mug)
            else 
                PushScaleformMovieFunctionParameterString("")
                PushScaleformMovieFunctionParameterString("")
            end

            --PushScaleformMovieFunctionParameterString(' ')
           
            PopScaleformMovieFunctionVoid()
        end


        --DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255, 0)
        DrawScaleformMovie(scaleform, 0.50, 0.285, 0.27, 0.57, 255,255,255,255,255)
    end
    while true do
        Citizen.Wait(0)
        drawscaleform("mp_mm_card_freemode")
        if IsControlPressed(0, 20) then
            PushScaleformMovieFunction(currentScaleform, "DISPLAY_VIEW")
            PopScaleformMovieFunctionVoid()
        end
    end
end, "listing")

-- TODO -> Les mugshots

local function mug(ped)
	local mugshot = RegisterPedheadshot(ped)

	while not IsPedheadshotReady(mugshot) do
		Citizen.Wait(0)
	end

	return GetPedheadshotTxdString(mugshot)
end

RegisterCommand("mug", function()
    print(mug(PlayerPedId()))
end, false)