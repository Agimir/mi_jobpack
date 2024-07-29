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
    --exports.ox_target:addLocalEntity(ped, workped)
end
LoadPed()

-- select task
local function pickRandomTask(obj_list)
    local keys = {}
    for key in pairs(obj_list) do
        table.insert(keys, key)
    end
    local random_key = keys[math.random(#keys)]
    return obj_list[random_key], random_key
end