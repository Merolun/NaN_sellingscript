local QBCore = exports['qb-core']:GetCoreObject()


local function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local selllocation = vector3(1221.402, -3005.195, 5.858) ---Change to change location of buyer
local sl = selllocation --short version to make it easier (sl.x = x value of the vector3 and so on) 
local jobName
local PlayerJob



-- Créer le blip
blip = AddBlipForCoord(sl.x, sl.y, sl.z)
SetBlipSprite(blip, 1)
SetBlipDisplay(blip, 0) -- Masquer le blip pour tous les joueurs
SetBlipColour(blip, 3)
SetBlipAsShortRange(blip, true)
BeginTextCommandSetBlipName("STRING")
AddTextComponentString("Vendeur de kits")
EndTextCommandSetBlipName(blip)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function ()
    PlayerJob = QBCore.Functions.GetPlayerData().job;
    jobName = PlayerJob.name;
    if jobName == "mechanic" then
        SetBlipDisplay(blip, 4) -- Rendre le blip visible uniquement pour les joueurs ayant le job "mechanic"
    else
        RemoveBlip(blip) -- Supprimer le blip pour les joueurs n'ayant pas le job "mechanic"
    end
end)

CreateThread(function()
    while true do
        local InRange = false
        local PlayerPed = PlayerPedId()
        local PlayerPos = GetEntityCoords(PlayerPed)
        local itemamount = 0

        local dist = #(PlayerPos - vector3(sl.x, sl.y, sl.z)) 
        if dist < 10 then
            if jobName == "mechanic" then
                InRange = true
                DrawMarker(2,sl.x, sl.y, sl.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.25, 0.2, 0.1, 255, 0, 0, 155, 0, 0, 0, 1, 0, 0, 0)
                if dist < 1 then
                    DrawText3Ds(sl.x, sl.y, sl.z, '~g~E~w~ - Vendre ses kits') 
                    if IsControlJustPressed(0, 38) then
                            QBCore.Functions.TriggerCallback('getAdvancedRepairKitCount', function(result)
                            print("result = " .. result)
                            itemamount = result
                            QBCore.Functions.Progressbar('kitsell', 'Vente de kits de réparation...', itemamount*5000, false, true, {
                                disableMovement = true,
                                disableCarMovement = true,
                                disableMouse = false,
                                disableCombat = true
                            }, {}, {}, {}, function()
                                TriggerServerEvent('vkz-sellitems:server:sellitem')
                            end, function()
                                TriggerEvent('QBCore:Notify', src, "BLABLABLA")
                            end)
                        end)
                    end
                end
            end
        end

        if not InRange then
            Wait(5000)
        end
        Wait(5)
    end
end)
