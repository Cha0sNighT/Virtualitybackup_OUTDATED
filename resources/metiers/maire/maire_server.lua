require "resources/essentialmode/lib/MySQL"
MySQL:open(database.host, database.name, database.username, database.password)

RegisterServerEvent('maire:Car')
AddEventHandler('maire:Car', function()
  TriggerClientEvent('maire:getCar',source)
end)

RegisterServerEvent('maire:Car2')
AddEventHandler('maire:Car2', function()
  TriggerClientEvent('maire:getCar2',source)
end)

RegisterServerEvent('maire:Car3')
AddEventHandler('maire:Car3', function()
  TriggerClientEvent('maire:getCar3',source)
end)

RegisterServerEvent('maire:setService')
AddEventHandler('maire:setService', function (inService)
TriggerEvent('es:getPlayerFromId', source , function (Player)
  Player:setSessionVar('maireInService', inService)
end)
end)
