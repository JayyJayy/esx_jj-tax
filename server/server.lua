local ESX = nil
local identifier = false
local vehiclePrice = 0
local propertyPrice = 0

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx_jj-tax:taxPlayer')
AddEventHandler('esx_jj-tax:taxPlayer', function()
    local src = source
    Citizen.Wait(100)

    TriggerClientEvent('esx_jj-tax:getVehName', src) -- work out cost of vehicles
    Citizen.Wait(100)
    GrabPropertyPrice() -- work out cost of properties 
    Citizen.Wait(100)
    Tax(src) -- tax citizen
end)

RegisterNetEvent('esx_jj-tax:getVehPrice') 
AddEventHandler('esx_jj-tax:getVehPrice', function(_vehNames)
    GrabVehiclePrice(_vehNames) 
end)


-- in function so its not fully exposed

function Tax(src)
        local xPlayer = ESX.GetPlayerFromId(src)
        Citizen.Wait(100)
        local playerBank = xPlayer.getBank()
        local playerFullMoney = playerBank
        local playerTaxAssets = 0

        -- Checks to see if VehicleTax or Property Tax seperation is being used 
        -- if so add them to a seperate variable and add the taxed amount to the final tax total
        -- else just Tax the player with the full amount for properties and vehicles.

        if Config.UseVehicleTax == true then 
            local vehicleTax = GetPercent(vehiclePrice, "vehicles")
            playerTaxAssets = playerTaxAssets + vehicleTax
            Citizen.Wait(100)
        elseif Config.UseVehicleTax == false then
            playerFullMoney = playerFullMoney + vehiclePrice
        end

        if Config.UsePropertyTax == true then 
            local propertyTax = GetPercent(propertyPrice, "property")
            playerTaxAssets = playerTaxAssets + propertyTax
            Citizen.Wait(100)
        elseif Config.UsePropertyTax == false then
            playerFullMoney = playerFullMoney + propertyPrice
        end

        playerFullMoney = GetPercent(playerFullMoney, "tax")
        Citizen.Wait(100)

        if playerTaxAssets ~= 0 then
            playerFullMoney = playerFullMoney + playerTaxAssets
            Citizen.Wait(100)
        end

        --deduct from citizen, notify them and add to police and ems accounts.
        if playerFullMoney ~= 0 then 
            local message = "tax amount of $" .. playerFullMoney .. " has been deducted from your bank"
            if Config.UseMythicNotifications == true then 
                TriggerClientEvent('esx_jj-tax:notifiyTax', src, message)         
            else
                TriggerClientEvent('chatMessage', src, "", {255, 0, 0}, message)
            end
            GiveToGov(playerFullMoney)
        end
end

function GrabVehiclePrice(_vehNames)
    local am = 0

    for q,w in pairs(_vehNames) do
        MySQL.Async.fetchAll('SELECT price FROM `vehicles` WHERE `model` = @model', { ['@model'] = w }, function(price)
            for e,r in pairs(price) do
                for t,y in pairs(r) do
                   am = am + tonumber(y)
                end
            end
        end)
    end

    Citizen.Wait(100)
    vehiclePrice = am
    Citizen.Wait(100)
end

function GrabPropertyPrice()
    local am = 0

    MySQL.Async.fetchAll('SELECT price FROM `owned_properties` WHERE `owner` = @owner AND `rented` = @rented', { ['@owner'] = identifier, ['@rented'] = 0 }, function(propNames)
        for k,v in pairs(propNames) do
           for e,r in pairs(v) do
                am = am + tonumber(r)
           end
        end 
    end)

    Citizen.Wait(100)
    propertyPrice = am
end

function GiveToGov(money) -- Half the money given and give to both police and ems
    local half = money / 2

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_police', function(sharedAccount)
        sharedAccount.addMoney(half)
    end)

    TriggerEvent('esx_addonaccount:getSharedAccount', 'society_ambulance', function(sharedAccount)
        sharedAccount.addMoney(half)
    end)
end

function GetPercent(amount, type)
    local money = 0

    if type == 'property' then
        if amount <= Config.Low then
            money = amount * Config.PropertyTaxLow
        elseif amount > Config.Low and amount <= Config.High then
            money = amount * Config.PropertyTaxMedium
        elseif amount > Config.High and amount <= Config.High then
            money = amount * Config.PropertyTaxHigh
        end
    elseif type == 'vehicles' then
        if amount <= Config.Low then
            money = amount * Config.VehicleTaxLow
        elseif amount > Config.Low and amount <= Config.High then
            money = amount * Config.VehicleTaxMedium
        elseif amount > Config.High and amount <= Config.High then
            money = amount * Config.VehicleTaxHigh
        end
    elseif type == "tax" then
        if amount <= Config.Low then
            money = amount * Config.TaxLow
        elseif amount > Config.Low and amount <= Config.High then
            money = amount * Config.TaxMedium
        elseif amount > Config.High then
            money = amount * Config.TaxHigh
        end
    end

    local divide = money / 100
    local final = math.floor(divide)
    return final
end

