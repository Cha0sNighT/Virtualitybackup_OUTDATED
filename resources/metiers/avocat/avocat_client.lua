local avocat_blipsTemp
local Avocat_markerBool = false
local existingVeh = nil
local isInServiceAvocat = false


function Avocat_callSE(evt)
  Menu.hidden = not Menu.hidden
  Menu.renderGUI()
  TriggerServerEvent(evt)
end

function Avocat_InitMenuVehicules()
  MenuTitle = "SpawnJobs"
  ClearMenu()
  Menu.addButton("Vehicule", "Avocat_callSE", 'avocat:Car')
end

RegisterNetEvent('avocat:drawBlips')
AddEventHandler('avocat:drawBlips', function ()
  for key, item in pairs(avocat_blips) do
    item.blip = AddBlipForCoord(item.x, item.y, item.z)
    SetBlipSprite(item.blip, item.id)
    SetBlipAsShortRange(item.blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(key)
    EndTextCommandSetBlipName(item.blip)
  end
  avocat_blipsTemp = avocat_blips
end)

RegisterNetEvent('avocat:deleteBlips')
AddEventHandler('avocat:deleteBlips', function ()
  Avocat_markerBool = false
  for _, item in pairs(avocat_blipsTemp) do
    RemoveBlip(item.blip)
  end
end)

RegisterNetEvent('avocat:marker')
AddEventHandler('avocat:marker', function ()
  Citizen.CreateThread(function ()
    while Avocat_markerBool == true do
      Citizen.Wait(1)
      if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), avocat_blips["Entreprise"].x, avocat_blips["Entreprise"].y, avocat_blips["Entreprise"].z, true) <= avocat_blips["Entreprise"].distanceMarker then
        DrawMarker(1, avocat_blips["Entreprise"].x, avocat_blips["Entreprise"].y, avocat_blips["Entreprise"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
        ClearPrints()
        SetTextEntry_2("STRING")
        if isInServiceAvocat then
          AddTextComponentString("Appuyez sur ~g~E~s~ pour enfiler un ~b~costard")
        else
          AddTextComponentString("Appuyez sur ~g~E~s~ pour retirer votre ~b~costard")
        end
        DrawSubtitleTimed(2000, 1)
        if IsControlJustPressed(1, Keys["E"]) then
          GetServiceAvocat()
        end
      end

      if isInServiceAvocat then
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), avocat_blips["Garage"].x, avocat_blips["Garage"].y, avocat_blips["Garage"].z, true) <= avocat_blips["Garage"].distanceMarker+5 then
          DrawMarker(1, avocat_blips["Garage"].x, avocat_blips["Garage"].y, avocat_blips["Garage"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
          ClearPrints()
          SetTextEntry_2("STRING")
          AddTextComponentString("Appuyez sur ~g~E~s~ pour faire apparaitre/ranger votre ~b~vehicule")
          DrawSubtitleTimed(2000, 1)
          if IsControlJustPressed(1, Keys["E"]) then
            if(existingVeh ~= nil) then
              SetEntityAsMissionEntity(existingVeh, true, true)
              Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(existingVeh))
              existingVeh = nil
            else
              Avocat_InitMenuVehicules()
              Menu.hidden = not Menu.hidden
            end
          end
        end
        Menu.renderGUI()
        if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), avocat_blips["Garage"].x,avocat_blips["Garage"].y,avocat_blips["Garage"].z, true) <= avocat_blips["Garage"].distanceMarker then
          DrawMarker(1,avocat_blips["Garage"].x,avocat_blips["Garage"].y,avocat_blips["Garage"].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.5001, 0, 155, 255, 200, 0, 0, 0, 0)
        end
      end
    end
  end)
end)

function GetServiceAvocat()
local playerPed = GetPlayerPed(-1)
if isInServiceAvocat then
  notif("Vous n\'êtes plus en service")
  TriggerServerEvent("skin_customization:SpawnPlayer")
else
  notif("Début du service")
  TriggerEvent("avocat:getSkin")
end
isInServiceAvocat = not isInServiceAvocat
TriggerServerEvent('avocat:setService', isInServiceAvocat)
end

RegisterNetEvent('avocat:getSkin')
AddEventHandler('avocat:getSkin', function (source)
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

RegisterNetEvent('avocat:getCar')
AddEventHandler('avocat:getCar', function (source)
local vehiculeDetected = GetClosestVehicle(avocat_car.x, avocat_car.y, avocat_car.z, 6.0, 0, 70)
if not DoesEntityExist(vehiculeDetected) then
  local myPed = GetPlayerPed(-1)
  local player = PlayerId()
  local vehicle = GetHashKey('asea')
  RequestModel(vehicle)
  while not HasModelLoaded(vehicle) do
    Wait(1)
  end
  local plate = math.random(10, 90)
  existingVeh = CreateVehicle(vehicle,avocat_car.x, avocat_car.y, avocat_car.z,-50.0, true, false)
  SetVehicleHasBeenOwnedByPlayer(existingVeh,true)
  local id = NetworkGetNetworkIdFromEntity(existingVeh)
  SetNetworkIdCanMigrate(id, true)
  SetEntityInvincible(existingVeh, false)
  SetVehicleOnGroundProperly(existingVeh)
  SetVehicleNumberPlateText(existingVeh, avocat_platesuffix.." "..plate.." ")
  SetModelAsNoLongerNeeded(vehicle)
  Citizen.InvokeNative(0xB736A491E64A32CF, Citizen.PointerValueIntInitialized(existingVeh))
else
  notif("Zone encombrée.")
end
end)
