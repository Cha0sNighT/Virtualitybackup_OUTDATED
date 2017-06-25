require "resources/essentialmode/lib/MySQL"
MySQL:open(database.host, database.name, database.username, database.password)

-- HELPER FUNCTIONS
function bankBalance(player)
  local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE identifier = '@name'", {['@name'] = player})
  local result = MySQL:getResults(executed_query, {'bankbalance'}, "identifier")
  return tonumber(result[1].bankbalance)
end

function deposit(player, amount)
  local bankbalance = bankBalance(player)
  local new_balance = bankbalance + amount
  MySQL:executeQuery("UPDATE users SET `bankbalance`='@value' WHERE identifier = '@identifier'", {['@value'] = new_balance, ['@identifier'] = player})
end

function withdraw(player, amount)
  local bankbalance = bankBalance(player)
  local new_balance = bankbalance - amount
  MySQL:executeQuery("UPDATE users SET `bankbalance`='@value' WHERE identifier = '@identifier'", {['@value'] = new_balance, ['@identifier'] = player})
end

function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.abs(math.floor(num * mult + 0.5) / mult)
end

-- Check Bank Balance
TriggerEvent('es:addCommand', 'checkbalance', function(source, args, user)
  TriggerEvent('es:getPlayerFromId', source, function(user)
    local player = user.identifier
    local bankbalance = bankBalance(player)
    TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Votre solde actuel est de: ~g~$".. bankbalance)
    TriggerClientEvent("banking:updateBalance", source, bankbalance)
    CancelEvent()
  end)
end)

-- Bank Deposit
TriggerEvent('es:addCommand', 'deposit', function(source, args, user)
  local amount = ""
  local player = user.identifier
  for i=1,#args do
    amount = args[i]
  end
  TriggerClientEvent('bank:deposit', source, amount)
end)

RegisterServerEvent('bank:deposit')
AddEventHandler('bank:deposit', function(amount)
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local rounded = round(tonumber(amount), 0)
      if(string.len(rounded) >= 9) then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Valeur trop grande^0")
        CancelEvent()
      else
      	if(tonumber(rounded) <= tonumber(user:money)) then
          user:removeMoney((rounded))
          local player = user.identifier
          deposit(player, rounded)
          local new_balance = bankBalance(player)
          TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "depot: ~g~$".. rounded .." ~n~~s~nouveau solde: ~g~$" .. new_balance)
          TriggerClientEvent("banking:updateBalance", source, new_balance)
          TriggerClientEvent("banking:addBalance", source, rounded)
          CancelEvent()
        else
          TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Pas assez d'argent^0")
          CancelEvent()
        end
      end
  end)
end)

-- Bank Withdraw
TriggerEvent('es:addCommand', 'withdraw', function(source, args, user)
  local amount = ""
  local player = user.identifier
  for i=1,#args do
    amount = args[i]
  end
  TriggerClientEvent('bank:withdraw', source, amount)
end)

RegisterServerEvent('bank:withdrawAmende')
AddEventHandler('bank:withdrawAmende', function(amount)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        local bankbalance = bankBalance(player)
		withdraw(player, amount)
		local new_balance = bankBalance(player)
		TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Nouveau solde: ~g~$" .. new_balance)
		TriggerClientEvent("banking:updateBalance", source, new_balance)
		TriggerClientEvent("banking:removeBalance", source, amount)
		CancelEvent()
    end)
end)

RegisterServerEvent('bank:withdraw')
AddEventHandler('bank:withdraw', function(amount)
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local rounded = round(tonumber(amount), 0)
      if(string.len(rounded) >= 9) then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Input too high^0")
        CancelEvent()
      else
        local player = user.identifier
        local bankbalance = bankBalance(player)
        if(tonumber(rounded) <= tonumber(bankbalance)) then
          withdraw(player, rounded)
          user:addMoney((rounded))
          local new_balance = bankBalance(player)
          TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "retrait: ~g~$".. rounded .." ~n~~s~Nouveau solde: ~g~$" .. new_balance)
          TriggerClientEvent("banking:updateBalance", source, new_balance)
          TriggerClientEvent("banking:removeBalance", source, rounded)
          CancelEvent()
        else
          TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Pas assez d'argent sur le compte^0")
          CancelEvent()
        end
      end
  end)
end)

-- Bank Transfer
TriggerEvent('es:addCommand', 'transfer', function(source, args, user)
  local fromPlayer
  local toPlayer
  local amount
  if (args[2] ~= nil and tonumber(args[3]) > 0) then
    fromPlayer = tonumber(source)
    toPlayer = tonumber(args[2])
    amount = tonumber(args[3])
    TriggerClientEvent('bank:transfer', source, fromPlayer, toPlayer, amount)
		else
    TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Faire /transfer [id] [amount]^0")
    return false
  end
end)

