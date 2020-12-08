

local function hasAccount(_src,license)
    MySQL.Async.fetchAll('SELECT * FROM users WHERE license = @a', {['a'] = license}, function(result)
        TriggerClientEvent("fox:creator:callback", _src, result[1])
        if result[1] then
            Fox.players[_src] = result[1]
            Citizen.SetTimeout(1500, function() Fox.trace("^1[PLAYERS] ^7"..GetPlayerName(_src).." authenticated, license is ^2"..Fox.players[_src].license.."^7") end)
        end
    end)
end

RegisterNetEvent("fox:creator:check")
AddEventHandler("fox:creator:check", function()
    local _src = source
    local license = getLicense(_src)
   hasAccount(_src,license)
    
end)

RegisterNetEvent("fox:creator:create")
AddEventHandler("fox:creator:create", function(skin,identity,cPosition)
    local _src = source
    local cLicense = getLicense(_src)
    local cTenues = {["base"] = skin}
    local date = os.date("*t", os.time()).day.."/"..os.date("*t", os.time()).month.."/"..os.date("*t", os.time()).year.." à "..os.date("*t", os.time()).hour.."h"..os.date("*t", os.time()).min
    MySQL.Async.execute('INSERT INTO users (license,name,rank,accounts,createdAt,characterInfos,tenues,selectedTenue,position) VALUES (@a,@b,@c,@i,@d,@e,@f,@g,@h)',

    { 
        ['a'] = cLicense ,
        ['b'] = GetPlayerName(_src),
        ['c'] = 1,
        ['d'] = date,
        ['e'] = json.encode(identity),
        ['f'] = json.encode(cTenues),
        ['g'] = "base",
        ['h'] = json.encode(cPosition),
        ['i'] = json.encode({["bank"] = 0, ["cash"] = 0, ["black"] = 0})
    },
    function(affectedRows)
        Fox.players[_src] = {
            license = cLicense,
            name = GetPlayerName(_src),
            rank = 1,
            accounts = json.encode({["bank"] = 0, ["cash"] = 0, ["black"] = 0}),
            characterInfos = identity,
            tenues = cTenues,
            selectedTenue = "base",
            position = cPosition
        }
        Fox.trace("^1[PLAYERS] ^7"..GetPlayerName(_src).." new player created account, license is ^2"..Fox.players[_src].license.."^7")
    end)
end)

RegisterNetEvent("fox:sync:savePos")
AddEventHandler("fox:sync:savePos", function(pos)
    local _src = source
    local license = getLicense(_src)
    local date = os.date("*t", os.time()).day.."/"..os.date("*t", os.time()).month.."/"..os.date("*t", os.time()).year.." à "..os.date("*t", os.time()).hour.."h"..os.date("*t", os.time()).min

    MySQL.Async.execute('UPDATE users SET position = @a, lastPositionSaved = @b WHERE license = @c',

    { 
        ['a'] = json.encode(pos) ,
        ['b'] = date,
        ['c'] = license
    },
    function(affectedRows)
        
    end)

end)

