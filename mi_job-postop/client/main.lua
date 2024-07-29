-- variables
local isSpawned = false
local pedops = {
    {
        name = 'veh_create',
        icon = 'fa-solid fa-car',
        groups = Data.Group,
        label = 'Request work vehicle',
        canInteract = function(_, distance)
            return distance < 1.5 and not isSpawned
        end,
        onSelect = function()
            isSpawned = true
            local vehicle = lib.callback.await('mijob:create:vehicle', false, source)
            print(NetworkGetEntityFromNetworkId(vehicle))
            lib.callback.await('mijob:post:giveBoxes', false, source)
            TriggerEvent('mijob:post:selecttask')
        end
      },
}

--  load blip
function LoadBlips()
    local data, loc = Data.Blip, Data.Location
    local blip = AddBlipForCoord(loc.x, loc.y, 0)
    SetBlipSprite(blip, data.spr) SetBlipDisplay(blip, 4)
    SetBlipScale(blip, data.scl) SetBlipColour(blip, data.clr)
    SetBlipAsShortRange(blip, true) BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(data.lbl) EndTextCommandSetBlipName(blip)
end
LoadBlips()

-- load ped
local ped = { obj = nil, spawned = false}
function LoadPed()
    local model, crd = lib.requestModel(Data.Ped.model), Data.Location
    ped.obj = CreatePed(1, model, crd.x, crd.y, crd.z-1, crd.w, true, false)
    TaskStartScenarioInPlace(ped.obj, Data.Ped.scenario, 0, true)
    FreezeEntityPosition(ped.obj, true)
    SetBlockingOfNonTemporaryEvents(ped.obj, true)
    SetEntityInvincible(ped.obj, true)
    exports.ox_target:addLocalEntity(ped.obj, pedops)
end
LoadPed()

--[[ working on vehicle properties
    RegisterNetEvent('mijob:post:setVehProperties')
    AddEventHandler('mijob:post:setVehProperties', function(ent, data)
        if not DoesEntityExist(ent) then print('no vehicle')
        else
            lib.setVehicleProperties(NetToVeh(ent), data)
        end
    end)
]]

RegisterCommand('postop', function()
    lib.callback.await('mijob:create:vehicle', false, source)
end, false)

RegisterCommand('postopveh', function()
    lib.callback.await('mijob:delete:vehicle', false, source)
end, false)

RegisterCommand('postoptest', function()
    TriggerEvent('mijob:post:selecttask')
end, false)