local se = require "samp.events"
local ini = require "inicfg"

local cfg = ini.load({
	time = {
		value = 12,
		lock = false
	},
	weather = {
		value = 1,
		lock = false
	}
}, "Climate.ini")

function se.onSetWeather(id)
	if cfg.weather.lock then
		return false
	end
end

function se.onSetPlayerTime(hour, min)
	if cfg.time.lock then
		return false
	end
end

function se.onSetWorldTime(hour)
	if cfg.time.lock then
		return false
	end
end

function se.onSetSpawnInfo( ... )
	if cfg.time.lock then 
		setWorldTime(cfg.time.value) 
	end
	if cfg.weather.lock then 
		setWorldWeather(cfg.weather.value) 
	end
end 

function main()
	repeat wait(0) until isSampAvailable()
	sampRegisterChatCommand("st", setWorldTime)
	sampRegisterChatCommand("sw", setWorldWeather)
	sampRegisterChatCommand("bt", toggleFreezeTime)
	sampRegisterChatCommand("bw", toggleFreezeWeather)
	wait(-1)
end

function setWorldTime(hour)
	hour = tonumber(hour)
	if hour ~= nil and (hour >= 0 and hour <= 23) then
		local bs = raknetNewBitStream()
		raknetBitStreamWriteInt8(bs, hour)
		raknetEmulRpcReceiveBitStream(94, bs)
		raknetDeleteBitStream(bs)

		cfg.time.value = hour
		ini.save(cfg, "Climate.ini")
		return nil
	end
	sampAddChatMessage("Используйте: {EEEEEE}/st [0 - 23]", 0xFFDD90)
end

function setWorldWeather(id)
	id = tonumber(id)
	if id ~= nil and (id >= 0 and id <= 45) then
		local bs = raknetNewBitStream()
		raknetBitStreamWriteInt8(bs, id)
		raknetEmulRpcReceiveBitStream(152, bs)
		raknetDeleteBitStream(bs)

		cfg.weather.value = id
		ini.save(cfg, "Climate.ini")
		return nil
	end
	sampAddChatMessage("Используйте: {FFDD90}/sw [0 - 45]", 0xEEEEEE)
end

function toggleFreezeTime()
	cfg.time.lock = not cfg.time.lock
	if ini.save(cfg, "Climate.ini") then
		sampAddChatMessage("Изменение времени сервером: " .. (cfg.time.lock and "{FFAAAA}Выключено" or "{AAFFAA}Включено"), 0xEEEEEE)
	end
end

function toggleFreezeWeather()
	cfg.weather.lock = not cfg.weather.lock
	if ini.save(cfg, "Climate.ini") then
		sampAddChatMessage("Изменение погоды сервером: " .. (cfg.weather.lock and "{FFAAAA}Выключено" or "{AAFFAA}Включено"), 0xEEEEEE)
	end
end