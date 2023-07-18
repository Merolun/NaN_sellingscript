local QBCore = exports['qb-core']:GetCoreObject()
local Itemlist = {
   
    ["advancedrepairkit"]  =  50 ,
}

RegisterNetEvent('vkz-sellitems:server:sellitem', function()
    local src = source
    local price = 0
    local Player = QBCore.Functions.GetPlayer(src)
    local xItem = Player.Functions.GetItemsByName(Itemlist)

    if Player.PlayerData.job.name == "mechanic" then -- Vérifie si le joueur a le job "mechanic"
        if xItem ~= nil then
            for k in pairs(Player.PlayerData.items) do
                if Player.PlayerData.items[k] ~= nil then
                    if Itemlist[Player.PlayerData.items[k].name] ~= nil then
                        price = price + (Itemlist[Player.PlayerData.items[k].name] * Player.PlayerData.items[k].amount)
                        Player.Functions.RemoveItem(Player.PlayerData.items[k].name, Player.PlayerData.items[k].amount, k)
                    end
                end
            end
            Player.Functions.AddMoney("cash", price, "sold-resources")
            if price ~= 0 then
            TriggerClientEvent('QBCore:Notify', src, "tu as vendu des kits pour  " ..price.."$")
            TriggerEvent("qb-log:server:CreateLog", "sellitem", "resources", "blue", "**"..GetPlayerName(src) .. "** Vous avez obtenu "..price.."$ pour la vente de vos kits")
                else
                TriggerClientEvent('QBCore:Notify', src, "Vous n'avez pas de kit a vendre..")
            end
        end
    else
        TriggerClientEvent('okokNotify:Alert', source, 'Mecano', 'T\'es pas mécano', 5000, 'warning', playSound)
    end
end)


-- Callback function to get the number of "advancedrepairkit" items in the player's inventory
QBCore.Functions.CreateCallback('getAdvancedRepairKitCount', function(source, cb)
    local Player = QBCore.Functions.GetPlayer(source)
    local advancedRepairKitCount = 0

    if Player ~= nil then
        local xItem = Player.Functions.GetItemByName("advancedrepairkit")
        if xItem ~= nil then
            advancedRepairKitCount = xItem.amount
        end
    end
    cb(advancedRepairKitCount)
end)




