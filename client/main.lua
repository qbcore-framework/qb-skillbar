local QBCore = exports['qb-core']:GetCoreObject()

Skillbar = {}
Skillbar.Data = {}
Skillbar.Data = {
    Active = false,
    Data = {},
    Completed = 0,
}
successCb = nil
failCb = nil

-- NUI Callback's

RegisterNUICallback('Check', function(data, cb)
    if successCb ~= nil then
        Skillbar.Data.Active = false
        TriggerEvent('progressbar:client:ToggleBusyness', false)
        if data.success then
            Skillbar.Data.Completed = Skillbar.Data.Completed + 1
            if Skillbar.Data.Completed >= Skillbar.Data.Data.amount then
                Skillbar.Data.Completed = 0
                successCb()
            else
                Skillbar.Repeat(Skillbar.Data.Data)
            end
        else
            failCb()
            SendNUIMessage({
                action = "stop"
            })
        end
    end
    cb("ok")
end)

Skillbar.Start = function(data, success, fail)
    if not Skillbar.Data.Active then
        BarLoop()
        if success ~= nil then
            successCb = success
        end
        if fail ~= nil then
            failCb = fail
        end
        Skillbar.Data.Data = data
        Skillbar.Data.Data.amount = data.amount or 1 -- Set a default value of 1 if 'amount' is not provided
        Skillbar.Data.Completed = 0

        SendNUIMessage({
            action = "start",
            duration = data.duration,
            pos = data.pos,
            width = data.width,
        })
        TriggerEvent('progressbar:client:ToggleBusyness', true)
    else
        QBCore.Functions.Notify('You are already doing something..', 'error')
    end
end

Skillbar.Repeat = function(data)
    BarLoop()
    Skillbar.Data.Data = data
    CreateThread(function()
        Wait(500)
        SendNUIMessage({
            action = "start",
            duration = Skillbar.Data.Data.duration,
            pos = Skillbar.Data.Data.pos,
            width = Skillbar.Data.Data.width,
        })
    end)
end

function BarLoop()
    if not Skillbar.Data.Active then
        Skillbar.Data.Active = true
        CreateThread(function()
            while Skillbar.Data.Active do
                if IsControlJustPressed(0, 38) then
                    SendNUIMessage({
                        action = "check",
                        data = Skillbar.Data.Data,
                    })
                    break
                end
                Wait(1)
            end
        end)
    end
end

function GetSkillbarObject()
    return Skillbar
end

exports("GetSkillbarObject", GetSkillbarObject)
