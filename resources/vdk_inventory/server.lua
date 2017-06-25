require "resources/essentialmode/lib/MySQL"
MySQL:open(database.host, database.name, database.username, database.password)

RegisterServerEvent("item:getItems")
RegisterServerEvent("item:updateQuantity")
RegisterServerEvent("item:setItem")
RegisterServerEvent("item:reset")
RegisterServerEvent("item:sell")
RegisterServerEvent("item:sellsale")
RegisterServerEvent("player:giveItem")
RegisterServerEvent("player:useItem")

local items = {}

AddEventHandler("item:getItems", function()
    items = {}
    local player = getPlayerID(source)
    local executed_query = MySQL:executeQuery("SELECT * FROM user_inventory JOIN items ON `user_inventory`.`item_id` = `items`.`id` WHERE user_id = '@username'", { ['@username'] = player })
    local result = MySQL:getResults(executed_query, { 'quantity', 'libelle', 'item_id' }, "item_id")
    if (result) then
        for _, v in ipairs(result) do
            t = { ["quantity"] = v.quantity, ["libelle"] = v.libelle }
            table.insert(items, tonumber(v.item_id), t)
        end
    end
    TriggerClientEvent("gui:getItems", source, items)
end)

AddEventHandler("item:setItem", function(item, quantity)
    local player = getPlayerID(source)
    MySQL:executeQuery("INSERT INTO user_inventory (`user_id`, `item_id`, `quantity`) VALUES ('@player', @item, @qty)",
        { ['@player'] = player, ['@item'] = item, ['@qty'] = quantity })
end)

AddEventHandler("item:updateQuantity", function(qty, id)
    local player = getPlayerID(source)
    MySQL:executeQuery("UPDATE user_inventory SET `quantity` = @qty WHERE `user_id` = '@username' AND `item_id` = @id", { ['@username'] = player, ['@qty'] = tonumber(qty), ['@id'] = tonumber(id) })
end)

AddEventHandler("item:reset", function()
    local player = getPlayerID(source)
	TriggerEvent('es:getPlayerFromId', source, function(user)
	local player = user.identifier
    MySQL:executeQuery("UPDATE user_inventory SET `quantity` = @qty WHERE `user_id` = '@username'", { ['@username'] = player, ['@qty'] = 0 })
	user:setMoney(0)
	user:setDirty_Money(0)
	TriggerEvent('gabs:addcustomneeds',source,50 , 50 , 50)
	end)
end)

AddEventHandler("item:sell", function(id, qty, price)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        MySQL:executeQuery("UPDATE user_inventory SET `quantity` = @qty WHERE `user_id` = '@username' AND `item_id` = @id", { ['@username'] = player, ['@qty'] = tonumber(qty), ['@id'] = tonumber(id) })
        user:addMoney(tonumber(price))
    end)
end)

AddEventHandler("item:sellsale", function(id, qty, price)
    TriggerEvent('es:getPlayerFromId', source, function(user)
        local player = user.identifier
        MySQL:executeQuery("UPDATE user_inventory SET `quantity` = @qty WHERE `user_id` = '@username' AND `item_id` = @id", { ['@username'] = player, ['@qty'] = tonumber(qty), ['@id'] = tonumber(id) })
        user:addDirty_Money(tonumber(price))
    end)
end)

AddEventHandler("player:giveItem", function(item, name, qty, target)
    local player = getPlayerID(source)
	local targetid = getPlayerID(target)
    local executed_query = MySQL:executeQuery("SELECT SUM(quantity) as total FROM user_inventory WHERE user_id = '@username'", { ['@username'] = targetid })
    local result = MySQL:getResults(executed_query, { 'total' })
    local total = result[1].total
    if (total + qty < 100) then
        TriggerClientEvent("player:looseItem", source, item, qty)
        TriggerClientEvent("player:receiveItem", target, item, qty)
        TriggerClientEvent("es_freeroam:notify", target, "CHAR_MP_STRIPCLUB_PR", 1, "System", false, "Vous venez de recevoir " .. qty .. " " .. name)
		TriggerClientEvent("es_freeroam:notify", source, "CHAR_MP_STRIPCLUB_PR", 1, "System", false, "Vous venez de donner " .. qty .. " " .. name)
	else
		TriggerClientEvent("es_freeroam:notify", source, "CHAR_MP_STRIPCLUB_PR", 1, "System", false, "quantité trop grande pour l'inventaire du joueur " .. qty .. " " .. name)
    end
	
end)

AddEventHandler("player:useItem", function(item, name, qty)
    local player = getPlayerID(source)
    local executed_query = MySQL:executeQuery("SELECT SUM(quantity) as total FROM user_inventory WHERE user_id = '@username'", { ['@username'] = player })
    local result = MySQL:getResults(executed_query, { 'total' })
    local total = result[1].total
    if menus[item] ~= nil then
		if (total - qty > 0) then
			TriggerEvent('gabs:addcustomneeds', source, menus[item].calories , menus[item].water , menus[item].needs)
			TriggerClientEvent("item:drunk", source , item)
			TriggerClientEvent("player:looseItem", source, item, qty)
			TriggerClientEvent("es_freeroam:notify", source, "CHAR_MP_STRIPCLUB_PR", 1, "System", false, "Vous utilisez " .. qty .. " " .. name)
		end
	else
		TriggerClientEvent("es_freeroam:notify", source, "CHAR_MP_STRIPCLUB_PR", 1, "System", false, "Vous ne pouvez pas utiliser cet item")
	end
end)

-- get's the player id without having to use bugged essentials
function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

-- gets the actual player id unique to the player,
-- independent of whether the player changes their screen name
function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

