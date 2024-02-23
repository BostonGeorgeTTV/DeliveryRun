Config = {}

Config.TextUiStyle = {
    position = "right-center",
    icon = 'bottle',
    style = {
        borderRadius = 3,
        backgroundColor = '#00ffa3',
        color = '#d1135c'
    }
}

Config.TexUiText = {
    startJob = "Inizia il giro",
    retrieve = "Ritira merce",
    delivery = "Consegna",
    garage = "Parcheggia"
}

Config.item = "alcool"
Config.takeItem = 20
Config.quantity = 2
Config.money = "black_money"
Config.reward = {
    a = 1500,
    b = 2000,
}

Config.Start = {
    npc = vec4(1128.0844, -1244.7784, 20.3854, 123.3442),
    coords = vec4(1125.9403, -1241.9818, 21.3667, 125.9600),
    van = vec4(1119.8115, -1246.3253, 20.6628, 211.5149),
}

Config.retrive = {
    coords = vec3(1125.8368, -1241.8497, 21.3666),
    AreaRaccolta = vec3(1126.0, -1242.0, 21.0),
    Areasize = vec3(1, 2, 4.0),
    AreaRotation = 35.0,
}

Config.Delivery = {
    {x = 1269.9193, y = -1906.9321, z = 39.4289, w = 8.2161, isBusy = false },
    {x = 1074.4139, y = -2450.9744, z = 29.1261, w = 91.2619, isBusy = false },
    {x = 936.2032, y = -1581.7865, z = 30.2804, w = 359.4714, isBusy = false }, 
    {x = 733.5592, y = -1308.3739, z = 26.3108, w = 88.9754, isBusy = false },
    {x = 1739.8434, y = -1592.0959, z = 112.5622, w = 9.4685, isBusy = false }, 
    {x = 1620.6417, y = -2258.9478, z = 106.6200, w = 0.4646, isBusy = false }, 
    {x = 1499.7920, y = -2519.1731, z = 55.7903, w = 190.2682, isBusy = false }, 
    {x = 1257.3140, y = -2570.9946, z = 42.7181, w = 326.8405, isBusy = false }, 
    {x = 862.8137, y = -2535.7241, z = 28.4467, w = 77.4653, isBusy = false }, 
    {x = 845.0851, y = -2267.6716, z = 30.5418, w = 258.8906, isBusy = false }, 
}

-- call police
Config.probCall = {
    a = 1,
    b = 5,
}

Config.alertProb = 3

-- Dispatch event
RegisterNetEvent("delivery_run:callPolice", function()
    local ped = PlayerPedId()
    local anyjob = lib.callback.await('delivery_run:checkJobOnline', false, 'police')
    if anyjob > 0 and ESX.PlayerData.job.name == "police" then
        -- this is an example with origen_police dispatch
        TriggerServerEvent("SendAlert:police", {
            coords = GetEntityCoords(ped), -- Coordinates vector3(x, y, z) in which the alert is triggered
            title = "Attività Sospetta", -- Title in the alert header
            type = "RADARS", -- Alert type (GENERAL, RADARS, 215, DRUGS, FORCE, 48X) This is to filter the alerts in the dashboard
            message = "Attività sospetta in corso, probabile contrabbando di alcolici.",
        })
    end
end)

-- translate
Config.translate = {
    ritiro = "Acquisendo informazioni . . .",
    consegna = "Consegna in corso . . .",
    postoVan = "Libera il parcheggio!",
    no_item = "Non hai nulla da consegnare!",
    already_delivered = "Hai gia fatto questa consegna!",
    nojob = "Passa prima dal fornitore!",
    alreadyLiquor = "Hai gia preso la merce!",
    retrieve = "Ritirando la merce . . .",
    knock = "Bussa alla porta qui a fianco per ritirare la merce da consegnare",
    start = "Inizia il giro di consegne!",
    parkingCar = "riconsegnando il veicolo e la merce avanzata . . ."
}