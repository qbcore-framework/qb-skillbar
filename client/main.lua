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
    result = data.success
end)

function TriggerCheck()
    Citizen.CreateThread(function()
        while Skillbar.Data.Active do
            if IsControlJustPressed(0, 38) then
                SendNUIMessage({
                    action = "check",
                    data = Skillbar.Data.Data,
                })
            end
            Citizen.Wait(1)
        end
    end)
end

function StartSkillbar(duration, pos, width, callback)
    if not Skillbar.Data.Active then
        result = nil
        Skillbar.Data.Active = true

        Skillbar.Data.Data = {duration = duration, pos = pos, width = width}

        TriggerCheck()

        SendNUIMessage({
            action = "start",
            duration = duration,
            pos = pos,
            width = width,
        })
        TriggerEvent('progressbar:client:ToggleBusyness', true)

        while Skillbar.Data.Active do
            Citizen.Wait(5)
        end
        Citizen.Wait(100)
        return result
    else
        QBCore.Functions.Notify('Your already doing something..', 'error')
    end
end