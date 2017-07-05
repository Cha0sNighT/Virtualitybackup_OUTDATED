--[[Register]]--

RegisterNetEvent("ply_autoecole:GetLicences")
RegisterNetEvent("ply_autoecole:StartPermisTrue")
RegisterNetEvent("ply_autoecole:StartPermisFalse")




--[[Local/Global]]--

permis = {}
local autoecole_location = {-1193.31, -1492.55, 3.279}
local epreuve = false
local ventenamefr = "Auto/Moto Ecole"
local ventenameen = "Auto/Moto Drive test"



--[[Functions]]--

function configLang(lang)
	local lang = lang
	if lang == "FR" then
		lang_string = {
			menu1 = "Auto/Moto Ecole",
			menu2 = "Fermer",
			menu3 = "~g~E~s~ pour ouvrir le menu",
			menu4 = "Ce permis est déjà obtenu",
			menu5 = "La zone est encombrée",
			menu6 = "Début de l'épreuve, rendez-vous à destination",
			menu7 = "E pour terminer l'épreuve",
			menu8 = "Epreuve raté, le véhicule est trop endommagé",
			menu9 = "Epreuve réussie",
			menu10 = "Ce n'est pas le bon vehicule"
	}

	elseif lang == "EN" then
		lang_string = {
			menu1 = "Auto/Moto Drive test",
			menu2 = "Close",
			menu3 = "~g~E~s~ to open menu",
			menu4 = "This license is already obtained",
			menu5 = "The area is crowded",
			menu6 = "Start of the test, go to destination",
			menu7 = "E to complete the test",
			menu8 = "Test failed, the vehicle is too damaged",
			menu9 = "Test successful",
			menu10 = "This is not the right vehicle"
	}
	end
end

function MenuAutoecole()
    ped = GetPlayerPed(-1);
    MenuTitle = lang_string.menu1
    ClearMenu()
    for ind, value in pairs(permis) do
		Menu.addButton(tostring(value.name), "SetPermis", value.id)
    end
    Menu.addButton(lang_string.menu2,"CloseMenu",nil) 
end

function SetPermis(permis_id)
	local permis_id = permis_id
	TriggerServerEvent('ply_autoecole:CheckForPermis', permis_id)	
	CloseMenu()
end

