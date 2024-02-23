ESX = exports["es_extended"]:getSharedObject()

local inv = exports.ox_inventory

local insideZone, startMission, takeLiquor, zoneStart, zoneRetrive, zoneDelivery, endZone = false, false, false, nil, nil, nil, nil
isBusy = {false, false, false, false, false, false, false, false, false, false}

local ped = PlayerPedId()

--functions
local loading = function() 
    lib.progressBar({
        duration = 10000,
        label = Config.translate.ritiro,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
            mouse = false
        },
        anim = {
            dict = 'missheistdockssetup1clipboard@base',
            clip = 'base' 
        },
        prop = {
            {
                model = `prop_notepad_01`,
                bone = 18905,
                pos = vec3(0.1, 0.02, 0.05),
                rot = vec3(10.0, 0.0, 0.0)
            },
            {
                model = `prop_pencil_01`,
                bone = 58866,
                pos = vec3(0.11, -0.02, 0.001),
                rot = vec3(-120.0, 0.0, 0.0)
            }
        },
    })
end

local loading2 = function() 
    lib.progressBar({
        duration = 5000,
        label = Config.translate.parkingCar,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
            mouse = false
        },
        anim = {
            dict = 'missheistdockssetup1clipboard@base',
            clip = 'base' 
        },
        prop = {
            {
                model = `prop_notepad_01`,
                bone = 18905,
                pos = vec3(0.1, 0.02, 0.05),
                rot = vec3(10.0, 0.0, 0.0)
            },
            {
                model = `prop_pencil_01`,
                bone = 58866,
                pos = vec3(0.11, -0.02, 0.001),
                rot = vec3(-120.0, 0.0, 0.0)
            }
        },
    })
end

local delivery = function() 
    lib.progressBar({
        duration = 1500,
        label = Config.translate.consegna,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = {
            move = true,
            car = true,
            combat = true,
            mouse = false
        },
        anim = {
            dict = 'mp_common',
            clip = 'givetake1_a' 
        },
        prop = {
            {
                model = `prop_whiskey_bottle`,
                bone = 57005,
                pos = vec3(0.13, 0.02, -0.06),
                rot = vec3(0.0, 00.0, 0.0)
            },
        },
    })
end

