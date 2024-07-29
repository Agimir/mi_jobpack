-- variables
local blip, zone
Count = 0

-- place object task
local placeObject = function()
    if Debug then print('task completed') end
end

-- select task
local function pickRandomTask(obj_list)
    local keys = {}
    for key in pairs(obj_list) do
        table.insert(keys, key)
    end
    local random_key = keys[math.random(#keys)]
    return obj_list[random_key], random_key
end

-- set route
local setRoute = function(task)
    blip = AddBlipForCoord(task.point.x, task.point.y, task.point.z)
    SetBlipSprite(blip, 162) SetBlipDisplay(blip, 4) SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 0) SetBlipAsShortRange(blip, true) BeginTextCommandSetBlipName("STRING")
    SetBlipRoute(blip, true) SetBlipRouteColour(blip, 0)
    AddTextComponentString('Location: '..task.label) EndTextCommandSetBlipName(blip)
end

-- removes route
local remRoute = function()
    if blip ~= nil then
        RemoveBlip(blip)
    end
end

-- sets number of tasks
SetCount = function()
    local int = math.random(1,3)
    return int
end

-- checks count check
local checkcount = function()
    if Count <= 0 then
        TriggerEvent('mijob:post:endjob') print('Tasks: '..Count)
    elseif Count > 0 then
        TriggerEvent('mijob:post:selecttask') print('Tasks: '..Count)
    end
end

-- load dropoff location
local setDropoff = function(task)
    zone = exports.ox_target:addBoxZone({
        coords = task.point,
        size = vec3(1.0, 1.0, 2.25),
        rotation = task.point.w,
        debug = Debug,
        options = {
            name = 'del_mail',
            icon = 'fa-solid fa-envelope',
            groups = Data.Group,
            label = 'Deliver Mail',
            canInteract = function(_, distance)
                return distance < 1.5
            end,
            onSelect = function()
                if Debug then print('mail delivered') end
                exports.ox_target:removeZone(zone) remRoute()
                lib.callback.await('mijob:post:pay:stop', false, source)
                Count -= 1 checkcount()
            end
        }
    })
end

-- starts tasking
RegisterNetEvent('mijob:post:selecttask')
AddEventHandler('mijob:post:selecttask', function()
    local task = pickRandomTask(Data.Tasks)
    if Debug then
        print(task.label, task.point)
    end
    setRoute(task) setDropoff(task)
end)

RegisterNetEvent('mijob:post:endjob')
AddEventHandler('mijob:post:endjob', function()
    blip = AddBlipForCoord(Data.Location.x, Data.Location.y, Data.Location.z)
    SetBlipSprite(blip, 162) SetBlipDisplay(blip, 4) SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 0) SetBlipAsShortRange(blip, true) BeginTextCommandSetBlipName("STRING")
    SetBlipRoute(blip, true) SetBlipRouteColour(blip, 0)
    AddTextComponentString('Job Turn In') EndTextCommandSetBlipName(blip)
end)

RegisterNetEvent('mijob:post:Payout')
AddEventHandler('mijob:post:Payout', function()
    remRoute() lib.callback.await('mijob:post:pay:bonus', false, source)
end)