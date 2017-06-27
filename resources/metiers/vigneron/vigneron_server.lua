	require "resources/essentialmode/lib/MySQL"
	MySQL:open(database.host, database.name, database.username, database.password)

	RegisterServerEvent('vigneron:Car')
	AddEventHandler('vigneron:Car', function()
		TriggerClientEvent('vigneron:getCar',source)
	end)

	RegisterServerEvent('vigneron:serverRequest')
	AddEventHandler('vigneron:serverRequest', function (typeRequest)
		TriggerEvent ('es:getPlayerFromId', source, function(user)
			local player = user.identifier

				if typeRequest == "GetRaisin" then
					--print("SELECT quantity FROM user_inventory WHERE item_id="..vigneron_ressourceBase.." AND user_id='@identifier'")
					local query = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id="..vigneron_ressourceBase.." AND user_id='@identifier'", {['@identifier'] = player})
					local result = MySQL:getResults(query, { 'quantity' })
					local qte
					for _, v in ipairs(result) do
						qte = v.quantity
					end
					TriggerClientEvent('vigneron:drawGetRaisin', source, qte)

				elseif typeRequest == "GetVin" then
					local queryBase = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id="..vigneron_ressourceBase.." AND user_id='@identifier'", {['@identifier'] = player})
					local resultBase = MySQL:getResults(queryBase, { 'quantity' })
					local qteVign
					for _, v in ipairs(resultBase) do
						qteVign = v.quantity
					end

					local queryTraite = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id="..vigneron_ressourceTraite.." AND user_id='@identifier'", {['@identifier'] = player})
					local resultTraite = MySQL:getResults(queryTraite, {'quantity'})
					local qteTraite
					for _, v in ipairs(resultTraite) do
						qteTraite = v.quantity
					end
					TriggerClientEvent('vigneron:drawGetVin',source, qteVign, qteTraite)

				elseif typeRequest == "GetChampagne" then
					local queryBase = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id="..vigneron_ressourceBase.." AND user_id='@identifier'", {['@identifier'] = player})
					local resultBase = MySQL:getResults(queryBase, { 'quantity' })
					local qteVign
					for _, v in ipairs(resultBase) do
						qteVign = v.quantity
					end

					local queryTraite2 = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id="..vigneron_ressourceTraite2.." AND user_id='@identifier'", {['@identifier'] = player})
					local resultTraite = MySQL:getResults(queryTraite2, {'quantity'})
					local qteTraite2
					for _, v in ipairs(resultTraite) do
						qteTraite2 = v.quantity
					end
					TriggerClientEvent('vigneron:drawGetChampagne',source, qteVign, qteTraite2)

				elseif typeRequest == "SellVin" then
					local query = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id="..vigneron_ressourceTraite.." AND user_id='@identifier'", {['@identifier'] = player})
					local result = MySQL:getResults(query, {'quantity'})
					local qte
					for _, v in ipairs(result) do
						qte = v.quantity
					end
					TriggerClientEvent('vigneron:drawSellVin', source, qte)

				elseif typeRequest == "SellChampagne" then
					local query = MySQL:executeQuery("SELECT quantity FROM user_inventory WHERE item_id="..vigneron_ressourceTraite2.." AND user_id='@identifier'", {['@identifier'] = player})
					local result = MySQL:getResults(query, {'quantity'})
					local qte2
					for _, v in ipairs(result) do
						qte2 = v.quantity
					end
					TriggerClientEvent('vigneron:drawSellChampagne', source, qte2)
				else
					print('DEBUG : Une erreur de type de requête à été détecté')
				end

		end)
	end)


RegisterServerEvent('vigneron:setService')
AddEventHandler('vigneron:setService', function (inService)
	TriggerEvent('es:getPlayerFromId', source , function (Player)
		Player:setSessionVar('vigneronInService', inService)
	end)
end)