-- NPC Start
Citizen.CreateThread(function()
    for k,v in pairs(Config.Start) do
        local zoneStart = lib.zones.sphere({
			coords = vec3(Config.Start.npc.x, Config.Start.npc.y, Config.Start.npc.z),
			radius = 2.0,
			onEnter = function()
				if not IsPedInAnyVehicle(ped, false) and not startMission then
					lib.showTextUI('[E] - ' .. Config.TexUiText.startJob, Config.TextUiStyle)
                elseif not IsPedInAnyVehicle(ped, false) and startMission == true then
                    lib.showTextUI('[E] - ' .. Config.TexUiText.garage, Config.TextUiStyle)
				end
			end,
			inside = function()
				DisableControlAction(0, 24, true)
				DisableControlAction(0, 25, true)
				if not IsPedInAnyVehicle(ped, false) and IsControlJustPressed(0, 51) then
					if not insideZone and not startMission then
						lib.hideTextUI()
						insideZone = true
                        if ESX.Game.IsSpawnPointClear(vec3(Config.Start.van.x, Config.Start.van.y, Config.Start.van.z), 10.0) then
                            loading()
                            lib.requestModel("rebel")
                            ESX.Game.SpawnVehicle("rebel", vec3(Config.Start.van.x, Config.Start.van.y, Config.Start.van.z), Config.Start.van.w, function(vehicle)
                                van = vehicle
                                plate = GetVehicleNumberPlateText(van)
                            end)
                            
                            startMission = true
                            startBlipD()
                            startBlipS()
                            ESX.ShowNotification(Config.translate.knock)
                        else
                            ESX.ShowNotification(Config.translate.postoVan, "error")
                        end
                    elseif not IsPedInAnyVehicle(ped, false) and startMission == true then
                        local count = inv:GetItemCount(Config.item, nil, false)
                        DisableControlAction(0, 24, true)
                        DisableControlAction(0, 25, true)
                        loading2()

                        TriggerServerEvent("ox_inventory:removeItem", Config.item, count)
                        ESX.Game.DeleteVehicle(van)
                        stopBlip()
                        lib.hideTextUI()
                        ESX.HideUI("garage_delivery")
                    end
				end
			end,
			onExit = function()
				lib.hideTextUI()
                insideZone = false
			end
		})

        lib.requestModel("a_m_o_tramp_01")
        local ped = CreatePed(0, "a_m_o_tramp_01", Config.Start.npc.x, Config.Start.npc.y, Config.Start.npc.z, Config.Start.npc.w, false, true)
        SetEntityHeading(ped, Config.Start.npc.w)
        SetPedFleeAttributes(ped, 2, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedCanRagdollFromPlayerImpact(ped, false)
        SetPedDiesWhenInjured(ped, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetPedCanPlayAmbientAnims(ped, false)
        if anim == nil then
            TaskStartScenarioInPlace(ped, "WORLD_HUMAN_LEANING", 0, true)
        elseif anim then
            if anim.scenario then
                TaskStartScenarioInPlace(ped, anim.scenario, 0, true)
            elseif anim.dict and anim.clip then
                lib.requestAnimDict(anim.dict)
                TaskPlayAnim(ped, anim.dict, anim.clip, anim.bleedIn or 8.0, anim.bleedOut or 8.0, anim.duration or -1, anim.flag or 1, 0, false, false, false)
            end
        end
        return ped
    end
end)

-- retrive
Citizen.CreateThread(function()
    for k,v in pairs(Config.retrive) do
        local zoneRetrive = lib.zones.box({
            coords = vec3(Config.retrive.coords.x, Config.retrive.coords.y, Config.retrive.coords.z),
            size = vec3(Config.retrive.Areasize.x, Config.retrive.Areasize.y, Config.retrive.Areasize.z),
            rotation = Config.retrive.AreaRotation,
            --debug = true,
            onEnter = function()
                if not IsPedInAnyVehicle(ped, false) then
                    lib.showTextUI('[E] - ' .. Config.TexUiText.retrieve, Config.TextUiStyle)
                end
            end,
            inside = function()
                if not IsPedInAnyVehicle(ped, false) and IsControlJustPressed(0, 51) then
                    if not insideZone and startMission == true then
                        if not takeLiquor then
                            lib.hideTextUI()
                            insideZone = true
                                
                            if lib.progressBar({
                                duration = 3000,
                                label = Config.translate.retrieve,
                                position = 'bottom',
                                useWhileDead = false,
                                canCancel = true,
                                disable = {
                                    move = true,
                                    car = true,
                                    combat = true,
                                    mouse = false
                                },
                                anim = {
                                    dict = 'timetable@jimmy@doorknock@',
                                    clip = 'knockdoor_idle' 
                                },
                            }) then
                                TriggerServerEvent("delivery_run:takeMaterials")
                                ESX.ShowNotification(Config.translate.start, "success")
                                takeLiquor = true
                            end
                        else
                            ESX.ShowNotification(Config.translate.alreadyLiquor, "error")
                        end
                    else 
                        ESX.ShowNotification(Config.translate.nojob, "error")
                    end                  
                end 
            end,
            onExit = function()
                lib.hideTextUI()
                insideZone = false
            end
        })
    end
end)

-- Delivery
Citizen.CreateThread(function()
    for _,v in pairs(Config.Delivery) do
        isBusy[_] = false
        local zoneDelivery = lib.zones.sphere({
            coords = vec3(v.x, v.y, v.z),
            radius = 3.0,
            onEnter = function()
                insideZone = true
                if not IsPedInAnyVehicle(ped, false) then
                    lib.showTextUI('[E] - ' .. Config.TexUiText.delivery, Config.TextUiStyle)
                end
            end,
            inside = function()
                DisableControlAction(0, 24, true)
                DisableControlAction(0, 25, true)
                if not IsPedInAnyVehicle(ped, false) and IsControlJustPressed(0, 51) then
                    if insideZone and startMission == true then
                        if isBusy[_] == false then
                            lib.hideTextUI()
                            local count = inv:Search("count", Config.item)
                            if count >= 1 then
                                delivery()
                                isBusy[_] = true
                                TriggerServerEvent("delivery_run:delivery")
                                if math.random(Config.probCall.a,Config.probCall.b) > Config.alertProb then
                                    TriggerEvent("delivery_run:callPolice")
                                end
                                RemoveBlip(blipsDelivery[_])
                            else
                                ESX.ShowNotification(Config.translate.no_item, "error")
                            end
                        else
                            ESX.ShowNotification(Config.translate.already_delivered, "error")
                        end
                    else
                        ESX.ShowNotification(Config.translate.nojob, "error")
                    end
                end
            end,
            onExit = function()
                lib.hideTextUI()
                insideZone = false
            end
        })

        lib.requestModel("a_m_o_tramp_01")
        local ped = CreatePed(0, "a_m_o_tramp_01", v.x, v.y, v.z-1, v.w, false, true)
        SetEntityHeading(ped, v.w)
        SetPedFleeAttributes(ped, 2, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedCanRagdollFromPlayerImpact(ped, false)
        SetPedDiesWhenInjured(ped, true)
        FreezeEntityPosition(ped, true)
        SetEntityInvincible(ped, true)
        SetPedCanPlayAmbientAnims(ped, false)
        if anim == nil then
            TaskStartScenarioInPlace(ped, "WORLD_HUMAN_LEANING", 0, true)
        elseif anim then
            if anim.scenario then
                TaskStartScenarioInPlace(ped, anim.scenario, 0, true)
            elseif anim.dict and anim.clip then
                lib.requestAnimDict(anim.dict)
                TaskPlayAnim(ped, anim.dict, anim.clip, anim.bleedIn or 8.0, anim.bleedOut or 8.0, anim.duration or -1, anim.flag or 1, 0, false, false, false)
            end
        end
    end
end)

--blip
blipsDelivery = {}
blipsStart = {}
function startBlipD()
    Citizen.CreateThread(function()
        for _,v in pairs(Config.Delivery) do
            local coords = vec3(v.x,v.y,v.z)
            if startMission == true then
                blipD = AddBlipForCoord(coords)
                SetBlipSprite(blipD, 478)
                SetBlipScale(blipD, 0.6)
                SetBlipColour(blipD, 27)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Consegna")
                EndTextCommandSetBlipName(blipD)
                table.insert(blipsDelivery, blipD)
            end
        end
    end)
end

function startBlipS()
    Citizen.CreateThread(function()
        if startMission == true then
            local coordsS = vec3(Config.Start.npc.x,Config.Start.npc.y,Config.Start.npc.z)
            blipS = AddBlipForCoord(coordsS)
            SetBlipSprite(blipS, 478)
            SetBlipScale(blipS, 0.6)
            SetBlipColour(blipS, 1)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Yard")
            EndTextCommandSetBlipName(blipS)
            table.insert(blipsStart, blipS)
        end
    end)
end

function stopBlip()
    Citizen.CreateThread(function()
        for _, blipId in pairs(blipsDelivery) do
            RemoveBlip(blipId)
        end
        for _, blipId in pairs(blipsStart) do
            RemoveBlip(blipId)
        end
        blipsDelivery = {}
        blipsStart = {}
        
        for i = 1, #isBusy do
            isBusy[i] = false
        end
    end)
    startMission = false
    takeLiquor = false
end