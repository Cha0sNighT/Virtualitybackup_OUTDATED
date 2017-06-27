TriggerEvent("es:addGroup", "admin", "mod", function(group) end)
TriggerEvent("es:addGroup", "user", "user", function(group) end)

TriggerEvent('es:addGroupCommand', 'dv', "admin" function(source, args, user)
	TriggerClientEvent( 'deleteVehicle', source )
end 
 function(source, args, user)
	TriggerClientEvent('chatMessage', source, "SYSTEM", {255, 0, 0}, "You do not have the permissions to do that!")
end)