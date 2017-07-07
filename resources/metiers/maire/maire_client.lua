local maire_blipsTemp
local maire_markerBool = true
local existingVeh = nil
local isInServiceMaire = false

function maire_callSE(evt)
	Menu.hidden = not Menu.hidden
	Menu.renderGUI()
	TriggerServerEvent(evt)
end

function maire_InitMenuVehicules()
	MenuTitle = "SpawnJobs"
	ClearMenu()
	Menu.addButton("Berline", "maire_callSE", 'maire:Car')
  Menu.addButton("SUV", "maire_callSE", 'maire:Car2')
  Menu.addButton("Helico", "maire_callSE", 'maire:Car3')
end

RegisterNetEvent('maire:drawBlips')
AddEventHandler('maire:drawBlips', function ()
	for key, item in pairs(maire_blips) do
		item.blip = AddBlipForCoord(item.x, item.y, item.z)
		SetBlipSprite(item.blip, item.id)
		SetBlipAsShortRange(item.blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(key)
		EndTextCommandSetBlipName(item.blip)
	end
	maire_blipsTemp = maire_blips
end)

RegisterNetEvent('maire:deleteBlips')
AddEventHandler('maire:deleteBlips', function ()
	maire_markerBool = false
	for _, item in pairs(maire_blipsTemp) do
		RemoveBlip(item.blip)
	end
end)

RegisterNetEvent('maire:marker')
AddEventHandler('maire:marker', function ()
	Citizen.CreateThread(function ()
		while maire_markerBool == true do
			Citizen.Wait(1)
			if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), maire_blips["Mairie"].x, maire_blips["Mairie"].y, maire_blips["Mairie"].z, true) <= maire_blips["Mairie"].distanceMarker then
				DrawMarker(1, maire_blips["Mairie"].x, maire_blips["Mairie"].y, maire_blips["Mairie"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
				ClearPrints()
				SetTextEntry_2("STRING")
				if isInServiceMaire then
					AddTextComponentString("Appuyez sur ~g~E~s~ pour quitter le ~b~service actif")
				else
					AddTextComponentString("Appuyez sur ~g~E~s~ pour rentrer en ~b~service actif")
				end
				DrawSubtitleTimed(2000, 1)
				if IsControlJustPressed(1, Keys["E"]) then
					GetServiceMaire()
				end
			end

			if isInServiceMaire then
				if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), maire_blips["Garage"].x, maire_blips["Garage"].y, maire_blips["Garage"].z, true) <= maire_blips["Garage"].distanceMarker+5 then
						DrawMarker(1, maire_blips["Garage"].x, maire_blips["Garage"].y, maire_blips["Garage"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
						ClearPrints()
						SetTextEntry_2("STRING")
						AddTextComponentString("Appuyez sur ~g~E~s~ pour faire apparaître/ranger votre ~b~vehicule")
						DrawSubtitleTimed(2000, 1)
						if IsControlJustPressed(1, Keys["E"]) then
							if(existingVeh ~= nil) then
								SetEntityAsMissionEntity(existingVeh, true, true)
								Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(existingVeh))
								existingVeh = nil
							else
								maire_InitMenuVehicules()
								Menu.hidden = not Menu.hidden
							end
						end
					end
				Menu.renderGUI()
			end
		end
	end)
end)

function notif(message)
	Citizen.CreateThread(function()
		Wait(10)
		SetNotificationTextEntry("STRING")
		AddTextComponentString(message)
		DrawNotification(false, false)
	end)
end

function GetServiceMaire()
	local playerPed = GetPlayerPed(-1)
	if isInServiceMaire then
		notif("Vous n\'êtes plus en service")
		TriggerServerEvent("skin_customization:SpawnPlayer")
	else
		notif("Début du service")
		TriggerEvent("maire:getSkin")
	end
	isInServiceMaire = not isInServiceMaire
	TriggerServerEvent('maire:setService', isInServiceMaire)
