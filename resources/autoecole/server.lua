--[[Info]]--

require "resources/mysql-async/lib/MySQL"



--[[Register]]--

RegisterServerEvent("ply_autoecole:GetLicences")
RegisterServerEvent("ply_autoecole:CheckForPermis")
RegisterServerEvent("ply_autoecole:SetLicence")



--[[Function]]--

function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

function licenceID(permis_id)  
    local permis_id = permis_id
    local user = getPlayerID(source)
    return MySQL.Sync.fetchScalar("SELECT licence_id FROM user_licence WHERE identifier=@identifier and licence_id=@licence_id",{['@identifier'] = user, ['@licence_id'] = permis_id})
end



--[[Local/Global]]--

permis = {}



--[[Events]]--

AddEventHandler("ply_autoecole:GetLicences", function()
    permis = {}
    local user = getPlayerID(source)    
    local theme = "Conduire"
    MySQL.Async.fetchAll("SELECT * FROM autoecole",{}, function(data)
        for _, v in ipairs(data) do
            t = {["name"] = v.name, ["id"] = v.id}
            table.insert(permis, tonumber(v.id), t)
        end
        TriggerClientEvent("ply_autoecole:GetLicences", source, permis) 
    end)
end)

AddEventHandler("ply_autoecole:CheckForPermis", function(permis_id)
    local user = getPlayerID(source)    
    local permis_id = permis_id
    local licence_id = licenceID(permis_id) 
    if licence_id > 0 then
        TriggerClientEvent("ply_autoecole:StartPermisFalse", source)
    else
        MySQL.Async.fetchAll("SELECT * FROM autoecole WHERE id = @id",{['@id'] = permis_id}, function(data)
            TriggerClientEvent("ply_autoecole:StartPermisTrue", source, data[1].id, data[1].name, data[1].vehicle, data[1].end_x, data[1].end_y, data[1].end_z)
        end)
    end
end)

AddEventHandler("ply_autoecole:SetLicence", function(permis_id)
    permis = {}
    local user = getPlayerID(source)   
    MySQL.Async.fetchAll("SELECT * FROM autoecole",{}, function(data)
        for _, v in ipairs(data) do
            t = {["name"] = v.name, ["id"] = v.id}
            table.insert(permis, tonumber(v.id), t)
        end
        TriggerClientEvent("ply_autoecole:GetLicences", source, permis) 
    end)
end)

AddEventHandler("ply_autoecole:SetLicence", function(licID)
    local licID = licID
    local user = getPlayerID(source)
    MySQL.Async.execute("INSERT INTO user_licence (identifier,licence_id) VALUES (@identifier,@licID)",{['@identifier'] = user, ['@licID'] = licID}, function(data)
    end)
end)