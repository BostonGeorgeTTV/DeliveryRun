ESX = exports["es_extended"]:getSharedObject()

local inv = exports.ox_inventory

RegisterNetEvent("delivery_run:takeMaterials", function()
    if inv:CanCarryItem(source, Config.item, Config.takeItem) then
        inv:AddItem(source, Config.item, Config.takeItem)
    end
end)

RegisterNetEvent("delivery_run:delivery", function()
    inv:RemoveItem(source, Config.item, Config.quantity)
    inv:AddItem(source, Config.money, math.random(Config.reward.a,Config.reward.b))
end)

lib.callback.register('delivery_run:checkJobOnline', function(source, job)
    return #ESX.GetExtendedPlayers('job', job)
end)