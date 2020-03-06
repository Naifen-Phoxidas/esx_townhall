Citizen.CreateThread(function()
    RequestModel(GetHashKey("ig_bankman"))
	
    while not HasModelLoaded(GetHashKey("ig_bankman")) do
        Wait(1)
    end
	
	for _, item in pairs(Config.ped) do
		local npc = CreatePed(4, 0x909D9E7F, item.x, item.y, item.z, item.heading, false, true)
			
		SetEntityHeading(npc, item.heading)
		FreezeEntityPosition(npc, true)
		SetEntityInvincible(npc, true)
		SetBlockingOfNonTemporaryEvents(npc, true)	
	end
end)

Citizen.CreateThread(function()
    Holograms()
end)

function Holograms()
	while true do
		Citizen.Wait(0)			
		if GetDistanceBetweenCoords( -543.3, -207.05, 37.65, GetEntityCoords(GetPlayerPed(-1))) < 20.0 then
			Draw3DText( -543.3, -207.05, 38.20  -1.000, "~o~Towenhall", 1, 0.14, 0.14)
			Draw3DText( -543.3, -207.05, 38.10   -1.300, "The citizen is king!", 0, 0.1, 0.1)		
		end	
	end
end

function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
         local px,py,pz=table.unpack(GetGameplayCamCoords())
         local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
         local scale = (1/dist)*20
         local fov = (1/GetGameplayCamFov())*100
         local scale = scale*fov   
         SetTextScale(scaleX*scale, scaleY*scale)
         SetTextFont(fontId)
         SetTextProportional(1)
         SetTextColour(250, 250, 250, 255)		-- You can change the text color here
         SetTextDropshadow(1, 1, 1, 1, 255)
         SetTextEdge(2, 0, 0, 0, 150)
         SetTextDropShadow()
         SetTextOutline()
         SetTextEntry("STRING")
         SetTextCentre(1)
         AddTextComponentString(textInput)
         SetDrawOrigin(x,y,z+2, 0)
         DrawText(0.0, 0.0)
         ClearDrawOrigin()
end