Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu("Townhall", "Choose an option!")
_menuPool:Add(mainMenu)

_menuPool:MouseControlsEnabled(false)
_menuPool:ControlDisablingEnabled(false)

function editname()

    local EditName = _menuPool:AddSubMenu(mainMenu, "Name change")
	local changefirstname = NativeUI.CreateItem("First name", "Change your first name for $2000")
	local changelastname = NativeUI.CreateItem("Last name", "Change your last name for $2000")
	
	EditName:AddItem(changefirstname)
	EditName:AddItem(changelastname)
	EditName.OnItemSelect = function(sender, item, index)
		if item == changefirstname then 
			EditFirstName()
		elseif item == changelastname then
			EditLastName()
		end
	end
	_menuPool:MouseControlsEnabled(false)
	_menuPool:ControlDisablingEnabled(false)
end

function earnvisum()
	
	local EarnVisum = _menuPool:AddSubMenu(mainMenu, "Apply for visa")
	local EarnVisumSandyShores = NativeUI.CreateItem("Sandy Shores", "Buy Sandy Shores visa for $5000")
	local EarnVisumBlainecounty = NativeUI.CreateItem("Blaine County", "Buy Blaine County visa for $8000")
	
	EarnVisum:AddItem(EarnVisumSandyShores)
	EarnVisum:AddItem(EarnVisumBlainecounty)
	EarnVisum.OnItemSelect = function(sender, item, index)
		if item == EarnVisumSandyShores then
			ESX.TriggerServerCallback('esx_license:checkLicense', function(hasSandyShoresVisum)
				if hasSandyShoresVisum then
					ESX.ShowNotification('~hold~You have already obtained a ~o~Sandy Shores~w~ visa!')
				else
					TriggerServerEvent('esx_townhall:SetVisum', 'sandyshoresvisa', 5000)
				end
			end, GetPlayerServerId(PlayerId()), 'sandyshoresvisa')
		elseif item == EarnVisumBlainecounty then
			ESX.TriggerServerCallback('esx_license:checkLicense', function(hasBlaineCountyVisum)
				if hasBlaineCountyVisum then
					ESX.ShowNotification('~hold~You have already obtained a ~o~Blaine County~w~ visa!')
				else
					TriggerServerEvent('esx_townhall:SetVisum', 'blainecountyvisa', 8000)
				end
			end, GetPlayerServerId(PlayerId()), 'blainecountyvisa')
		end
	end
	_menuPool:MouseControlsEnabled(false)
	_menuPool:ControlDisablingEnabled(false)
end
	
editname()
earnvisum()
_menuPool:RefreshIndex()

function IsPlayerNearPed()
	for k,v in pairs(Config.townhall) do
		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), true), v.x, v.y, v.z, true) < 80.0 then
			if not IsPedInAnyVehicle(PlayerPedId()) then
				if not _menuPool:IsAnyMenuOpen() then
				end
			end
		end

		if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), true), v.x, v.y, v.z, true) < 2.0 then
			if not _menuPool:IsAnyMenuOpen() then
				ESX.ShowHelpNotification('~hold~Press ~INPUT_CONTEXT~ to open the ~o~townhall ~w~menu.')
			end
			return true
		end
	end
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		_menuPool:ProcessMenus()
		if IsPlayerNearPed() then
			if IsControlJustPressed(0, 38) then
				mainMenu:Visible(not mainMenu:Visible())
			end
		else
			if  _menuPool:IsAnyMenuOpen() then
				mainMenu:Visible(not mainMenu:Visible())
			end				
		end
	end
end)

function KeyboardInput(entryTitle, textEntry, inputText, maxLength)
    AddTextEntry(entryTitle, textEntry)
    DisplayOnscreenKeyboard(1, entryTitle, "", inputText, "", "", "", maxLength)
	blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
		blockinput = false
        return result
    else
        Citizen.Wait(500)
		blockinput = false
        return nil
    end
end

function EditFirstName()
	local firstName = KeyboardInput("TOWNHALL_VORNAMEN", 'What is your new first name?', "", 15)

	if firstName ~= nil then
		firstName = tostring(firstName)
		
		if type(firstName) == 'string' then
			TriggerServerEvent('esx_townhall:SetFirstName', GetPlayerServerId(PlayerId()), firstName)
		end
	end
end

function EditLastName()
	local lastName = KeyboardInput("TOWNHALL_NACHNAMEN", 'What is your new last name??', "", 15)

	if lastName ~= nil then
		lastName = tostring(lastName)
		
		if type(lastName) == 'string' then
			TriggerServerEvent('esx_townhall:SetLastName', GetPlayerServerId(PlayerId()), lastName)
		end
	end
end