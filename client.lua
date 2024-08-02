local markerCooldowns = {}

local cooldownDuration = 50 * 60 * 1000

for k, v in pairs(CRYSTAL.Furtiincasa) do
    if v.blip then
        local blip = AddBlipForCoord(v.posentrata[1], v.posentrata[2], v.posentrata[3])
        SetBlipSprite(blip, 40)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 1.0)
        SetBlipColour(blip, 0)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Furto in casa')
        EndTextCommandSetBlipName(blip)
    end

    local function isCooldownActive(markerId)
        local currentTime = GetGameTimer()
        return markerCooldowns[markerId] and (currentTime - markerCooldowns[markerId]) < cooldownDuration
    end

    local function setCooldown(markerId)
        markerCooldowns[markerId] = GetGameTimer()
    end

    exports['crystal_lib']:CRYSTAL().gridsystem({
        pos = vector3(v.posentrata[1], v.posentrata[2], v.posentrata[3]),
        rot = vector3(90.0, 90.0, 90.0),
        scale = vector3(0.8, 0.8, 0.8),
        textureName = 'marker',
        saltaggio = true,
        requestitem = 'lockpick',
        msg = 'Premi [E] per effettuare un furto in casa',
        action = function()
            local markerId = 'entrata_' .. k
            if isCooldownActive(markerId) then
                TriggerEvent('crystal:showNotify', 'Furti in casa', 'error', 'Devi aspettare prima di poter interagire di nuovo')
                return
            end

            local skillchecj = lib.skillCheck({'easy', 'easy', {areaSize = 60, speedMultiplier = 2}, 'easy'}, {'w', 'w', 'w', 'w'})

            if skillchecj then
                local playerPed = PlayerPedId()
                local newX, newY, newZ = v.posuscita[1], v.posuscita[2], v.posuscita[3]
                SetEntityCoords(playerPed, newX, newY, newZ, false, false, false, true)
                TriggerServerEvent('entraincasa')
                TriggerEvent('crystal:showNotify', 'Furti in casa', 'success', 'Sei riuscito ad entrare in casa')
                setCooldown(markerId)
            end
        end
    })

    exports['crystal_lib']:CRYSTAL().gridsystem({
        pos = vector3(v.posuscita[1], v.posuscita[2], v.posuscita[3]),
        rot = vector3(90.0, 90.0, 90.0),
        scale = vector3(0.8, 0.8, 0.8),
        textureName = 'marker',
        saltaggio = true,
        msg = 'Premi [E] per uscire',
        action = function()
            local markerId = 'uscita_' .. k
            if isCooldownActive(markerId) then
                TriggerEvent('crystal:showNotify', 'Furti in casa', 'error', 'Devi aspettare prima di poter interagire di nuovo')
                return
            end

            local playerPed = PlayerPedId()
            local newX, newY, newZ = v.posentrata[1], v.posentrata[2], v.posentrata[3]
            SetEntityCoords(playerPed, newX, newY, newZ, false, false, false, true)
            TriggerServerEvent('escidallacasa')
            TriggerEvent('crystal:showNotify', 'Furti in casa', 'info', 'Sei uscito dalla casa')
            setCooldown(markerId)
        end
    })

    for m, g in pairs(v.postidovecercare) do
        exports['crystal_lib']:CRYSTAL().gridsystem({
            pos = vector3(g.poscercare[1], g.poscercare[2], g.poscercare[3]),
            rot = vector3(90.0, 90.0, 90.0),
            scale = vector3(0.8, 0.8, 0.8),
            textureName = 'marker',
            saltaggio = true,
            msg = 'Premi [E] per cercare qualcosa',
            action = function()
                local markerId = 'cercare_' .. k .. '_' .. m
                if isCooldownActive(markerId) then
                    TriggerEvent('crystal:showNotify', 'Furti in casa', 'error', 'Devi aspettare prima di poter interagire di nuovo')
                    return
                end

                local randomItem = math.random(1, #g.itemtrovabili)
                local item = g.itemtrovabili[randomItem]

                local success = lib.progressBar({
                    duration = 2000,
                    label = 'Cercando',
                    canCancel = true,
                    disable = {
                        move = true
                    },
                    anim = {
                        dict = 'mini@repair',
                        clip = 'fixing_a_ped'
                    },
                })

                if success then
                    TriggerServerEvent('dai:item', item)
                    TriggerEvent('crystal:showNotify', 'Furti in casa', 'info', 'hai trovato ' .. item)
                    setCooldown(markerId)
                end
            end
        })
    end
end