end

	RegisterNetEvent('maire:getSkin')
	AddEventHandler('maire:getSkin', function (source)
		local hashSkin = GetHashKey("mp_m_freemode_01")
		Citizen.CreateThread(function()
		if(GetEntityModel(GetPlayerPed(-1)) == hashSkin) then
      SetPedComponentVariation(GetPlayerPed(-1), 7, 115, 0, 0) -- Cravate
    	SetPedComponentVariation(GetPlayerPed(-1), 8, 10, 0, 0) -- Chemise
    	SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 0) -- Main
    	SetPedComponentVariation(GetPlayerPed(-1), 11, 28, 0, 0) -- Veste
    	SetPedComponentVariation(GetPlayerPed(-1), 4, 10, 0, 0) -- Jeans
    	SetPedComponentVariation(GetPlayerPed(-1), 6, 10, 0, 0) -- Chaussure
		else
      SetPedComponentVariation(GetPlayerPed(-1), 7, 115, 0, 0) -- Cravate
    	SetPedComponentVariation(GetPlayerPed(-1), 8, 10, 0, 0) -- Chemise
    	SetPedComponentVariation(GetPlayerPed(-1), 3, 4, 0, 0) -- Main
    	SetPedComponentVariation(GetPlayerPed(-1), 11, 28, 0, 0) -- Veste
    	SetPedComponentVariation(GetPlayerPed(-1), 4, 10, 0, 0) -- Jeans
    	SetPedComponentVariation(GetPlayerPed(-1), 6, 10, 0, 0) -- Chaussure
		end
		end)
	end)

RegisterNetEvent('maire:getCar')
AddEventHandler('maire:getCar', function (source)
	local vehiculeDetected = GetClosestVehicle(maire_car.x, maire_car.y, maire_car.z, 6.0, 0, 70)
	if not DoesEntityExist(vehiculeDetected) then
		local myPed = GetPlayerPed(-1)
		local player = PlayerId()
		local vehicle = GetHashKey('schafter5')
		RequestModel(vehicle)
		while not HasModelLoaded(vehicle) do
			Wait(1)
		end
		local plate = math.random(1, 9)
		existingVeh = CreateVehicle(vehicle,maire_car.x, maire_car.y, maire_car.z,0.0, true, false)
		SetVehicleHasBeenOwnedByPlayer(existingVeh,true)
		local id = NetworkGetNetworkIdFromEntity(existingVeh)
		SetNetworkIdCanMigrate(id, true)
		SetEntityInvincible(existingVeh, false)
		SetVehicleOnGroundProperly(existingVeh)
		SetVehicleNumberPlateText(existingVeh, maire_platesuffix.." "..plate.." ")
		SetModelAsNoLongerNeeded(vehicle)
		Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(existingVeh))
	else
		notif("Zone encombrée.")
	end
end)

RegisterNetEvent('maire:getCar2')
AddEventHandler('maire:getCar2', function (source)
	local vehiculeDetected = GetClosestVehicle(maire_car2.x, maire_car2.y, maire_car2.z, 6.0, 0, 70)
	if not DoesEntityExist(vehiculeDetected) then
		local myPed = GetPlayerPed(-1)
		local player = PlayerId()
		local vehicle = GetHashKey('baller6')
		RequestModel(vehicle)
		while not HasModelLoaded(vehicle) do
			Wait(1)
		end
		local plate = math.random(1, 9)
		existingVeh = CreateVehicle(vehicle,maire_car2.x, maire_car2.y, maire_car2.z,0.0, true, false)
		SetVehicleHasBeenOwnedByPlayer(existingVeh,true)
		local id = NetworkGetNetworkIdFromEntity(existingVeh)
		SetNetworkIdCanMigrate(id, true)
		SetEntityInvincible(existingVeh, false)
		SetVehicleOnGroundProperly(existingVeh)
		SetVehicleNumberPlateText(existingVeh, maire_platesuffix.." "..plate.." ")
		SetModelAsNoLongerNeeded(vehicle)
		Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(existingVeh))
	else
		notif("Zone encombrée.")
	end
end)

RegisterNetEvent('maire:getCar3')
AddEventHandler('maire:getCar3', function (source)
	local vehiculeDetected = GetClosestVehicle(maire_car3.x, maire_car3.y, maire_car3.z, 6.0, 0, 70)
	if not DoesEntityExist(vehiculeDetected) then
		local myPed = GetPlayerPed(-1)
		local player = PlayerId()
		local vehicle = GetHashKey('volatus')
		RequestModel(vehicle)
		while not HasModelLoaded(vehicle) do
			Wait(1)
		end
		local plate = math.random(1, 9)
		existingVeh = CreateVehicle(vehicle,maire_car3.x, maire_car3.y, maire_car3.z,0.0, true, false)
		SetVehicleHasBeenOwnedByPlayer(existingVeh,true)
		local id = NetworkGetNetworkIdFromEntity(existingVeh)
		SetNetworkIdCanMigrate(id, true)
		SetEntityInvincible(existingVeh, false)
		SetVehicleOnGroundProperly(existingVeh)
		SetVehicleNumberPlateText(existingVeh, maire_platesuffix.." "..plate.." ")
		SetModelAsNoLongerNeeded(vehicle)
		Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(existingVeh))
	else
		notif("Zone encombrée.")
	end
end)
