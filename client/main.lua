local Skillbar = {}
Skillbar.Data = {}
Skillbar.Data = {
    Active = false,
    Data = {},
}
local result = nil

RegisterNUICallback('Check', function(data, cb)
    Skillbar.Data.Active = false
    TriggerEvent('progressbar:client:ToggleBusyness', false)
    SendNUIMessage({
        action = "stop"
    })
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    result = data.success
end)

function StartSkillbar(duration, pos, width, callback)
    if not Skillbar.Data.Active then
        result = nil
        Skillbar.Data.Active = true

        Skillbar.Data.Data = {duration = duration, pos = pos, width = width}

        SendNUIMessage({
            action = "start",
            duration = duration,
            pos = pos,
            width = width,
        })
        SetNuiFocus(true, false)
        SetNuiFocusKeepInput(true)
        TriggerEvent('progressbar:client:ToggleBusyness', true)

        while Skillbar.Data.Active do
            Citizen.Wait(100)
        end
        Citizen.Wait(100)
        return result
    else
        QBCore.Functions.Notify('Your already doing something..', 'error')
    end
end