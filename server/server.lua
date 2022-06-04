printmsg = [[
    ______     ______     ______     ______   ______     ______     ______      ______     ______    
   /\  ___\   /\  __ \   /\  ___\   /\  == \ /\  ___\   /\  ___\   /\__  _\    /\  __ \   /\  ___\   
   \ \___  \  \ \  __ \  \ \___  \  \ \  _-/ \ \  __\   \ \ \____  \/_/\ \/    \ \  __ \  \ \ \____  
    \/\_____\  \ \_\ \_\  \/\_____\  \ \_\    \ \_____\  \ \_____\    \ \_\     \ \_\ \_\  \ \_____\ 
     \/_____/   \/_/\/_/   \/_____/   \/_/     \/_____/   \/_____/     \/_/      \/_/\/_/   \/_____/ 
                                                                                     
]]

print(printmsg)

function getPlayerIdentifiers(player)
    local playerName = GetPlayerName(player)
    local endpoint = GetPlayerEndpoint(player)
    local steam 
    local license
    for k, v in ipairs(GetPlayerIdentifiers(player)) do
        if string.match(v, "steam:") then
            steam = v
            break
        else 
            steam = 'Nill'
        end
    end
    for k, v in ipairs(GetPlayerIdentifiers(player)) do
        if string.match(v, "license:") then
            license = string.sub(v, 9)
            break
        end
    end
    return playerName, endpoint, steam, license
end


function isSpawningPeds(entity, pedOnly)
    local model = GetEntityModel(entity)
    if model ~= nil then
        if (GetEntityType(entity) == 1 and GetEntityPopulationType(entity) == 7) then
            for i=1, #Config.BlacklistedPeds do
                local PedHash = GetHashKey(Config.BlacklistedPeds[i])
                if model == PedHash then
                    if pedOnly then
                        return Config.BlacklistedPeds[i]
                    else
                        return true
                    end
                end
            end
        end       
    end
    return false
end

function isSpawningProps(entity, propOnly)
    local model = GetEntityModel(entity)
    if model ~= nil then
        for i=1, #Config.BlacklistedProps do
            local PropHash = tonumber(Config.BlacklistedProps[i]) ~= nil and tonumber(Config.BlacklistedProps[i]) or GetHashKey(Config.BlacklistedProps[i])
            if PropHash == model then
                if (GetEntityPopulationType(entity) ~= 7) then
                    if propOnly then
                        return Config.BlacklistedProps[i]
                    elseif not propOnly then
                        return true
                    end
                else
                    return false
                end
            end
        end
    end
    return false
end


function getDiscord(playerObj, removePrefix)
    local identifier
    local discord
    for k, v in ipairs(GetPlayerIdentifiers(playerObj)) do
        if string.match(v, "discord:") then
            identifier = v
            break
        end
    end
    if identifier ~= nil then
        if removePrefix then
            discord = string.sub(identifier, 9)
        else
            discord = identifier
        end
        return discord
    else
        return 'Nill'
    end
end

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    PerformHttpRequest(Config.WebhookAnticheat, function(err, text, headers) end, 'POST', json.encode({embeds={{title = "[sAsPeCt Anticheat] is started. You are safe!", footer = {text = "\nsAsPeCt ©"},  color=3066993}}}),  { ['Content-Type'] = 'application/json' })
end)


