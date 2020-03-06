local function CreateTownhallBlips()
	for k,v in pairs(Config.townhall) do
		blip = AddBlipForCoord(v.x, v.y, v.z-1)
		SetBlipSprite(blip, 498)
		SetBlipColour(blip, 4)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Townhall")
		EndTextCommandSetBlipName(blip)
	end
end

Citizen.CreateThread(function()
	CreateTownhallBlips()
end)