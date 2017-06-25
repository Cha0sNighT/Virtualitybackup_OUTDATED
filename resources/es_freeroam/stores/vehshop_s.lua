require "resources/essentialmode/lib/MySQL"
MySQL:open(database.host, database.name, database.username, database.password)

RegisterServerEvent('CheckMoneyForVeh')
AddEventHandler('CheckMoneyForVeh', function(vehicle, price)
	TriggerEvent('es:getPlayerFromId', source, function(user)

	if (tonumber(user.money) >= tonumber(price)) then
    local player = user.identifier
    print(player)
			-- Pay the shop (price)
			user:removeMoney((price))
      -- Save this shit to the database
      MySQL:executeQuery("UPDATE users SET personalvehicle='@vehicle' WHERE identifier = '@username'",
      {['@username'] = player, ['@vehicle'] = vehicle})
      -- Trigger some client stuff
      TriggerClientEvent('FinishMoneyCheckForVeh',source)
      TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "Simeon", false, "Drive safe with this new car, this is not Carmageddon!\n")
    else
      -- Inform the player that he needs more money
    TriggerClientEvent("es_freeroam:notify", source, "CHAR_SIMEON", 1, "Simeon", false, "You dont have enough cash to buy this car!\n")
	end
end)
end)
