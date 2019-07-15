local ESX = nil
-- used to keep the last hour record
local oldHour = nil
local newHour = nil
local modHour = nil

Citizen.CreateThread(function()
    while ESX == nil do
        Citizen.Wait(0)
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    end
end)

-- check the hour against the config for when a player is going to be taxed
Citizen.CreateThread(function()
	while true do
        Citizen.Wait(0)  

        newHour = GetClockHours();

        if oldHour == nil then
            oldHour = newHour
            Citizen.Wait(100)
            print("old hour is: " .. oldHour)
        end

        Citizen.Wait(100)
        modHour = oldHour + Config.Hour

        if modHour > 23 then -- if modHour is above 11 pm
            local difference = math.fmod (modHour, 24) -- find the difference between the modified hour and 12 am
            local oldDif = math.fmod(oldHour, 24) -- find the difference between the old hour and 12 am

            difference = difference - oldDif -- take the oldDif off the difference
            modHour = 0 + difference -- add it onto 0 to be the new tax hour
        end

        if newHour == modHour then
            print("triggering tax")
            TriggerServerEvent('esx_jj-tax:taxPlayer')
            oldHour = newHour
            print(oldHour)
        end 
	end
end)

-- used for debugging

-- Citizen.CreateThread(function()
-- 	while true do
--         Citizen.Wait(0)
--         if(IsControlJustPressed(1, 178)) then
--             TriggerServerEvent('esx_jj-tax:taxPlayer')
--         end
--     end
-- end)

RegisterNetEvent('esx_jj-tax:getVehName')
AddEventHandler('esx_jj-tax:getVehName', function()

    -- this grabs the owned cars and gets the displayname in the database from advancedgarage
    ESX.TriggerServerCallback('esx_advancedgarage:getOwnedCars', function(ownedCars)
        local vehNames = {}
        for _,v in pairs(ownedCars) do
            for q,w in pairs(v) do
                if q == "vehicle" then
                    local vehicleHash = w.model
                    local vehicleName = GetDisplayNameFromVehicleModel(vehicleHash)
                    table.insert(vehNames, vehicleName)
                end
            end
        end
        TriggerServerEvent('esx_jj-tax:getVehPrice',vehNames)
    end)
end)  

RegisterNetEvent('esx_jj-tax:notifiyTax')
AddEventHandler('esx_jj-tax:notifiyTax', function(message)
    exports['mythic_notify']:DoCustomHudText('inform', message, 5000)
end)