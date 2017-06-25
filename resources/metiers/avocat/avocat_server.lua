require "resources/essentialmode/lib/MySQL"
MySQL:open(database.host, database.name, database.username, database.password)

RegisterServerEvent('avocat:Car')
AddEventHandler('avocat:Car', function()
  TriggerClientEvent('avocat:getCar',source)
end)

RegisterServerEvent('avocat:setService')
AddEventHandler('avocat:setService', function (inService)
TriggerEvent('es:getPlayerFromId', source , function (Player)
  Player:setSessionVar('avocatInService', inService)
end)
end)
