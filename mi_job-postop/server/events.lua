-- variables
local vehicle, vehicleNet
local Inventory = exports.ox_inventory

local getNetId = function(ent)
    Citizen.Wait(100)
    local vNetId = NetworkGetEntityFromNetworkId(ent)
    if Debug then print(vNetId) end
    return vNetId
end

lib.callback.register('mijob:post:giveMailBag', function(source)
    Inventory:AddItem(source, Data.Items.ob1.item, 1, Data.Items.ob1.meta )
end)

lib.callback.register('mijob:post:removeMailBag', function(source)
    Inventory:RemoveItem(source, Data.Items.ob1.item, 1, true)
end)

lib.callback.register('mijob:post:pay:stop', function(source)
    Inventory:AddItem(source, 'money', math.random(15, 45), true)
end)

lib.callback.register('mijob:post:pay:bonus', function(source)
    Inventory:AddItem(source, 'money', math.random(150, 250), true)
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