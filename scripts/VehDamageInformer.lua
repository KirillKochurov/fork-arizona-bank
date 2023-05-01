-- by Cosmo with <3
local se = require "samp.events"
local id, health, damage, timer

function se.onSendVehicleSync(data)
	if id == nil or id ~= data.vehicleId then 
		health = data.vehicleHealth
		id = data.vehicleId
		return
	end
	if health ~= data.vehicleHealth then
		if timer == nil or (os.clock() - timer > 3) then 
			damage, timer = 0, os.clock()
		end
		damage = damage + (data.vehicleHealth - health)
		health = data.vehicleHealth
		if math.abs(damage) >= 1.00 then
			local text = string.format("%s%d HP (%d)", (damage > 0 and "~g~+" or "~r~"), damage, health)
			local offset = string.rep("~n~", 10)
			printStyledString(offset .. text, 3000, 4)
		end
	end
end