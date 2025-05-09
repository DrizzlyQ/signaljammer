local QBCore = exports['qb-core']:GetCoreObject()
local ActiveJammers = {}
local HackCooldown = {}
local Webhook = "YOUR_DISCORD_WEBHOOK_URL"

-- Compatibility Layer
function HasJammerItem(Player)
    if GetResourceState('ox_inventory') == 'started' then
        print(source)       
        return (exports.ox_inventory:Search(source, "count", 'signal_jammer') or 0) > 0        
    else        
        return Player.Functions.GetItemByName('signal_jammer') ~= nil
    end
end

function RemoveJammerItem(Player)
    if GetResourceState('ox_inventory') == 'started' then
        exports.ox_inventory:RemoveItem(Player.source, 'signal_jammer', 1)
    else
        Player.Functions.RemoveItem(Player.source, 'signal_jammer', 1)
    end
end

-- ox_inventory item usage binding
exports('UseableItem', function(item, source)
    if item.name == 'signal_jammer' then
        print(('Player %s used signal_jammer'):format(source)) 
        TriggerClientEvent('drz-jammer:useJammer', source)
    end
end)

exports.qbx_core:CreateUseableItem('signal_jammer', function(source,item)
    TriggerClientEvent('drz-jammer:useJammer', source)
end)


QBCore.Commands.Add('disablejammers', 'Force disable all active jammers', {}, false, function(source)
    local Player = QBCore.Functions.GetPlayer(source)
    if not Player or Player.PlayerData.job.name ~= 'admin' then
        TriggerClientEvent('QBCore:Notify', source, 'You are not authorized to use this command.', 'error')
        return
    end
    for _, player in pairs(QBCore.Functions.GetPlayers()) do
        TriggerClientEvent('drz-jammer:forceDisable', tonumber(player))
    end
    print('[Jammer] All active jammers have been disabled by an admin.')
end)

RegisterServerEvent('drz-jammer:placeJammer', function(coords)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    if not HasJammerItem(Player) then
        DropPlayer(src, 'Exploit detected: Tried to place jammer without item.')
        return
    end
    RemoveJammerItem(Player)

    if not HackCooldown[src] then HackCooldown[src] = { last = 0, fails = 0 } end

    local now = os.time()
    if not success and now - HackCooldown[src].last < Config.HackCooldownSeconds then
        HackCooldown[src].fails = HackCooldown[src].fails + 1
        if HackCooldown[src].fails >= Config.MaxHackFails then
            DropPlayer(src, "Kicked: Too many failed jammer hacking attempts.")
            return
        end
    else
        HackCooldown[src].fails = 0
    end
    HackCooldown[src].last = now

    local jammerId = tostring(math.random(100000, 999999))

    ActiveJammers[jammerId] = {
        owner = src,
        coords = coords,
        battery = Config.BatteryLife,
        range = Config.JammerRange
    }

    TriggerClientEvent('drz-jammer:activateJammer', src, ActiveJammers[jammerId])
    TriggerClientEvent('drz-jammer:playNativeSound', -1, coords)

    local identifiers = GetPlayerIdentifiers(src)
    local steam, license = "N/A", "N/A"
    for _, id in pairs(identifiers) do
        if string.find(id, "steam:") then steam = id end
        if string.find(id, "license:") then license = id end
    end
    local embed = {{
        ["title"] = "📡 Signal Jammer Deployed",
        ["description"] = string.format("**User ID:** %s\n**Coords:** (%.2f, %.2f, %.2f)\n**Steam:** %s\n**License:** %s", src, coords.x, coords.y, coords.z, steam, license),
        ["color"] = 16711680
    }}
    PerformHttpRequest(Webhook, function() end, "POST", json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
end)

RegisterServerEvent('drz-jammer:logHackAttempt')
AddEventHandler('drz-jammer:logHackAttempt', function(success, targetSrc)
    local src = source
    local identifiers = GetPlayerIdentifiers(src)
    local steam, license = "N/A", "N/A"
    for _, id in pairs(identifiers) do
        if string.find(id, "steam:") then steam = id end
        if string.find(id, "license:") then license = id end
    end
    local outcome = success and "✅ Successful Hack" or "❌ Failed Hack"
    local targetInfo = targetSrc and ("Target User ID: " .. targetSrc) or "Unknown"
    local embed = {{
        ["title"] = "🧠 Jammer Hacking Attempt",
        ["description"] = string.format("**User ID:** %s\n**Steam:** %s\n**License:** %s\n**Result:** %s\n%s", src, steam, license, outcome, targetInfo),
        ["color"] = success and 65280 or 16753920
    }}
    PerformHttpRequest(Webhook, function() end, "POST", json.encode({embeds = embed}), {['Content-Type'] = 'application/json'})
end)

