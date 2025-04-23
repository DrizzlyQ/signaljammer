local HackCooldown = {}
local QBCore = exports['qb-core']:GetCoreObject()
local ActiveJammers = {}
local Webhook = "YOUR_DISCORD_WEBHOOK_URL" -- Replace this with your webhook URL

RegisterServerEvent('drz-jammer:placeJammer', function(coords)
    local src = source
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

    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end

    local jammerId = tostring(math.random(100000, 999999))

    ActiveJammers[jammerId] = {
        owner = src,
        coords = coords,
        battery = Config.BatteryLife,
        range = Config.JammerRange
    }

    TriggerClientEvent('drz-jammer:activateJammer', src, ActiveJammers[jammerId])

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

RegisterServerEvent('drz-jammer:playNoise', function(coords)
    TriggerClientEvent('InteractSound_CL:PlayOnCoords', -1, coords, 'jammer_noise.ogg', 0.8)
end)
