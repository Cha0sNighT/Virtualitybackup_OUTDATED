local stores = {
	["paleto_twentyfourseven"] = {
		position = { ['x'] = 1730.35949707031, ['y'] = 6416.7001953125, ['z'] = 35.0372161865234 },
		reward = 5000,
		nameofstore = "Twenty Four Seven. (Paleto Bay)",
		lastrobbed = 0
	},
	["sandyshores_twentyfoursever"] = {
		position = { ['x'] = 1960.4197998047, ['y'] = 3742.9755859375, ['z'] = 32.343738555908 },
		reward = 5000,
		nameofstore = "Twenty Four Seven. (Sandy Shores)",
		lastrobbed = 0
	},
	["bar_one"] = {
		position = { ['x'] = 1986.1240234375, ['y'] = 3053.8747558594, ['z'] = 47.215171813965 },
		reward = 5000,
		nameofstore = "Yellow Jack. (Sandy Shores)",
		lastrobbed = 0
	},
	["littleseoul_twentyfourseven"] = {
		position = { ['x'] = -709.17022705078, ['y'] = -904.21722412109, ['z'] = 19.215591430664 },
		reward = 5000,
		nameofstore = "Twenty Four Seven. (Little Seoul)",
		lastrobbed = 0
	}
}

local robbers = {}


function get3DDistance(x1, y1, z1, x2, y2, z2)
	return math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2) + math.pow(z1 - z2, 2))
end

RegisterServerEvent('es_holdup:toofar')
AddEventHandler('es_holdup:toofar', function(robb)
	if(robbers[source])then
		TriggerClientEvent('es_holdup:toofarlocal', source)
		robbers[source] = nil
		TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Braquage annulé à : ^2" .. stores[robb].nameofstore)
	end
end)

RegisterServerEvent('es_holdup:stestcop')
AddEventHandler('es_holdup:stestcop', function(k)
	getPoliceInService( function(nbPolice) 
	TriggerEvent('es_holdup:rob',k,nbPolice,source)
	end)
end)

RegisterServerEvent('es_holdup:notifycop')
AddEventHandler('es_holdup:notifycop', function(storename)

	TriggerClientEvent('es_holdup:notifycop2',-1, "braquage en cours a : " .. storename .. ".")

end)


RegisterServerEvent('es_holdup:rob')
AddEventHandler('es_holdup:rob', function(robb,nbPolice,source)
	if nbPolice >= 3 then
		if stores[robb] then
			local store = stores[robb]

			if (os.time() - store.lastrobbed) < 600 and store.lastrobbed ~= 0 then
				TriggerClientEvent('chatMessage', source, 'BRAQUAGE', {255, 0, 0}, "Ce store à déja été cambriolé: ^2" .. (1800 - (os.time() - store.lastrobbed)) .. "^0 secondes.")
				return
			end
			TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Braquage en cours ^2" .. store.nameofstore)
			TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "vous avez commncer un braquage à ^2" .. store.nameofstore .. "^0, ne vous éloignez pas du magazin")
			TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "L'alarme à été déclanchée !")
			TriggerClientEvent('chatMessage', source, 'SYSTEM', {255, 0, 0}, "tenez la position pendant ^13 ^0minutes et empochez l'argent")
			TriggerClientEvent('es_holdup:currentlyrobbing', source, robb)
			stores[robb].lastrobbed = os.time()
			robbers[source] = robb
			local savedSource = source
			SetTimeout(180000, function()
				if(robbers[savedSource])then
					TriggerClientEvent('es_holdup:robberycomplete', savedSource, job)
					TriggerEvent('es:getPlayerFromId', savedSource, function(target) 
						if(target)then
						target:addDirty_Money(store.reward) 
						TriggerClientEvent('chatMessage', -1, 'NEWS', {255, 0, 0}, "Braquage fini à : ^2" .. store.nameofstore)
						end
					end)
				end
			end)		
		end
	else
		TriggerClientEvent('chatMessage', source, 'HOLDUP', {255, 0, 0}, "Pas assez de policiers en ligne")
	end
end)



function getPoliceInService(cb)
	TriggerEvent('es:getPlayers', function(players)
		local nbPolice = 0
		for i,p in pairs(players) do
			if p:getSessionVar('policeInService') == true then
				nbPolice = nbPolice + 1
			end
		end
		cb(nbPolice)
	end)
end