local QBCore = exports['qb-core']:GetCoreObject()
local jammerData = nil
local jammerEntity = nil
local isJammerActive = false

RegisterNetEvent('drz-jammer:useJammer', function()
    TriggerEvent("bl_ui:open", {
        type = "pattern",
        time = 30,
        difficulty = "medium"
    }, function(success)
        if success then
            TriggerServerEvent('drz-jammer:logHackAttempt', true)
            local coords = GetEntityCoords(PlayerPedId())
            TriggerServerEvent('drz-jammer:placeJammer', coords)
        else
            TriggerServerEvent('drz-jammer:logHackAttempt', false)
            QBCore.Functions.Notify('Hacking failed...', 'error')
        end
    end)
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

    TriggerServerEvent('drz-jammer:playNoise', data.coords)

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
    TriggerServerEvent('InteractSound_CL:PlayOnCoords', -1, GetEntityCoords(PlayerPedId()), 'jammer_powerdown.ogg', 0.7)
    isJammerActive = false
    DeleteEntity(jammerEntity)
    jammerEntity = nil
    QBCore.Functions.Notify("The jammer's battery is dead.", 'error')
end)
