local _, Jardo = ...

oUF.Tags.Methods['jardo:shorthealth'] = function(unit)
   local cur = UnitHealth(unit)
   local max = UnitHealthMax(unit)
	return Jardo:round((cur / max) * 100, 1) .. "%"
end

oUF.Tags.Methods['jardo:health'] = function(unit)
   local cur = UnitHealth(unit)
   local max = UnitHealthMax(unit)
	return string.format("%s/%s | %.1f%%", Jardo:siValue(cur), Jardo:siValue(max), (cur / max) * 100)
end

oUF.Tags.Methods['jardo:power'] = function(unit)
	local min, max = UnitPower(unit), UnitPowerMax(unit)
   if max == 0 then return end
	return Jardo:siValue(min) .. '/' .. Jardo:siValue(max)
end

oUF.Tags.Methods['jardo:class'] = function(unit)
   local r, g, b = Jardo:DifficultyColor(unit)
   local cr, cg, cb = Jardo:ClassColor(unit)
   local class = UnitIsPlayer(unit) and UnitClass(unit) or UnitClassBase(unit)
   local level = UnitLevel(unit)

   if level == -1 or not level then
      level = "Boss"
   end

   return string.format("|cff%02x%02x%02x%s|r |cff%02x%02x%02x%s|r", r, g, b, level, cr, cg, cb, class or "Unknown")
end

oUF.Tags.Methods['jardo:name'] = function(unit)
   return string.sub(UnitName(unit), 1, 15)
end

-- Register our tags for the corresponding events for updates
oUF.Tags.Events['jardo:shorthealth'] = oUF.Tags.Events.missinghp
oUF.Tags.Events['jardo:health'] = oUF.Tags.Events.missinghp
oUF.Tags.Events['jardo:power'] = oUF.Tags.Events.missingpp
oUF.Tags.Events['jardo:class'] = oUF.Tags.Events.smartclass
oUF.Tags.Events['jardo:name'] = oUF.Tags.Events.name
