local QBCore = exports['qb-core']:GetCoreObject()
local jammerData = nil
local jammerEntity = nil
local isJammerActive = false
local jammerZone = nil

RegisterNetEvent('drz-jammer:playNativeSound', function(coords)
    local soundId = GetSoundId()
    PlaySoundFromCoord(soundId, 'Crackle', coords.x, coords.y, coords.z, 'DLC_HEISTS_BIOLAB_FINALE_SOUNDS', false, 0, false)
end)

-- Force disable from admin
RegisterNetEvent('drz-jammer:forceDisable', function()
    if isJammerActive then
        isJammerActive = false
        if jammerEntity then
            DeleteEntity(jammerEntity)
            jammerEntity = nil
        end
        if jammerZone then
            jammerZone:remove()
            jammerZone = nil
        end
        QBCore.Functions.Notify('All signal jammers were disabled by an admin.', 'error')
    end
end)

RegisterNetEvent('drz-jammer:useJammer', function()
    local success = exports.bl_ui:LightsOut(3, {
        level = 2,
        duration = 5000
    })

    if success then
        TriggerServerEvent('drz-jammer:logHackAttempt', true)
        local coords = GetEntityCoords(PlayerPedId())
        TriggerServerEvent('drz-jammer:placeJammer', coords)
    else
        TriggerServerEvent('drz-jammer:logHackAttempt', false)
        QBCore.Functions.Notify('Hacking failed...', 'error')
    end
end)

RegisterNetEvent('drz-jammer:activateJammer', function(data)
    if isJammerActive then return end

    jammerData = data
    isJammerActive = true

    local model = `prop_toolchest_05`
    RequestModel(model)
    while not HasModelLoaded(model) do Wait(10) end
    jammerEntity = CreateObject(model, data.coords.x, data.coords.y, data.coords.z - 1.0, false, true, true)
    PlaceObjectOnGroundProperly(jammerEntity)
    SetEntityAsMissionEntity(jammerEntity, true, true)

    jammerZone = lib.zones.sphere({
        coords = jammerData.coords,
        radius = jammerData.range,
        inside = function()
            if exports["lb-phone"]:IsPhoneOpen() then
                TriggerEvent("lb-phone:forceClose")
            end
            NetworkSetTalkerProximity(1.0)
        end,
        onExit = function()
            NetworkSetTalkerProximity(15.0)
        end,
        debug = false
    })

    Wait(jammerData.battery * 60000)
    PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', true)
    isJammerActive = false
    DeleteEntity(jammerEntity)
    jammerEntity = nil
    if jammerZone then
        jammerZone:remove()
        jammerZone = nil
    end
    QBCore.Functions.Notify("The jammer's battery is dead.", 'error')
end)
