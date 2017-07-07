require "resources/essentialmode/lib/MySQL"




function idJob(player)
  local executed_query = MySQL:executeQuery("SELECT identifier, job_id, job_name FROM users LEFT JOIN jobs ON jobs.job_id = users.job WHERE users.identifier = '@identifier'", {['@identifier'] = player})
  local result = MySQL:getResults(executed_query, {'job_id'}, "identifier")
  return tostring(result[1].job_id)
end





function updateCoffre(player, prixavant,prixtotal,prixajoute)
  MySQL:executeQuery("UPDATE coffrelspd SET `solde`='@prixtotal' , identifier = '@identifier' , lasttransfert = '@prixajoute' WHERE solde = '@prixavant' AND id = '1' ",{['@prixtotal'] = prixtotal, ['@identifier'] = player ,['@prixajoute'] = prixajoute,['@prixavant'] = prixavant })

end

function GetSolde()
  local executed_query = MySQL:executeQuery("SELECT solde FROM coffrelspd WHERE id ='1'")
  local result = MySQL:getResults(executed_query, {'solde'})
  return tostring(result[1].solde)
end


function ajoutAmendeToCoffre(amount)
  MySQL:executeQuery("UPDATE coffrelspd SET `solde`='@amount' WHERE id = '1' ",{['@amount'] = amount })
end




RegisterServerEvent('coffrelspd:amendecoffre')
AddEventHandler('coffrelspd:amendecoffre', function(amount)
  local solde = GetSolde()
  local amount = amount
  local total = amount + solde
  ajoutAmendeToCoffre(total)
  TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Accuse de reception", false, "Vous avez rajouter : "..amount.." ~g~€")
  
end)


RegisterServerEvent('coffrelspd:getsolde')
AddEventHandler('coffrelspd:getsolde',function()

  local data = GetSolde()
  print(data)
  TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Coffre police", false, "Solde restant : "..data.."~g~€")


end)








RegisterServerEvent('coffrelspd:ajoutsolde')
AddEventHandler('coffrelspd:ajoutsolde',function(ajout)
TriggerEvent('es:getPlayerFromId', source, function(user)

    local player = user.identifier
    local idjob = idJob(player)
 
 -- Here change id Job (allowed to withdraw/deposit )
    if(idjob == '2'or idjob =='5')then
      local prixavant = GetSolde()
      local prixajoute = ajout
      local prixtotal = prixavant+prixajoute
     
      print(player)
      print(prixavant)
      print(prixajoute)
      print(prixtotal)

      if((user.money - prixajoute)>=0)then
     
        user:removeMoney((prixajoute))

        updateCoffre(player,prixavant,prixtotal,prixajoute)
        TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Accuse de reception", false, "Vous avez rajouter : "..prixajoute.." ~g~€")
      else
         TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Attention", false, "~r~Vous n'avez pas assez d'argent !")

      end
    else
      TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Attention", false, "~r~Vous n'avez pas la permisison !")
    end
end)
end)






RegisterServerEvent('coffrelspd:retirersolde')
AddEventHandler('coffrelspd:retirersolde',function(ajout)
TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    local idjob = idJob(player)
 -- Here change id Job (allowed to withdraw/deposit )
    if(idjob == '19' or idjob =='18')then


      local prixavant = GetSolde()
      local prixenleve = ajout
      local prixtotal = prixavant-prixenleve
     
      print(player)
      print(prixavant)
      print(prixenleve)
      print(prixtotal)
    

      if(prixtotal<-1)then
        TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Attention", false, "~r~Coffre vide !")
        
      else
        

        updateCoffre(player,prixavant,prixtotal,prixenleve)
        user:addMoney((prixenleve))
        TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Accuse de reception", false, "Vous avez enlever : "..prixenleve.." ~r~€")
      end
    else
      TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Attention", false, "~r~Vous n'avez pas la permisison !")
    end


end)
end)



