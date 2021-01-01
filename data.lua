local _, Jardo = ...

Jardo.Texture = 'Interface/AddOns/SharedMedia/statusbar/DarkBottom'
Jardo.Font = 'Interface/AddOns/oUF_Jardo/resources/Myriad.ttf'
Jardo.Border = 'Interface/AddOns/oUF_Jardo/resources/border.tga'

Jardo.backdrop = {
   bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", tile = true, tileSize = 16,
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", edgeSize = 0,
	insets = { left = 0, right = 0, top = 0, bottom = 0 },
}

Jardo.colors = setmetatable({
   health = { .45, .73, .27 },
   power = setmetatable({
      MANA = { .4, .58, .93 },
      RAGE = { .73, .27, .27 },
   }, { __index = oUF.colors.power}),
}, {__index = oUF.colors})

Jardo.cbtColors = setmetatable({
   HEAL = { 0.25, 0.75, 0.25 },
   CRITHEAL = { 0.25, 1, 0.25 },
}, {
   __index = function() return { 1, 0.82, 0 } end,
})

Jardo.anchors = setmetatable({
   player = {
      name = { anchor = "LEFT", x = 2, y = 0 },
      info = { anchor = "RIGHT", x = -2, y = 0 },
      reverse = true,
   },
   target = {
      name = { anchor = "RIGHT", x = -2, y = 0 },
      info = { anchor = "LEFT", x = 2, y = 0 },
      reverse = false,
   },
   focus = {
      name = { anchor = "LEFT", x = 2, y = 0 },
      info = { anchor = "RIGHT", x = -2, y = 0 },
      reverse = true,
   },
   targettarget = {
      name = { anchor = "RIGHT", x = -2, y = 0 },
      info = { anchor = "LEFT", x = 2, y = 0 },
      reverse = false,
   },
   pet = {
      name = { anchor = "LEFT", x = 2, y = 0 },
      info = { anchor = "RIGHT", x = -2, y = 0 },
      reverse = true,
   },
}, {
   __index = function()
      return {
         name = { anchor = "LEFT", x = 2, y = 0 },
         info = { anchor = "RIGHT", x = -2, y = 0 },
         reverse = true,
      }
   end
})

Jardo.auraAnchors = {
   left = {
      buff = { "BOTTOMRIGHT", "TOPRIGHT", -2, 10, "LEFT", "RIGHT" },
      debuff = { "BOTTOMLEFT", "TOPLEFT", 2, 10, "RIGHT", "LEFT" },
   },
   right = {
      buff = { "BOTTOMLEFT", "TOPLEFT", 2, 10, "RIGHT", "LEFT" },
      debuff = { "BOTTOMRIGHT", "TOPRIGHT", -2, 10, "LEFT", "RIGHT" },
   }
}

Jardo.auraAnchors["player"] = Jardo.auraAnchors["left"]
Jardo.auraAnchors["target"] = Jardo.auraAnchors["right"]
Jardo.auraAnchors["pet"] = Jardo.auraAnchors["left"]
Jardo.auraAnchors["focus"] = Jardo.auraAnchors["right"]
Jardo.auraAnchors["targettarget"] = Jardo.auraAnchors["left"]
