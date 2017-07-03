RegisterServerEvent('HOSPITAL:released')

AddEventHandler('HOSPITAL:released', function(from)
	local name = GetPlayerName(from)
	TriggerClientEvent('chatMessage', -1, "SYSTEM", {200,0,0}, name.." est sorti de l'hopital.")
end)

RegisterServerEvent('HOSPITAL:reminder')

AddEventHandler('HOSPITAL:reminder', function(from, seconds)
	TriggerClientEvent('chatMessage', from, "SYSTEM", {200,0,0}, "Vous êtes sous surveillance médicale pour encore "..tostring(seconds).." secondes.")
end)


local usageStringHospital = "Usage: /hospital *id* *seconds* *reason*"
local usageStringER = "Usage: /er *id* *hospital* *seconds* *reason*"


AddEventHandler('chatMessage', function(from,name,message)
	if(message:sub(1,1) == "/") then

		local args = splitString(message, " ")
		local cmd = args[1]


		if (cmd == "/hospital" or cmd == '/er') then
			CancelEvent()
			local usageString = usageStringHospital
			local ER = false

			if(cmd == "/er") then
				usageString = usageStringER
				ER = true
			end

			if (args[2] == nil or args[3] == nil or args[4] == nil or (ER and args[5] == nil)) then
				TriggerClientEvent('chatMessage', from, "SYSTEM", {200,0,0}, usageString)
				return
			end

			local playerID = tonumber(args[2])

			if(playerID == nil or GetPlayerName(playerID) == nil) then
				-- Invalid player ID
				TriggerClientEvent('chatMessage', from, "SYSTEM", {200,0,0} , "Invalid PlayerID")
				return
			end

			local userName = GetPlayerName(playerID)
			local hospitalTime = 0
			local hospitalIdentifier = 0

			if (ER) then
				hospitalTime = tonumber(args[4])
				hospitalIdentifier = tonumber(args[3])


				if (hospitalIdentifier == nil) then
					local hospitalText = { paleto = 1,sandy = 2,zonah = 3,pillbox = 4,central = 5}

					local requestText = string.lower(args[3])

					hospitalIdentifier = hospitalText[requestText]

					if(hospitalIdentifier == nil) then
						TriggerClientEvent('chatMessage', from, "SYSTEM", {200,0,0}, usageString)
						return
					end
				end

			else
				hospitalIdentifier = 0
				hospitalTime = tonumber(args[3])
			end

			if(hospitalTime == nil) then
				TriggerClientEvent('chatMessage', from, "SYSTEM", {200,0,0} , usageString)
				return
			end

			if (hospitalTime > 600) then
				hospitalTime = 600
			end

			local hospitalReason = ""

			if (ER) then
				hospitalReason = table.concat(args, " ", 5)
			else
				hospitalReason = table.concat(args, " ", 4)
			end


			local eventMessage = userName.." a été hospitalisé(e) "..tostring(hospitalTime).." secondes pour "..tostring(hospitalReason..".")

			TriggerClientEvent('chatMessage', -1, "SYSTEM", {200,0,0}, eventMessage)

			TriggerClientEvent('HOSPITAL:hospitalize', playerID, hospitalTime, hospitalIdentifier)
		end



	end
end)


function splitString(self, delimiter)
	local words = self:Split(delimiter)
	local output = {}
	for i = 0, #words - 1 do
		table.insert(output, words[i])
	end

	return output
end