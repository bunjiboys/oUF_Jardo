local _, Jardo = ...

function Jardo:round(num, idp)
   local mult = 10 ^ (idp or 0)
   return math.floor(num * mult + 0.5) / mult
end

function Jardo:siValue(val)
	if(val >= 1e6) then
      return Jardo:round(val / 1e6, 1) .. "m"
	elseif(val >= 1e4) then
      return Jardo:round(val / 1e3, 1) .. "k"
	else
		return val
	end
end

function Jardo:ClassColor(unit)
   local r, g, b = 0.8, 0.8, 0.8
   local _, class = UnitClass(unit)
   local ouf_color = oUF.colors.class[class]
   if ouf_color then
      r, g, b = ouf_color[1], ouf_color[2], ouf_color[3]
   end

   return r * 255, g * 255, b * 255
end

function Jardo:DifficultyColor(unit)
   local level = UnitLevel(unit)
   if level == -1 or not level then
      level = 999
   end
   local color = GetQuestDifficultyColor(level)
   return color.r * 255, color.g * 255, color.b * 255
end
