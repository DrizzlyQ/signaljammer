local QBCore = exports['qb-core']:GetCoreObject()
local jammerData = nil
local jammerEntity = nil
local isJammerActive = false

RegisterNetEvent('drz-jammer:playNativeSound', function(coords)
    local soundId = GetSoundId()
    PlaySoundFromCoord(soundId, 'Crackle', coords.x, coords.y, coords.z, 'DLC_HEISTS_BIOLAB_FINALE_SOUNDS', false, 0, false)
end)

RegisterNetEvent('drz-jammer:forceDisable', function()
    if isJammerActive then
        isJammerActive = false
        if jammerEntity then
            DeleteEntity(jammerEntity)
            jammerEntity = nil
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

    CreateThread(function()
        while isJammerActive do
            local myCoords = GetEntityCoords(PlayerPedId())
            local dist = #(myCoords - jammerData.coords)
            if dist < jammerData.range then
                if exports["lb-phone"]:IsPhoneOpen() then
                    TriggerEvent("lb-phone:forceClose")
                end
                NetworkSetTalkerProximity(1.0)
            else
                NetworkSetTalkerProximity(15.0)
            end
            Wait(1000)
        end
    end)

    Wait(jammerData.battery * 60000)
    PlaySoundFrontend(-1, 'ERROR', 'HUD_AMMO_SHOP_SOUNDSET', true)
    isJammerActive = false
    DeleteEntity(jammerEntity)
    jammerEntity = nil
    QBCore.Functions.Notify("The jammer's battery is dead.", 'error')
end)
