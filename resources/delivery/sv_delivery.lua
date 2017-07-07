require "resources/essentialmode/lib/MySQL"


function nameJob(player)
  local executed_query = MySQL:executeQuery("SELECT identifier, job_id, job_name FROM users LEFT JOIN jobs ON jobs.job_id = users.job WHERE users.identifier = '@identifier'", {['@identifier'] = player})
  local result = MySQL:getResults(executed_query, {'job_name'}, "identifier")
  return tostring(result[1].job_name)
end



RegisterServerEvent('delivery:checkjob')
AddEventHandler('delivery:checkjob', function()
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    local namejob = nameJob(player)

    if namejob == "Facteur" then --here you change the jobname (from your database)
      TriggerClientEvent('yesdelivery', source)
    else
      TriggerClientEvent('nodelivery', source)
    end
  end)
end)


--Essential payment functions 

RegisterServerEvent('delivery:success')
AddEventHandler('delivery:success', function(price)
 print("Player ID " ..source)
	-- Get the players money amount
TriggerEvent('es:getPlayerFromId', source, function(user)
 total = price;
 -- update player money amount
 user:addMoney((total))
 end)
end)

RegisterServerEvent('delivery:fail')
AddEventHandler('delivery:fail', function(price)
 print("Player ID " ..source)
	-- Get the players money amount
TriggerEvent('es:getPlayerFromId', source, function(user)
 total = price;
 -- update player money amount
 user:addMoney((total))
 end)
end)