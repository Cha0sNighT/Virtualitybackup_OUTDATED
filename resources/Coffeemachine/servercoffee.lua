require "resources/essentialmode/lib/MySQL"
MySQL:open("localhost", "gta5_gamemode_essential", "root", "ntrs1q")

RegisterServerEvent("Coffee_Server")
AddEventHandler("Coffee_Server", function()
	TriggerEvent("es:getPlayerFromId", source, function(target)
	    if (tonumber(target.money) >= 50) then
		TriggerClientEvent("Coffee", source)
		target:removeMoney(50)
		TriggerClientEvent("es_freeroam:notify", source, "CHAR_PROPERTY_BAR_MIRROR_PARK", 1, "Magasin", false, "Café ~g~+1 !\n")
		else
		TriggerClientEvent("es_freeroam:notify", source, "CHAR_PROPERTY_BAR_MIRROR_PARK", 1, "Magasin", false, "~r~Tu n'as pas suffisamment d'argent !\n")
		end
	end)
end)