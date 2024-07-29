-- variables
local blip, zone

-- place object task


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

local remRoute = function()
    if blip ~= nil then
        RemoveBlip(blip)
    end
end

local function onEnter(self)
    if Debug then print('entered zone', self.id) end
    lib.showTextUI('[E] - Place Package')
    if IsControlJustReleased(0, 38) then
        lib.hideTextUI()
        print('placed')
    end
end
 
local function onExit(self)
    if Debug then print('exited zone', self.id) end
    lib.hideTextUI()
end

local setZone = function(task)
    zone = lib.zones.sphere({
        coords = task.point,
        radius = 4,
        debug = Debug,
        onEnter = onEnter,
        onExit = onExit,
    })

end

local remZone = function()
    
end

RegisterNetEvent('mijob:post:selecttask')
AddEventHandler('mijob:post:selecttask', function()
    local task = pickRandomTask(Data.Tasks)
    if Debug then
        print(task.label, task.point)
    end
    setRoute(task) setZone(task)
end)