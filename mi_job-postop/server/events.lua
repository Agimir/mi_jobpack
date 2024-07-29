-- variables
local vehicle, vehicleNet
local Inventory = exports.ox_inventory

local getNetId = function(ent)
    Citizen.Wait(100)
    local vNetId = NetworkGetEntityFromNetworkId(ent)
    if Debug then print(vNetId) end
    return vNetId
end

lib.callback.register('mijob:post:giveBoxes', function(source)
    Inventory:AddItem(source, Data.Items.ob1.item, 1)
end)

-- vehicle functions - livery - 5
lib.callback.register('mijob:create:vehicle', function(source)
    local player = Ox.GetPlayer(source)
    vehicle = Ox.CreateVehicle({
        model = Data.Vehicle.model, owner = player.charid,
        group = Data.Group
    }, Data.Vehicle.spawn, Data.Vehicle.spawn.w)
    -- load vehicle properties
    vehicleNet = getNetId(vehicle)
    if Debug then
        print(player.stateId, vehicle) print(vehicleNet)
    end
end)

lib.callback.register('mijob:delete:vehicle', function(source)
    local player = GetPlayerPed(source)
    local entity = GetVehiclePedIsIn(player, true)
    local group = Data.Group
    if entity == 0 and vehicle.group ~= group then
    print('vehicle not from '..group) return end
    if getNetId(vehicle) == vehicleNet and
    vehicle.group == group then
        vehicle.delete()
    end
    return true
end, false)