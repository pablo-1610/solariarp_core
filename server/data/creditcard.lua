local creditCards = {}

function loadCb()
    local loaded = 0
    MySQL.Async.fetchAll("SELECT * FROM creditcards", {}, function(rslt)
        for k,v in pairs(rslt) do
            loaded = loaded + 1
            creditCards[v.id] = v
        end
        Fox.trace("^2[BANK] ^7Loaded ^2"..loaded.." ^7credit cards !")
    end)
end

local function getCreditCard(_src)
    return Fox.players[_src].credit_card
end

local function getCardInfos(id)
    return creditCards[id]
end



RegisterNetEvent("fox:data:bankRqSelf")
AddEventHandler("fox:data:bankRqSelf", function()
    local _src = source
    local hasCard = getCreditCard(_src) ~= -1
    if hasCard then
        local cardInfos = getCardInfos(getCreditCard(_src))
        TriggerClientEvent("fox:data:bankRqCb", _src, cardInfos)
    else
        TriggerClientEvent("fox:data:bankRqCb", _src, nil)
    end
end)