RegisterServerEvent('bank:transfer')
AddEventHandler('bank:transfer', function(fromPlayer, toPlayer, amount)
    fromPlayer = source
  if tonumber(fromPlayer) == tonumber(toPlayer) then
    TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Vous ne pouvez pas transferer a vous meme^0")
    CancelEvent()
  else
    TriggerEvent('es:getPlayerFromId', fromPlayer, function(user)
        local rounded = round(tonumber(amount), 0)
        if(string.len(rounded) >= 9) then
          TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Valeur trop grande^0")
          CancelEvent()
        else
          local player = user.identifier
          local bankbalance = bankBalance(player)
				print('Player balance: ' .. bankbalance .. '  Send: ' .. rounded)
          if(tonumber(rounded) <= tonumber(bankbalance)) then
            withdraw(player, rounded)
            local new_balance = bankBalance(player)
            TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Transfere: ~r~-$".. rounded .." ~n~~s~Nouveau solde: ~g~$" .. new_balance)
            TriggerClientEvent("banking:updateBalance", source, new_balance)
            TriggerClientEvent("banking:removeBalance", source, rounded)
            TriggerEvent('es:getPlayerFromId', toPlayer, function(user2)
                local recipient = user2.identifier
                deposit(recipient, rounded)
                new_balance2 = bankBalance(recipient)
                TriggerClientEvent("es_freeroam:notify", toPlayer, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "recu: ~g~$".. rounded .." ~n~~s~Nouveau solde: ~g~$" .. new_balance2)
                TriggerClientEvent("banking:updateBalance", toPlayer, new_balance2)
                TriggerClientEvent("banking:addBalance", toPlayer, rounded)
                CancelEvent()
            end)
            CancelEvent()
          else
            TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Pas assez d'argent sur le compte^0")
            CancelEvent()
          end
        end
    end)
  end
end)

-- Give Cash
TriggerEvent('es:addCommand', 'givecash', function(source, args, user)
  local fromPlayer
  local toPlayer
  local amount
  if (args[2] ~= nil and tonumber(args[3]) > 0) then
    fromPlayer = tonumber(source)
    toPlayer = tonumber(args[2])
    amount = tonumber(args[3])
    TriggerClientEvent('bank:givecash', source, toPlayer, amount)
	else
    TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Faire /givecash [id] [amount]^0")
    return false
  end
end)

TriggerEvent('es:addCommand', 'givedirty', function(source, args, user)
  local fromPlayer
  local toPlayer
  local amount
  if (args[2] ~= nil and tonumber(args[3]) > 0) then
    fromPlayer = tonumber(source)
    toPlayer = tonumber(args[2])
    amount = tonumber(args[3])
    TriggerClientEvent('bank:givedirty', source, toPlayer, amount)
	else
    TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Faire /givedirty [id] [amount]^0")
    return false
  end
end)

RegisterServerEvent('bank:givecash')
AddEventHandler('bank:givecash', function(toPlayer, amount)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if (tonumber(user.money) >= tonumber(amount)) then
			local player = user.identifier
			user:removeMoney(amount)
			TriggerEvent('es:getPlayerFromId', toPlayer, function(recipient)
				recipient:addMoney(amount)
				TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Argent donne: ~r~-$".. amount .." ~n~~s~Porte-feuille: ~g~$" .. user.money)
				TriggerClientEvent("es_freeroam:notify", toPlayer, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Argent recu: ~g~$".. amount .." ~n~~s~Porte-feuille: ~g~$" .. recipient.money)
			end)
		else
			if (tonumber(user.money) < tonumber(amount)) then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Pas assez d'argent^0")
        CancelEvent()
			end
		end
	end)
end)

RegisterServerEvent('bank:givedirty')
AddEventHandler('bank:givedirty', function(toPlayer, amount)
	TriggerEvent('es:getPlayerFromId', source, function(user)
		if (tonumber(user.dirty_money) >= tonumber(amount)) then
			local player = user.identifier
			user:removeDirty_Money(amount)
			TriggerEvent('es:getPlayerFromId', toPlayer, function(recipient)
				recipient:addDirty_Money(amount)
				TriggerClientEvent("es_freeroam:notify", source, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Argent sale donnee: ~r~-$".. amount .." ~n~~s~Porte-feuille: ~g~$" .. user.dirty_money)
				TriggerClientEvent("es_freeroam:notify", toPlayer, "CHAR_BANK_MAZE", 1, "Maze Bank", false, "Argent sale recu: ~g~$".. amount .." ~n~~s~Porte-feuille: ~g~$" .. recipient.dirty_money)
			end)
		else
			if (tonumber(user.dirty_money) < tonumber(amount)) then
        TriggerClientEvent('chatMessage', source, "", {0, 0, 200}, "^1Pas assez d'argent^0")
        CancelEvent()
			end
		end
	end)
end)

AddEventHandler('es:playerLoaded', function(source)
  TriggerEvent('es:getPlayerFromId', source, function(user)
      local player = user.identifier
      local bankbalance = bankBalance(player)
      TriggerClientEvent("banking:updateBalance", source, bankbalance)
    end)
end)
