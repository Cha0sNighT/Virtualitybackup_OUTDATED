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
			 --ClearPrints()
			 --SetTextEntry_2("STRING")
			 --AddTextComponentString("~r~Vous n'avez plus d'argent sale")
			 --DrawSubtitleTimed(2000, 1)
		end
end)

Citizen.CreateThread(function()
    while true do
       Citizen.Wait(0)
       playerPed = GetPlayerPed(-1)
		local pos = GetEntityCoords(GetPlayerPed(-1), true)
		if pos then
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), 1327.65234375,-1654.2707519531,51.27645111084, true) <= 1 then
					if nbPolice < 3 then
						TriggerEvent("mt:missiontext", 'Il faut au moins 3 policiers en Service pour Blanchir', 800)
					else
						ClearPrints()
						SetTextEntry_2("STRING")
						AddTextComponentString("~g~Blanchiment en cours...")
						DrawSubtitleTimed(300000, 1)
						Citizen.Wait(300000)
						TriggerServerEvent('blanchi:transform',source)
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

Citizen.CreateThread(function()
	local nbObjetsCrees = 0
	while nbObjetsCrees < 1 do
		local panneau = CreateObject("prop_sign_road_04a", 409.2580871582, -977.21813964844, 28.419080734253, true, true, true)
        PlaceObjectOnGroundProperly(panneau)
        local weed1 = CreateObject("prop_weed_01", -875.19732666016, 183.54217529297, 68.026702880859, true, true, true)
        PlaceObjectOnGroundProperly(weed1)
        local weed2 = CreateObject("prop_weed_01", -877.19732666016, 183.54217529297, 68.026702880859, true, true, true)
        PlaceObjectOnGroundProperly(weed2)
        local weed3 = CreateObject("prop_weed_01", -879.19732666016, 183.54217529297, 68.026702880859, true, true, true)
        PlaceObjectOnGroundProperly(weed3)
        local weed4 = CreateObject("prop_weed_01", -881.19732666016, 183.54217529297, 68.026702880859, true, true, true)
        PlaceObjectOnGroundProperly(weed4)
        local weed5 = CreateObject("prop_weed_01", -883.19732666016, 183.54217529297, 68.026702880859, true, true, true)
        PlaceObjectOnGroundProperly(weed5)
        local weed6 = CreateObject("prop_weed_01", -885.19732666016, 183.54217529297, 68.026702880859, true, true, true)
        PlaceObjectOnGroundProperly(weed6)
        local weed7 = CreateObject("prop_weed_01", -875.19732666016, 181.54217529297, 68.026702880859, true, true, true)
        PlaceObjectOnGroundProperly(weed7)
        local weed8 = CreateObject("prop_weed_01", -875.19732666016, 179.54217529297, 68.026702880859, true, true, true)
        PlaceObjectOnGroundProperly(weed8)
        local weed9 = CreateObject("prop_weed_01", -877.19732666016, 181.54217529297, 68.026702880859, true, true, true)
        PlaceObjectOnGroundProperly(weed9)
        local weed10 = CreateObject("prop_weed_01", -877.19732666016, 179.54217529297, 68.026702880859, true, true, true)
        PlaceObjectOnGroundProperly(weed10)
        local weed11 = CreateObject("prop_weed_01", -879.19732666016, 181.54217529297, 68.026702880859, true, true, true)
        PlaceObjectOnGroundProperly(weed11)
        local weed12 = CreateObject("prop_weed_01", -879.19732666016, 179.54217529297, 68.026702880859, true, true, true)
        PlaceObjectOnGroundProperly(weed12)
        local weed13 = CreateObject("prop_weed_01", -881.19732666016, 181.54217529297, 68.026702880859, true, true, true)
        PlaceObjectOnGroundProperly(weed13)
        local weed14 = CreateObject("prop_weed_01", -881.19732666016, 179.54217529297, 68.026702880859, true, true, true)
        PlaceObjectOnGroundProperly(weed14)
        local weed15 = CreateObject("prop_weed_01", -883.19732666016, 181.54217529297, 68.026702880859, true, true, true)
        PlaceObjectOnGroundProperly(weed15)
        local weed16 = CreateObject("prop_weed_01", -883.19732666016, 179.54217529297, 68.026702880859, true, true, true)
        PlaceObjectOnGroundProperly(weed16)
        local weed17 = CreateObject("prop_weed_01", -885.19732666016, 181.54217529297, 68.026702880859, true, true, true)
        PlaceObjectOnGroundProperly(weed17)
        local weed18 = CreateObject("prop_weed_01", -885.19732666016, 179.54217529297, 68.026702880859, true, true, true)
        PlaceObjectOnGroundProperly(weed18)
		local weedpalette1 = CreateObject("hei_prop_heist_weed_pallet_02", -289.26150512695, -984.08020019531, 23.137044906616, true, true, true)
        PlaceObjectOnGroundProperly(weedpalette1)
		local weedpalette2 = CreateObject("hei_prop_heist_weed_pallet_02", -289.26150512695, -982.08020019531, 23.137044906616, true, true, true)
        PlaceObjectOnGroundProperly(weedpalette2)
		local weedpalette3 = CreateObject("hei_prop_heist_weed_pallet_02", -289.26150512695, -980.08020019531, 23.137044906616, true, true, true)
        PlaceObjectOnGroundProperly(weedpalette3)
		local coke1 = CreateObject("prop_coke_block_01", 936.73236083984, -1516.2825927734, 29.974159240723, true, true, true)
        PlaceObjectOnGroundProperly(coke1)
		local coke2 = CreateObject("prop_coke_block_01", 936.23236083984, -1516.2825927734, 29.974159240723, true, true, true)
        PlaceObjectOnGroundProperly(coke2)
		local coke3 = CreateObject("prop_coke_block_01", 935.73236083984, -1516.2825927734, 29.974159240723, true, true, true)
        PlaceObjectOnGroundProperly(coke3)
		local coke4 = CreateObject("prop_coke_block_01", 935.53236083984, -1516.2825927734, 29.974159240723, true, true, true)
        PlaceObjectOnGroundProperly(coke4)
		local coke5 = CreateObject("prop_coke_block_01", 936.73236083984, -1515.7825927734, 29.974159240723, true, true, true)
        PlaceObjectOnGroundProperly(coke5)
		local coke6 = CreateObject("prop_coke_block_01", 936.23236083984, -1515.7825927734, 29.974159240723, true, true, true)
        PlaceObjectOnGroundProperly(coke6)
		local coke7 = CreateObject("prop_coke_block_01", 935.73236083984, -1516.7825927734, 29.974159240723, true, true, true)
        PlaceObjectOnGroundProperly(coke7)
		local coke8 = CreateObject("prop_coke_block_01", 935.53236083984, -1516.7825927734, 29.974159240723, true, true, true)
        PlaceObjectOnGroundProperly(coke8)
        local arcade1 = CreateObject("prop_arcade_01", 930.18884277344, 45.714645385742, 80.090049743652, true, true, true)
        PlaceObjectOnGroundProperly(arcade1)
		nbObjetsCrees = nbObjetsCrees + 1

	end
end)

