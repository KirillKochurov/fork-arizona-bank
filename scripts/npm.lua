-- by Cosmo with <3
local ini = require "inicfg"
local cfg = ini.load({ main = { unix = -1, text = nil } }, "npm.ini")

function main()
	repeat wait(0) until isSampAvailable()
	sampRegisterChatCommand("npm", npm_cmd)

	while true do
		if cfg.main.unix > 0 then

			local diff = cfg.main.unix - os.time()
			if diff <= 0 then
				if diff >= -300 then
					sampAddChatMessage("[Напоминание] {EEEEEE}Сработало напоминание!!!", 0xFFDD90)
					sampAddChatMessage("» {EEEEEE}" .. tostring(cfg.main.text), 0xFFDD90)
					BlickColor(1.5, 255, 255, 255, 255)
				else
					sampAddChatMessage("[Напоминание] {EEEEEE}Вы были не в игре, напоминание отключено!", 0xFFDD90)
					sampAddChatMessage("» {EEEEEE}" .. tostring(cfg.main.text), 0xFFDD90)
				end

				warning = nil
				cfg.main.unix = -1
				cfg.main.text = nil
				ini.save(cfg, "npm.ini")
			elseif diff <= 60 and diff >= 10 and not warning then
				sampAddChatMessage("[Напоминание] {EEEEEE}Осталось менее одной минуты..", 0xFFDD90)
				sampAddChatMessage("» {EEEEEE}" .. tostring(cfg.main.text), 0xFFDD90)
				BlickColor(1.5, 255, 255, 255, 50)
				warning = true
			end

		end
		wait(0)
	end
end

function npm_cmd(args)
	if args == "off" then
		if cfg.main.unix > 0 then
			cfg.main.unix = -1
			cfg.main.text = nil
			warning = nil
			sampAddChatMessage("[Напоминание] {EEEEEE}Вы отключили напоминание!", 0xFFDD90)
			ini.save(cfg, "npm.ini")
			return
		end
		sampAddChatMessage("[Ошибка] {EEEEEE}У вас нет активного напоминания!", 0xFF3020)
		return
	end 

	local H, M, text = string.match(args, "^(%d+)[:%s](%d+) (.+)")
	H, M = tonumber(H), tonumber(M)
	if H and M then
		if (H < 0 or H > 23) or (M < 0 or M > 59) then
			sampAddChatMessage("[Ошибка] {EEEEEE}Время указано неверно!", 0xFF3020)
			return
		end

		local datetime = os.date("*t")
		datetime.hour = H
		datetime.min = M
		datetime.sec = 0

		local unix = os.time(datetime)

		-- // Перенос на следующий день
		if unix <= os.time() then
			unix = unix + 86400
		end

		local apply = (cfg.main.unix < 0) and "Установлено" or "Изменено"
		sampAddChatMessage(("[Напоминание] {EEEEEE}%s на {FFDD90}%s"):format(apply, getStrDate(unix)), 0xFFDD90)
		sampAddChatMessage(("[Напоминание] {EEEEEE}Текст напоминания: {FFDD90}%s"):format(text), 0xFFDD90)
		warning = nil
		cfg.main.unix = unix
		cfg.main.text = text
		ini.save(cfg, "npm.ini")
		return
	end
	sampAddChatMessage("[Ошибка] {EEEEEE}Используй: /npm [ ЧЧ:ММ ] [ Текст ] {AAAAAA}(или /npm off чтобы выключить)", 0xFF3020)
	sampAddChatMessage("» Например: /npm 20:00 Подать гос-волну", 0xEEEEEE)
	return
end

function getStrDate(unix)
	unix = unix or os.time()
	local tWeekdays = {[0] = 'Воскресенье', [1] = 'Понедельник', [2] = 'Вторник', [3] = 'Среда', [4] = 'Четверг', [5] = 'Пятница', [6] = 'Суббота'}
    local tMonths = {'января', 'февраля', 'марта', 'апреля', 'мая', 'июня', 'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'}
    local dt = os.date("*t", unix)
    local month = tMonths[dt.month]
    local weekday = tWeekdays[tonumber(os.date('%w', unix))]
    return string.format('%s (%s, %s %s)', os.date('%H:%M', unix), weekday, dt.day, month)
end

function BlickColor(duration, r, g, b, a)
	blick = {
		color = { r, g, b, a },
		duration = duration,
		time = os.clock()
	}
end

function onD3DPresent()
	if blick ~= nil then
		local diff = os.clock() - blick.time
		if diff <= blick.duration and diff > 0 then
			local sW, sH = getScreenResolution()
			local alpha = bringFloatTo(blick.color[4], 0, blick.time, blick.duration)
			local color = join_argb(alpha, blick.color[1], blick.color[2], blick.color[3])
			renderDrawBox(0, 0, sW, sH, color)
		elseif diff <= 0 then
			blick = nil
		end
	end
end

function bringFloatTo(from, to, start_time, duration)
    local timer = os.clock() - start_time
    if timer >= 0.00 and timer <= duration then
        local count = timer / (duration / 100)
        return from + (count * (to - from) / 100), true
    end
    return (timer > duration) and to or from, false
end

function join_argb(a, r, g, b)
    local argb = b
    argb = bit.bor(argb, bit.lshift(g, 8))
    argb = bit.bor(argb, bit.lshift(r, 16))
    argb = bit.bor(argb, bit.lshift(a, 24))
    return argb
end