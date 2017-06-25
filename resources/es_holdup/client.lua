local holdingup = false
local store = ""
local secondsRemaining = 0

local stores = {
	["paleto_twentyfourseven"] = {
		position = { ['x'] = 1730.35949707031, ['y'] = 6416.7001953125, ['z'] = 35.0372161865234 },
		reward = math.random(1500, 3000),
		nameofstore = "Twenty Four Seven. (Paleto Bay)",
		lastrobbed = 0
	},
	["sandyshores_twentyfoursever"] = {
		position = { ['x'] = 1960.4197998047, ['y'] = 3742.9755859375, ['z'] = 32.343738555908 },
		reward = math.random(1500, 3000),
		nameofstore = "Twenty Four Seven. (Sandy Shores)",
		lastrobbed = 0
	},
	["bar_one"] = {
		position = { ['x'] = 1986.1240234375, ['y'] = 3053.8747558594, ['z'] = 47.215171813965 },
		reward = math.random(1500, 3000),
		nameofstore = "Yellow Jack. (Sandy Shores)",
		lastrobbed = 0
	},
	["littleseoul_twentyfourseven"] = {
		position = { ['x'] = -709.17022705078, ['y'] = -904.21722412109, ['z'] = 19.215591430664 },
		reward = math.random(1500, 3000),
		nameofstore = "Twenty Four Seven. (Little Seoul)",
		lastrobbed = 0
	}
}

function Chat(t)
	TriggerEvent("chatMessage", 'HOLDUP', { 0, 255, 255}, "" .. tostring(t))
end

RegisterNetEvent('es_holdup:currentlyrobbing')
AddEventHandler('es_holdup:currentlyrobbing', function(robb)
	holdingup = true
	store = robb
	secondsRemaining = 180
end)

RegisterNetEvent('es_holdup:toofarlocal')
AddEventHandler('es_holdup:toofarlocal', function(robb)
	holdingup = false
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Braquage annulé, tu ne recevras rien !")
	robbingName = ""
	secondsRemaining = 0
	incircle = false
end)

RegisterNetEvent('es_holdup:notifycop2')
AddEventHandler('es_holdup:notifycop2', function(text)
	if exports.metiers:getIsInService() == true then 
		SetNotificationTextEntry('STRING')
		AddTextComponentString(text)
		DrawNotification(false, false)
		
	end
end)


RegisterNetEvent('es_holdup:robberycomplete')
AddEventHandler('es_holdup:robberycomplete', function(robb)
	holdingup = false
	TriggerEvent('chatMessage', 'SYSTEM', {255, 0, 0}, "Bravo ! tu as gagné: ^2" .. stores[store].reward)
	store = ""
	secondsRemaining = 0
	incircle = false
end)

Citizen.CreateThread(function()
	while true do
		if holdingup then
			Citizen.Wait(1000)
			if(secondsRemaining > 0)then
				secondsRemaining = secondsRemaining - 1
			end
		end

		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
	for k,v in pairs(stores)do
		local ve = v.position

		local blip = AddBlipForCoord(ve.x, ve.y, ve.z)
		SetBlipSprite(blip, 437)
		SetBlipScale(blip, 0.8)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Braquage de Magasin")
		EndTextCommandSetBlipName(blip)
	end
end)
local incircle = false

Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)

		for k,v in pairs(stores)do
			local pos2 = v.position

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 15.0)then
				if not holdingup then
					DrawMarker(1, v.position.x, v.position.y, v.position.z - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 1.5001, 1555, 0, 0,255, 0, 0, 0,0)
					
					if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) < 1.0)then
						if (incircle == false) then
							DisplayHelpText("~INPUT_CONTEXT~ pour cambrioler ~b~" .. v.nameofstore .. "~w~ la police va être prevenue!")
						end
						incircle = true
						if(IsControlJustReleased(1, 51))then
							if exports.metiers:getIsInService() == true then
								DisplayHelpText("Tu es policier tu ne peux pas cambrioler")
								TriggerEvent('chatMessage', "", {0, 255, 0}, "tu es policier tu ne peux pas cambrioler");
							else
								TriggerServerEvent('es_holdup:stestcop',k)
								TriggerServerEvent('es_holdup:notifycop',v.nameofstore)
							end
						end
					elseif(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 1.0)then
						incircle = false
					end
				end
			end
		end

		if holdingup then

			drawTxt(0.66, 1.44, 1.0,1.0,0.4, "Cambriolage : ~r~" .. secondsRemaining .. "~w~ secondes restantes", 255, 255, 255, 255)
			
			local pos2 = stores[store].position
			DrawMarker(1, pos2.x, pos2.y, pos2.z - 1, 0, 0, 0, 0, 0, 0, 10.0, 10.0, 0.2, 1555, 0, 0,255, 0, 0, 0,0)

			if(Vdist(pos.x, pos.y, pos.z, pos2.x, pos2.y, pos2.z) > 5)then
				TriggerServerEvent('es_holdup:toofar', store)
			end
		end
		Citizen.Wait(0)
	end
end)








function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end