RegisterServerEvent('saspect-anticheat:blackweapon')
AddEventHandler("saspect-anticheat:blackweapon", function(weaponName, playerid, weaponhash, id)
    local isAllowed = IsPlayerAceAllowed(source, "sAsPeCt.Anticheat.Bypass")
    if not isAllowed then             
        local _source = source
        local playerName, ip, steamhex, license = getPlayerIdentifiers(source)
        local weaname = weaponName
        local playerID = playerid
        local discord = getDiscord(source, true)
        DropPlayer(source, "[sAsPeCt Anticheat] -  Blacklisted Weapon!")
        PerformHttpRequest(Config.WebhookAnticheat, function(err, text, headers) end, 'POST', json.encode({embeds={{title = "[sAsPeCt Anticheat]", description =  "***DETECTED: __Blacklisted Weapon__ [KICKED]*** \n> *Player Name*: " ..playerName.. "\n> *Weapon Name*: "..weaname.. "\n> *Player ID*: " ..playerID.."\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "\nsAsPeCt ©"}, color=1579051}}}),  { ['Content-Type'] = 'application/json' })
    end

end)

RegisterServerEvent('saspect-anticheat:blackveh')
AddEventHandler("saspect-anticheat:blackveh", function(vehName, playerid, veh)
    local isAllowed = IsPlayerAceAllowed(source, "sAsPeCt.Anticheat.Bypass")
    if not isAllowed then          
        TriggerClientEvent("saspect-anticheat:delveh", source, veh)
        local _source = source
        local playerName, ip, steamhex, license = getPlayerIdentifiers(source)
        local vehname = vehName
        local playerID = playerid
        local discord = getDiscord(source, true)
        DropPlayer(source, "[sAsPeCt Anticheat] - Blacklisted Vehicle!")
        PerformHttpRequest(Config.WebhookAnticheat, function(err, text, headers) end, 'POST', json.encode({embeds={{title = "[sAsPeCt Anticheat]", description =  "***DETECTED: __Blacklisted Vehicle__ [KICKED]*** \n> *Player Name*: " ..playerName.. "\n> *Vehicle Name*: "..vehname.. "\n> *Player ID*: " ..playerID.."\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "\nsAsPeCt ©"}, color=1579051}}}),  { ['Content-Type'] = 'application/json' })
    end
end)

AddEventHandler("explosionEvent", function(sender, ev)
    local BlockedExplosions = {1, 2, 4, 5, 7, 12, 25, 32, 33, 35, 36, 37, 38}
    local numsender = tonumber(sender)
    for _, v in ipairs(BlockedExplosions) do
        if  ev.explosionType == v and (numsender ~= nil and ev.damageScale ~= 0.0 and ev.ownerNetId == 0) then 
            local playerName, ip, steamhex, license = getPlayerIdentifiers(sender)
            local discord = getDiscord(sender, true)
            if Config.EnableSQLBan and  v ~= 7 then
                TriggerEvent("saspect-ac:bansql", "[sAsPeCt Anticheat] - Explosion", sender)
                PerformHttpRequest(Config.WebhookSOS, function(err, text, headers) end, 'POST', json.encode({embeds={{title =  "[sAsPeCt Anticheat]", description =  "***DETECTED: __EXPLOSION__ [BANNED]*** \n> *Player Name*: " ..playerName.. "\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "\nsAsPeCt ©"}, color=1}}}),  { ['Content-Type'] = 'application/json' })
            else
                DropPlayer(sender, "[sAsPeCt Anticheat] - Explosion Detected!")
                PerformHttpRequest(Config.WebhookSOS, function(err, text, headers) end, 'POST', json.encode({embeds={{title =  "[sAsPeCt Anticheat]", description =  "***DETECTED: __EXPLOSION__ [KICKED]*** \n> *Player Name*: " ..playerName.. "\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "\nsAsPeCt ©"}, color=1}}}),  { ['Content-Type'] = 'application/json' })
            end
        end
    end     
    CancelEvent()
end)

RegisterServerEvent('saspect-anticheat:godmode')
AddEventHandler("saspect-anticheat:godmode", function(playerId)
    local isAllowed = IsPlayerAceAllowed(source, "sAsPeCt.Anticheat.Bypass")
    if not isAllowed then
        local _source = source
        local discord = getDiscord(source, true)
        local playerName, ip, steamhex, license = getPlayerIdentifiers(source)
        local id = playerId
        PerformHttpRequest(Config.WebhookAnticheat, function(err, text, headers) end, 'POST', json.encode({embeds={{title = "[sAsPeCt Anticheat]", description =  "***DETECTED: __GODMODE__ [POSSIBLE CHEATER]*** \n> *Player Name*: " ..playerName.. "\n> *Player ID*: " ..id.."\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "© sAsPeCt"}, color=1579051}}}),  { ['Content-Type'] = 'application/json' })
    end
end)
if Config.BlacklistedNames then
    AddEventHandler("playerConnecting", function(playerName)
        local blacklistedNames = Config.BlacklistedNames
        for name in pairs(blacklistedNames) do
            if(string.gsub(string.gsub(string.gsub(string.gsub(playerName:lower(), "-", ""), ",", ""), "%.", ""), " ", ""):find(forbiddenNames[name])) then
                print(playerName .. " has been kicked!")
                local _, ip, steamhex, license = getPlayerIdentifiers(source)
                local discord = getDiscord(source, true)
                DropPlayer(source, '[sAsPeCt Anticheat] - Blacklisted Steam Name Detected!')
                PerformHttpRequest(Config.WebhookAnticheat, function(err, text, headers) end, 'POST', json.encode({embeds={{title = "[sAsPeCt Anticheat]", description =  "***DETECTED: __FORBIDDEN STEAM NAME__*** \n> *Player Name*: " ..playerName.. "\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "© sAsPeCt"}, color=1579051}}}),  { ['Content-Type'] = 'application/json' })
                CancelEvent()
                break
            end
        end
    end)
end

AddEventHandler("playerConnecting", function(playerName)
    local discordID = getDiscord(source, false)
    if discordID == 'Nill' then
        local _, ip, steamhex, license = getPlayerIdentifiers(source)
        PerformHttpRequest(Config.WebhookNoDiscord, function(err, text, headers) end, 'POST', json.encode({embeds={{title = "[sAsPeCt Anticheat]", description =  "***__NO DISCORD LINKED__*** \n> *Player Name*: " ..playerName.. "\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license, footer = {text = "© sAsPeCt.sh", color=65491}}}),  { ['Content-Type'] = 'application/json' })
    end
end)

local validResources
local function collectValidResources()
    validResources = {}
    for i=0,GetNumResources()-1 do
        validResources[GetResourceByFindIndex(i)] = true
    end
end
collectValidResources()
AddEventHandler("onResourceListRefresh", collectValidResources)
RegisterServerEvent("saspect-anticheat:clientresources")
AddEventHandler("saspect-anticheat:clientresources", function(givenResources)
    for _, resource in ipairs(givenResources) do
        if not validResources[resource] then
            local playerName, ip, steamhex, license = getPlayerIdentifiers(player)
            local discord = getDiscord(source, true)
            local resourceinj = resource
            if Config.EnableSQLBan then
                TriggerEvent("saspect-ac:bansql", "[sAsPeCt Anticheat] - LUA Injection", source)
                PerformHttpRequest(Config.WebhookSOS, function(err, text, headers) end, 'POST', json.encode({embeds={{title =  "[sAsPeCt Anticheat]", description =  "***DETECTED: __LUA INJECTION__ [BANNED]*** \n> *Player Name*: " ..playerName.. "\n> *Resource*: "..resourceinj.."\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "\nsAsPeCt ©"}, color=1}}}),  { ['Content-Type'] = 'application/json' })
            else
                DropPlayer(source, "[sAsPeCt Anticheat] - Injection Detected!")
                PerformHttpRequest(Config.WebhookSOS, function(err, text, headers) end, 'POST', json.encode({embeds={{title =  "[sAsPeCt Anticheat]", description =  "***DETECTED: __LUA INJECTION__ [KICKED]*** \n> *Player Name*: " ..playerName.. "\n> *Resource*: "..resourceinj.."\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "\nsAsPeCt ©"}, color=1}}}),  { ['Content-Type'] = 'application/json' })
            end
            break
        end
    end
end)

RegisterServerEvent('saspect-anticheat:commandlist')
AddEventHandler("saspect-anticheat:commandlist", function(givenList)
    local _source = source
    for _, command in ipairs(givenList) do
        if Config.BlacklistedCommands[command.name] then
            local playerName, ip, steamhex, license = getPlayerIdentifiers(_source)
            local discord = getDiscord(_source, true)
            local injcommand = Config.BlacklistedCommands[command.name]
            if Config.EnableSQLBan then
                TriggerEvent("saspect-ac:bansql", "[sAsPeCt Anticheat] - LUA Injection", _source)
                PerformHttpRequest(Config.WebhookSOS, function(err, text, headers) end, 'POST', json.encode({embeds={{title =  "[sAsPeCt Anticheat]", description =  "***DETECTED: __LUA INJECTION [Command]__ [BANNED]*** \n> *Player Name*: " ..playerName.. "\n> *Command*: "..injcommand.."\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "\nsAsPeCt ©"}, color=1579051}}}),  { ['Content-Type'] = 'application/json' })
            else
                DropPlayer(_source, "[sAsPeCt Anticheat] - Injection Detected!")
            end
			break
		end
	end
end)

RegisterServerEvent('saspect-anticheat:spectate')
AddEventHandler("saspect-anticheat:spectate", function()
    local isAllowed = IsPlayerAceAllowed(source, "sAsPeCt.Anticheat.Bypass")
    if not isAllowed then
        local playerName, ip, steamhex, license = getPlayerIdentifiers(source)
        local discord = getDiscord(source, true)
        DropPlayer(source, "[sAsPeCt Anticheat] - Spectate Detected!")
        PerformHttpRequest(Config.WebhookAnticheat, function(err, text, headers) end, 'POST', json.encode({embeds={{title =  "[sAsPeCt Anticheat]", description =  "***DETECTED: __SPECTATING__ [KICKED]*** \n> *Player Name*: " ..playerName.. "\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "\nsAsPeCt ©"}, color=1579051}}}),  { ['Content-Type'] = 'application/json' })
    end
end)

AddEventHandler("entityCreating",  function(entity)
    local isAllowed = IsPlayerAceAllowed(source, "sAsPeCt.Anticheat.Bypass")
    if not isAllowed then
        local _source = NetworkGetEntityOwner(entity)
        if (_source ~= nil and _source > 0) then
            if isSpawningPeds(entity, false) then
                local playerName, ip, steamhex, license = getPlayerIdentifiers(_source)
                local discord = getDiscord(_source, true)
                local pedName = isSpawningPeds(entity, true)
                DeleteEntity(entity)
                if Config.EnableSQLBan then
                    TriggerEvent("saspect-ac:bansql", "[sAsPeCt Anticheat] - Spawning Peds!", _source)
                    PerformHttpRequest(Config.WebhookSOS, function(err, text, headers) end, 'POST', json.encode({embeds={{title =  "[sAsPeCt Anticheat]", description =  "***DETECTED: __PED SPAWNING__ [BANNED]*** \n> *Player Name*: " ..playerName.. "\n> *Ped Name*: "..pedName.."\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "\nsAsPeCt ©"}, color=1}}}),  { ['Content-Type'] = 'application/json' })
                else
                    DropPlayer(_source, "[sAsPeCt Anticheat] - Spawning Peds Detected!")
                    PerformHttpRequest(Config.WebhookSOS, function(err, text, headers) end, 'POST', json.encode({embeds={{title =  "[sAsPeCt Anticheat]", description =  "***DETECTED: __PED SPAWNING__ [KICKED]*** \n> *Player Name*: " ..playerName.. "\n> *Ped Name*: "..pedName.."\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "\nsAsPeCt ©"}, color=1}}}),  { ['Content-Type'] = 'application/json' })
                end
            elseif isSpawningProps(entity, false) then
                local prop = isSpawningProps(entity, true)
                local playerName, ip, steamhex, license = getPlayerIdentifiers(_source)
                local discord = getDiscord(_source, true)
                DeleteEntity(entity)
                if Config.EnableSQLBan then
                    TriggerEvent("saspect-ac:bansql", "[sAsPeCt Anticheat] - Spawning Props", _source)
                    PerformHttpRequest(Config.WebhookSOS, function(err, text, headers) end, 'POST', json.encode({embeds={{title =  "[sAsPeCt Anticheat]", description =  "***DETECTED: __PROP SPAWNING__ [BANNED]*** \n> *Player Name*: " ..playerName.. "\n> *Prop Name*: "..prop.."\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "\nsAsPeCt ©"}, color=1}}}),  { ['Content-Type'] = 'application/json' })
                else
                    DropPlayer(_source, "[sAsPeCt Anticheat] - Spawning Props Detected!")
                    PerformHttpRequest(Config.WebhookSOS, function(err, text, headers) end, 'POST', json.encode({embeds={{title =  "[sAsPeCt Anticheat]", description =  "***DETECTED: __PROP SPAWNING__ [KICKED]*** \n> *Player Name*: " ..playerName.. "\n> *Prop Name*: "..prop.."\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "\nsAsPeCt ©"}, color=1}}}),  { ['Content-Type'] = 'application/json' })
                end
            end
        end
    end
end)


for i=1, #Config.BlacklistedEvents do
    local event = Config.BlacklistedEvents[i]
    AddEventHandler(event, function()
        CancelEvent()
        local playerName, ip, steamhex, license = getPlayerIdentifiers(source)
        local discordID = getDiscord(source, true)
        if Config.EnableSQLBan then
            TriggerEvent("saspect-ac:bansql", "[sAsPeCt Anticheat] - Triggered Blacklisted Event!", source)
            PerformHttpRequest(Config.WebhookAnticheat, function(err, text, headers) end, 'POST', json.encode({embeds={{title =  "[sAsPeCt Anticheat]", description =  "***DETECTED: __TRIGGERED EVENT__ [BANNED]*** \n> *Player Name*: " ..playerName.. "\n> *Event Name*: "..event.."\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "\nsAsPeCt ©"}, color=1579051}}}),  { ['Content-Type'] = 'application/json' })
        else
            DropPlayer(source, '[sAsPeCt-Anticheat] - Triggered Blacklisted Event!')
            PerformHttpRequest(Config.WebhookAnticheat, function(err, text, headers) end, 'POST', json.encode({embeds={{title =  "[sAsPeCt Anticheat]", description =  "***DETECTED: __TRIGGERED EVENT__ [KICKED]*** \n> *Player Name*: " ..playerName.. "\n> *Event Name*: "..event.."\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "\nsAsPeCt ©"}, color=1579051}}}),  { ['Content-Type'] = 'application/json' })
        end
    end)

end


RegisterServerEvent('saspect-anticheat:luainjection')
AddEventHandler("saspect-anticheat:luainjection", function(modmenu)
    local isAllowed = IsPlayerAceAllowed(source, "sAsPeCt.Anticheat.Bypass")
    if not isAllowed then
        local playerName, ip, steamhex, license = getPlayerIdentifiers(source)
        local discord = getDiscord(source, true)
        if Config.EnableSQLBan then
            TriggerEvent("saspect-ac:bansql", "[sAsPeCt Anticheat] - LUA Injection!", source)
            PerformHttpRequest(Config.WebhookSOS, function(err, text, headers) end, 'POST', json.encode({embeds={{title =  "[sAsPeCt Anticheat]", description =  "***DETECTED: __LUA INJECTION [Variable]__ [BANNED]*** \n> *Player Name*: " ..playerName.. "\n> *Variable Name*: "..modmenu.."\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "\nsAsPeCt ©"}, color=1}}}),  { ['Content-Type'] = 'application/json' })
        else
            DropPlayer(source, "[sAsPeCt Anticheat] - LUA Injection!")
            PerformHttpRequest(Config.WebhookSOS, function(err, text, headers) end, 'POST', json.encode({embeds={{title =  "[sAsPeCt Anticheat]", description =  "***DETECTED: __LUA INJECTION [Variable]__ [KICKED]*** \n> *Player Name*: " ..playerName.. "\n> *Variable Name*: "..modmenu.."\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "\nsAsPeCt ©"}, color=1}}}),  { ['Content-Type'] = 'application/json' })
        end
    end
end)

AddEventHandler("clearPedTasksEvent", function(sender, data)
    if Config.AntiCarKick then 
        CancelEvent()
        local isAllowed = IsPlayerAceAllowed(sender, "sAsPeCt.Anticheat.Bypass")
        if not isAllowed then
            local playerName, ip, steamhex, license = getPlayerIdentifiers(sender)
            local discord = getDiscord(sender, true)
            PerformHttpRequest(Config.WebhookAnticheat, function(err, text, headers) end, 'POST', json.encode({embeds={{title =  "[sAsPeCt Anticheat]", description =  "***DETECTED: __CAR KICK__ [Possible Cheater]*** \n> *Player Name*: " ..playerName.. "\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "\nsAsPeCt ©"}, color=1579051}}}),  { ['Content-Type'] = 'application/json' })
        end
    end 
end)

AddEventHandler('removeWeaponEvent', function(sender, data)
    if Config.AntiRemovePlayersWeapons then 
        CancelEvent()
        local isAllowed = IsPlayerAceAllowed(sender, "sAsPeCt.Anticheat.Bypass")
        if not isAllowed then
            local playerName, ip, steamhex, license = getPlayerIdentifiers(sender)
            local discord = getDiscord(sender, true)
            PerformHttpRequest(Config.WebhookAnticheat, function(err, text, headers) end, 'POST', json.encode({embeds={{title =  "[sAsPeCt Anticheat]", description =  "***DETECTED: __REMOVE ALL WEAPONS__ [Possible Cheater]*** \n> *Player Name*: " ..playerName.. "\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "\nsAsPeCt ©"}, color=1579051}}}),  { ['Content-Type'] = 'application/json' })
        end
    end 
    -- Would only affect if you have scripts removing other people's weapons. (stops players removing other players weapons)
end)

AddEventHandler('giveWeaponEvent', function(sender, data)
    if Config.AntiGivePlayersWeapons then 
        CancelEvent()
        local isAllowed = IsPlayerAceAllowed(sender, "sAsPeCt.Anticheat.Bypass")
        if not isAllowed then
            local playerName, ip, steamhex, license = getPlayerIdentifiers(sender)
            local discord = getDiscord(sender, true)
            PerformHttpRequest(Config.WebhookAnticheat, function(err, text, headers) end, 'POST', json.encode({embeds={{title =  "[sAsPeCt Anticheat]", description =  "***DETECTED: __GIVE ALL WEAPONS__ [Possible Cheater]*** \n> *Player Name*: " ..playerName.. "\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "\nsAsPeCt ©"}, color=1579051}}}),  { ['Content-Type'] = 'application/json' })
        end
    end 
    -- Stops other players giving people weapons (doesn't affect single people unless you have give weapons on menus and etc.)
end)

RegisterServerEvent('saspect-anticheat:expoweapon')
AddEventHandler('saspect-anticheat:expoweapon', function(playerId, WeaponHash, isMelee)
    local isAllowed = IsPlayerAceAllowed(source, "sAsPeCt.Anticheat.Bypass")
    if not isAllowed then
        local _source = source
        local discord = getDiscord(source, true)
        local playerName, ip, steamhex, license = getPlayerIdentifiers(source)
        local id = playerId
        if isMelee then
            PerformHttpRequest(Config.WebhookAnticheat, function(err, text, headers) end, 'POST', json.encode({embeds={{title = "[sAsPeCt Anticheat]", description =  "***DETECTED: __EXPLOSIVE MELEE__ [KICKED]*** \n> *Player Name*: " ..playerName.. "\n> *Player ID*: " ..id.."\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "\nsAsPeCt ©"}, color=1579051}}}),  { ['Content-Type'] = 'application/json' })
        else
            PerformHttpRequest(Config.WebhookAnticheat, function(err, text, headers) end, 'POST', json.encode({embeds={{title = "[sAsPeCt Anticheat]", description =  "***DETECTED: __EXPLOSIVE WEAPON__ [KICKED]*** \n> *Player Name*: " ..playerName.. "\n> *Player ID*: " ..id.. "\n> *Weapon Hash*: "..WeaponHash.."\n> *Player IP*: " ..ip.. "\n> *Steam Hex*: "..steamhex.. "\n> *License*: "..license.. "\n> *Discord*: <@"..discord..">", footer = {text = "\nsAsPeCt ©"}, color=1579051}}}),  { ['Content-Type'] = 'application/json' })
        end
        DropPlayer(source, "[sAsPeCt Anticheat] - Explosive Weapon Detected!")
    end
end)