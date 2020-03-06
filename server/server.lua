ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_townhall:SetFirstName')
AddEventHandler('esx_townhall:SetFirstName', function(ID, firstName)
    local identifier = ESX.GetPlayerFromId(ID).identifier
	local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.getMoney() >= 2000 then
		local newfirstname = xPlayer.getName()
        xPlayer.removeMoney(2000)
		SetFirstName(identifier, firstName)
		xPlayer.showNotification('~hold~Your new name is ~g~'.. newfirstname ..'~w~.')
	elseif xPlayer.getAccount('bank').money >= 2000 then
		local newfirstname = xPlayer.getName()
		xPlayer.removeAccountMoney('bank', 2000)
		SetFirstName(identifier, firstName)
		xPlayer.showNotification('~hold~Your new name is ~g~'.. newfirstname ..'~w~.')
	else
		xPlayer.showNotification('~r~~hold~You have not enough money!')
	end
end)

RegisterServerEvent('esx_townhall:SetLastName')
AddEventHandler('esx_townhall:SetLastName', function(ID, lastName)
    local identifier = ESX.GetPlayerFromId(ID).identifier
	local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)

	if xPlayer.getMoney() >= 2000 then
		local newlastname = xPlayer.getName()
        xPlayer.removeMoney(2000)
		SetLastName(identifier, lastName)
		xPlayer.showNotification('~hold~Your new name is ~g~'.. newfirstname ..'~w~.')
	elseif xPlayer.getAccount('bank').money >= 2000 then
		local newlastname = xPlayer.getName()
		xPlayer.removeAccountMoney('bank', 2000)
		SetLastName(identifier, lastName)
		xPlayer.showNotification('~hold~Your new name is ~g~'.. newfirstname ..'~w~.')
	else
		xPlayer.showNotification('~r~~hold~You have not enough money!')
	end
end)

function SetFirstName(identifier, firstName)
	MySQL.Async.execute('UPDATE `users` SET `firstname` = @firstname WHERE identifier = @identifier', {
		['@identifier']		= identifier,
		['@firstname']		= firstName
	})
end

function SetLastName(identifier, lastName)
	MySQL.Async.execute('UPDATE `users` SET `lastname` = @lastname WHERE identifier = @identifier', {
		['@identifier']		= identifier,
		['@lastname']		= lastName
	})
end

RegisterNetEvent('esx_townhall:SetVisum')
AddEventHandler('esx_townhall:SetVisum', function(type, price)
	local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
	
	if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
		TriggerEvent('esx_license:addLicense', _source, type, function()
		end)
		xPlayer.showNotification('~hold~Get visa: ~g~'.. type ..'~w~.')
	elseif xPlayer.getAccount('bank').money >= price then
		xPlayer.removeAccountMoney('bank', price)
		TriggerEvent('esx_license:addLicense', _source, type, function()
		end)
		xPlayer.showNotification('~hold~Get visa: ~g~'.. type ..'~w~.')
	else
		xPlayer.showNotification('~r~~hold~You have not enough money!')
	end
end)