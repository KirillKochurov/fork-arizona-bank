require 'moonloader'
local sampev = require 'lib.samp.events'

function main()
    if not isSampLoaded() or not isSampfuncsLoaded() then return end
    while not isSampAvailable() do wait(80) end
    
    while true do

    wait(0)
    end
end

function sampev.onServerMessage(clr, msg)
	local id = msg:match('.+%[(%d+)%] говорит:{B7AFAF}')
	if tonumber(id) then 
		local clist = sampGetPlayerColor(tonumber(id))
		local a, r, g, b = explode_argb(clist)
		return { join_argb(r, g, b, a), msg }
	end
end

function explode_argb(argb)
  local a = bit.band(bit.rshift(argb, 24), 0xFF)
  local r = bit.band(bit.rshift(argb, 16), 0xFF)
  local g = bit.band(bit.rshift(argb, 8), 0xFF)
  local b = bit.band(argb, 0xFF)
  return a, r, g, b
end

function join_argb(a, r, g, b)
  local argb = b  -- b
  argb = bit.bor(argb, bit.lshift(g, 8))  -- g
  argb = bit.bor(argb, bit.lshift(r, 16)) -- r
  argb = bit.bor(argb, bit.lshift(a, 24)) -- a
  return argb
end