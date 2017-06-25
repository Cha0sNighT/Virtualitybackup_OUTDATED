-- HERE GOES YOUR CLIENT FUNCTIONALITY!
local nbPolice = 0

RegisterNetEvent('blanchi:drawTransform')
AddEventHandler('blanchi:drawTransform', function (qte)
		if(qte == nil) then
			qte = 0
		end
		if qte > 0 then
			
			ClearPrints()
			SetTextEntry_2("STRING")
			AddTextComponentString("~g~Vous avez blanchi votre argent")
			DrawSubtitleTimed(2000, 1)
		else
			-- ClearPrints()
			-- SetTextEntry_2("STRING")
			-- AddTextComponentString("~r~Vous n'avez plus d'argent sale")
			-- DrawSubtitleTimed(2000, 1)
		end
end)

Citizen.CreateThread(function()
    while true do
       Citizen.Wait(0)
       playerPed = GetPlayerPed(-1)
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		if pos then
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), -191.44578552246,-1179.0290527344,23.075616836548, true) <= 1 then
					if nbPolice < 100 then
						ClearPrints()
						SetTextEntry_2("STRING")
						AddTextComponentString("~g~Blanchiment en cours...")
						DrawSubtitleTimed(10000, 1)
						Citizen.Wait(10000)
						TriggerServerEvent('blanchi:transform',source)
					else
						TriggerEvent("mt:missiontext", 'Il faut au moins 4 policiers en Service pour Blanchir', 800)
					end
						
				end				
		end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(15000)
		TriggerServerEvent('blanchi:stestcop')
	end
end)

RegisterNetEvent('blanchi:getcop')
AddEventHandler("blanchi:getcop", function(nbPolicier)
	nbPolice = nbPolicier
	--Citizen.Trace(nbPolice)
end)