function drawNotification(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function CloseMenu()
    Menu.hidden = true
    TriggerServerEvent("ply_autoecole:GetLicences")
end

function LocalPed()
	return GetPlayerPed(-1)
end

function Chat(debugg)
    TriggerEvent("chatMessage", '', { 0, 0x99, 255 }, tostring(debugg))
end

function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end

function GetVehHealthPercent(vehicle)
	local ped = GetPlayerPed(-1)
	local vehicle = GetVehiclePedIsUsing(ped)
	local vehiclehealth = GetEntityHealth(vehicle) - 100
	local maxhealth = GetEntityMaxHealth(vehicle) - 100
	local procentage = (vehiclehealth / maxhealth) * 100
	return procentage
end



--[[Citizen]]--

Citizen.CreateThread(function()
	local pos = autoecole_location
	local blip = AddBlipForCoord(pos[1],pos[2],pos[3])
	SetBlipSprite(blip,198)
	SetBlipColour(blip,1)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(ventenamefr)
	EndTextCommandSetBlipName(blip)
	SetBlipAsShortRange(blip,true)
	SetBlipAsMissionCreatorBlip(blip,true)
	while true do
		Wait(0)
		DrawMarker(1,autoecole_location[1],autoecole_location[2],autoecole_location[3],0,0,0,0,0,0,4.001,4.0001,0.5001,0,155,255,200,0,0,0,0)
		if GetDistanceBetweenCoords(autoecole_location[1],autoecole_location[2],autoecole_location[3],GetEntityCoords(LocalPed())) < 5 and IsPedInAnyVehicle(LocalPed(), true) == false then
			drawTxt(lang_string.menu3,0,1,0.5,0.8,0.6,255,255,255,255)		
			if IsControlJustPressed(1, 86) then
				MenuAutoecole()
				Menu.hidden = not Menu.hidden
			end
			Menu.renderGUI()
		end
	end
end)



--[[Events]]--

AddEventHandler("playerSpawned", function()
    local lang = "FR"
    configLang(lang)
    TriggerServerEvent("ply_autoecole:GetLicences")
end)

AddEventHandler("ply_autoecole:GetLicences", function(thepermis)
    permis = {}
    permis = thepermis
end)

AddEventHandler("ply_autoecole:StartPermisFalse", function()
	drawNotification(lang_string.menu4)
end)

AddEventHandler("ply_autoecole:StartPermisTrue", function(id, name, vehicle, end_x, end_y, end_z)
	local permis_id = id
	local permis_name = name
	local permis_vehicle = vehicle
	local permis_end_x = end_x
	local permis_end_y = end_y
	local permis_end_z = end_z
	local permis_plate ="AUTOTEST"

	Citizen.CreateThread(function()
	 	Citizen.Wait(0)
 		local pos = autoecole_location
 		local caisseo = GetClosestVehicle(autoecole_location[1], autoecole_location[2], autoecole_location[3], 3.000, 0, 70)
		if DoesEntityExist(caisseo) then
			drawNotification(lang_string.menu5) 
		else
			RequestModel(permis_vehicle)
			while not HasModelLoaded(permis_vehicle) do
			Citizen.Wait(0)
			end
			veh = CreateVehicle(permis_vehicle, autoecole_location[1], autoecole_location[2], autoecole_location[3], 215.0, true, false)
			SetVehicleNumberPlateText(veh, permis_plate)
			SetVehicleOnGroundProperly(veh)
			SetVehicleHasBeenOwnedByPlayer(veh,true)
			local id = NetworkGetNetworkIdFromEntity(veh)
			SetNetworkIdCanMigrate(id, true)
			SetVehicleColours(veh, primarycolor, secondarycolor)
			SetVehicleExtraColours(veh, pearlescentcolor, wheelcolor)
			TaskWarpPedIntoVehicle(GetPlayerPed(-1),veh,-1)
			SetEntityInvincible(veh, false) 
			drawNotification(lang_string.menu6)		
		end		
	end)

	local epreuve = true

	blipermis = AddBlipForCoord(permis_end_x,permis_end_y,permis_end_z)
	Citizen.CreateThread(function()		
		Wait(0)
        SetBlipSprite(blipermis, 1)
        SetBlipColour(blipermis, 2)
        SetBlipAsMissionCreatorBlip(blipermis,true)
        SetBlipRoute(blipermis, true)
	end)

	Citizen.CreateThread(function()
		while true do
			Wait(0)
			if GetDistanceBetweenCoords(permis_end_x,permis_end_y,permis_end_z,GetEntityCoords(LocalPed())) < 3 and epreuve then
				drawTxt(lang_string.menu7,0,1,0.5,0.8,0.6,255,255,255,255)
				if IsControlJustPressed(1, 86) then
					local ped = GetPlayerPed(-1)
					local vehicle = GetVehiclePedIsUsing(ped)
					SetEntityAsMissionEntity(vehicle, true, true)
					local vehplate = GetVehicleNumberPlateText(vehicle)					
					if vehplate == permis_plate then
						local vehiclehealth = GetEntityHealth(vehicle) - 100
						local maxhealth = GetEntityMaxHealth(vehicle) - 100
						local damage = (vehiclehealth / maxhealth) * 100
						if damage <= 95 then							
							drawNotification(lang_string.menu8)							
							Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
							epreuve = false
							SetEntityAsNoLongerNeeded(blipermis)
							SetBlipAsMissionCreatorBlip(blipermis,false)
							Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(blipermis))
						else							
							drawNotification(lang_string.menu9)
							Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(vehicle))
    						TriggerServerEvent("ply_autoecole:SetLicence", permis_id)
							epreuve = false
							SetEntityAsNoLongerNeeded(blipermis)
							SetBlipAsMissionCreatorBlip(blipermis,false)
							Citizen.InvokeNative(0x86A652570E5F25DD, Citizen.PointerValueIntInitialized(blipermis))
						end
					else
						drawNotification(lang_string.menu10)
					end
				end
			end
		end
	end)
end)
