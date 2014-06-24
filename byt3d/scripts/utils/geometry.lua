------------------------------------------------------------------------------------------------------------

function InRegion(obj, mx, my)

	local wide = obj.width
	local high = obj.height
	-- check for scale and apply
	if(obj.scalex ~= nil) then wide = wide * obj.scalex end
	if(obj.scaley ~= nil) then high = high * obj.scaley end

	if obj.left < mx and obj.left + wide > mx and obj.top < my and obj.top + high > my then
		return true
	else
		return false
	end
end

----------------------------------------------------------------

function utf2lat(s)
   local t = {}
   local i = 1
   while i <= #s do
      local c = s:byte(i)
      i = i + 1
      if c < 128 then
         table.insert(t, string.char(c))
      elseif 192 <= c and c < 224 then
         local d = s:byte(i)
         i = i + 1
         if (not d) or d < 128 or d >= 192 then
            return nil, "UTF8 format error"
         end
         c = 64*(c - 192) + (d - 128)
         table.insert(t, string.char(c))
      else
         return nil, "UTF8 Chinese or Greek or something"
      end
   end
   return table.concat(t)
end

------------------------------------------------------------------------------------------------------------