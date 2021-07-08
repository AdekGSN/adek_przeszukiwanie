ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('adek:giveitem')
AddEventHandler('adek:giveitem', function()
    local source = source
    xPlayer = ESX.GetPlayerFromId(source)
    local data = RandomItem()
    xPlayer.addInventoryItem(data[1], math.random(1, data[2]))
end)
Items = Config.Items
function RandomItem()
    local rnd = math.random(#Items)
    return {Items[rnd].itemname, Items[rnd].max}
end