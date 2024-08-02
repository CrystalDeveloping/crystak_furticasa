ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('dai:item')
AddEventHandler('dai:item', function (item)
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.addInventoryItem(item, math.random(1, 6))
end)

RegisterServerEvent('entraincasa')
AddEventHandler('entraincasa', function()

    SetPlayerRoutingBucket(source, source)
end)

RegisterServerEvent('escidallacasa')
AddEventHandler('escidallacasa', function()

    SetPlayerRoutingBucket(source, 0)
end)