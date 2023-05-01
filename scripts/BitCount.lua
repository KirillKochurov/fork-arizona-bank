-- by Cosmo with <3
local se = require "samp.events"

function se.onShowDialog(id, style, title, but_1, but_2, text)
	if id == 25250 and title:find("Купить BTC") then
		local rate = string.match(text, "Банк продаёт BTC по курсу {%x+}1 BTC = %$([%d%p]+)")
		if rate ~= nil then
		    rate = rate:gsub("%p", "")
			local count = math.floor(getPlayerMoney(PLAYER_HANDLE) / tonumber(rate))
			if count == 0 then
				text = text .. "\n\n{FFFF00}Ваших денег недостаточно для покупки BTC!"
				return { id, style, title, but_1, but_2, text }	
			end
			count = separate(count)
			text = text .. ("\n\n{CCCCCC}Ваших денег хватает на {FFFF00}%s{CCCCCC} BTC"):format(count)
			return { id, style, title, but_1, but_2, text }
		end
	elseif id == 25248 and title:find("Продать BTC") then
		local count = string.match(text, "У вас есть: ([%d%p]+) BTC")
		local rate = string.match(text, "Банк покупает BTC по курсу {%x+}1 BTC = %$([%d%p]+)")
		if count and rate then
		    count = count:gsub("%p", "") 
            rate = rate:gsub("%p", "")
			if tonumber(count) == 0 then
				text = text .. "\n\n{FFFF00}У вас нет BTC для продажи!"
				return { id, style, title, but_1, but_2, text }	
			end
			local sum = separate(tonumber(rate) * tonumber(count))
			text = text .. ("\n\n{CCCCCC}У вас BTC на сумму: {FFFF00}$%s"):format(sum)
			return { id, style, title, but_1, but_2, text }
		end
	end
end

function separate(text, sign, only_price)
	sign = sign or "."
	local _text = tostring(text):gsub("{%x+}", "")

	local rule = only_price and "%$" or ""
	for int in string.gmatch(_text, rule .. "%-*[0-9]+") do
		if int:len() > 3 then
			local result = string.gsub(int:reverse(), "%d%d%d", "%1" .. sign)
			result = string.gsub(result:reverse(), "^%" .. sign, "")
			text = string.gsub(text, int, result, 1)
		end
	end
	return text
end
