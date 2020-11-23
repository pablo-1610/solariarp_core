local function getLicense(source)
	local steamid  = false
    local license  = false
    local discord  = false
    local xbl      = false
    local liveid   = false
    local ip       = false

	for k,v in pairs(GetPlayerIdentifiers(source))do
			
		if string.sub(v, 1, string.len("steam:")) == "steam:" then
			steamid = v
		elseif string.sub(v, 1, string.len("license:")) == "license:" then
			license = v
		elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
			xbl  = v
		elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
			ip = v
		elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
			discord = v
		elseif string.sub(v, 1, string.len("live:")) == "live:" then
			liveid = v
		end
	end

	return license:gsub("license:","")
end

local function hasAccount(_src,license)
    MySQL.Async.fetchAll('SELECT * FROM users WHERE license = @a', {['a'] = license}, function(result)
        TriggerClientEvent("fox:creator:callback", _src, result[1])
    end)
end

RegisterNetEvent("fox:creator:check")
AddEventHandler("fox:creator:check", function()
    local _src = source
    local license = getLicense(_src)
   hasAccount(_src,license)
    
end)

RegisterNetEvent("fox:creator:create")
AddEventHandler("fox:creator:create", function(skin,identity,position)
    local _src = source
    local license = getLicense(_src)
    local tenues = {["base"] = skin}
    local date = os.date("*t", os.time()).day.."/"..os.date("*t", os.time()).month.."/"..os.date("*t", os.time()).year.." à "..os.date("*t", os.time()).hour.."h"..os.date("*t", os.time()).min
    MySQL.Async.execute('INSERT INTO users (license,name,rank,accounts,createdAt,characterInfos,tenues,selectedTenue,position) VALUES (@a,@b,@c,@i,@d,@e,@f,@g,@h)',

    { 
        ['a'] = license ,
        ['b'] = GetPlayerName(_src),
        ['c'] = 1,
        ['d'] = date,
        ['e'] = json.encode(identity),
        ['f'] = json.encode(tenues),
        ['g'] = "base",
        ['h'] = json.encode(position),
        ['i'] = json.encode({["bank"] = 0, ["cash"] = 0, ["black"] = 0})
    },
    function(affectedRows)
        
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

