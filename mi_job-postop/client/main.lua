-- variables
local isSpawned = false
local pedops = {
    {
        name = 'veh_create',
        icon = 'fa-solid fa-truck-fast',
        groups = Data.Group,
        label = 'Begin Route',
        canInteract = function(_, distance)
            return distance < 1.5 and not isSpawned
        end,
        onSelect = function()
            isSpawned = true
            local vehicle = lib.callback.await('mijob:create:vehicle', false, source)
            print(NetworkGetEntityFromNetworkId(vehicle)) Count, Tasks = SetCount()
            -- lib.callback.await('mijob:post:giveMailBag', false, source)
            TriggerEvent('mijob:post:selecttask')
        end
      },
      {
        name = 'veh_create',
        icon = 'fa-solid fa-check',
        groups = Data.Group,
        label = 'Finish Route',
        canInteract = function(_, distance)
            return distance < 1.5 and isSpawned and Count == 0
        end,
        onSelect = function()
            isSpawned = false
            local vehicle = lib.callback.await('mijob:delete:vehicle', false, source)
            --lib.callback.await('mijob:post:removeMailBag', false, source)
            TriggerEvent('mijob:post:Payout')
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

