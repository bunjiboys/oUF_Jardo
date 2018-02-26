local _, Jardo = ...

local PostUpdateHealth = function(health, unit, min, max)
    local self = health:GetParent()

    if(UnitIsDead(unit)) then
        health:SetValue(0)
    elseif(UnitIsGhost(unit)) then
        health:SetValue(0)
    end
end

local PostUpdatePower = function(power, unit, min, max)
    if(UnitIsDead(unit) or UnitIsGhost(unit)) then
        power:SetValue(0)
    end
end

function Jardo:RaidIcon(self)
    local RaidIcon = self.Health:CreateTexture(nil, 'OVERLAY')
    RaidIcon:SetSize(20, 20)
    if side == 'left' then
        RaidIcon:SetPoint('CENTER', self, 'TOP', 0, 0)
    else
        RaidIcon:SetPoint('CENTER', self, 'TOP', 0, 0)
    end
    self.RaidIcon = RaidIcon
end

function Jardo:RoleIcon(self, side)
    local Role = self.Health:CreateTexture(nil, 'OVERLAY')
    Role:SetSize(16, 16)
    if side == 'left' then
        Role:SetPoint('CENTER', self, 'TOPLEFT', 16, 0)
    else
        Role:SetPoint('CENTER', self, 'TOPRIGHT', -16, 0)
    end
    self.LFDRole = Role
end

function Jardo:RaidStatusIcon(self, side)
    local Leader = self.Health:CreateTexture(nil, 'OVERLAY')
    local Assistant = self.Health:CreateTexture(nil, 'OVERLAY')
    Leader:SetSize(16, 16)
    Assistant:SetSize(16, 16)
    if side == 'left' then
        Leader:SetPoint('CENTER', self, 'TOPRIGHT', -16, 0)
        Assistant:SetPoint('CENTER', self, 'TOPRIGHT', -16, 0)
    else
        Leader:SetPoint('CENTER', self, 'TOPLEFT', 16, 0)
        Assistant:SetPoint('CENTER', self, 'TOPLEFT', 16, 0)
    end

    self.Leader = Leader
    self.Assistant = Assistant
end

function Jardo:PvPIcon(showTimer, parent, point, anchor, relPoint, x, y)
    local frame = parent.Health:CreateTexture(nil, 'OVERLAY')
    frame:SetSize(32, 32)
    frame:SetPoint(point, anchor, relPoint, x, y)
    parent.PvP = frame

    if showTimer then
        local timer = parent:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
        if x < 0 then
            timer:SetPoint('LEFT', frame:GetParent(), 'RIGHT', 5, 0)
        else
            timer:SetPoint('RIGHT', frame:GetParent(), 'LEFT', -5, 0)
        end
        timer:SetFont(Jardo.Font, 12)
        timer:SetTextColor(1, 0, 0)

        parent.PvP.Timer = timer
    end
end

function Jardo:PowerBar(self, showInfo)
    -- Power bar
    local Power = CreateFrame('StatusBar', nil, self)
    Power:SetHeight(14)
    Power:SetStatusBarTexture(Jardo.Texture)
    Power:SetPoint('BOTTOM', 0, 1)
    Power:SetPoint('LEFT', 1, 0)
    Power:SetPoint('RIGHT', -1, 0)
    Power.colorPower = true
    Power.frequentUpdates = true

    -- Power bar background
    local PowerBackground = Power:CreateTexture(nil, 'BORDER')
    PowerBackground:SetAllPoints(Power)
    PowerBackground:SetAlpha(1)
    PowerBackground:SetTexture(Jardo.Texture)
    PowerBackground.multiplier = 0.5
    Power.bg = PowerBackground

    -- Power bar values
    local PowerPoints = Power:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    PowerPoints:SetPoint('RIGHT', -2, 1)
    PowerPoints:SetJustifyH('CENTER')
    PowerPoints:SetFont(Jardo.Font, 11)
    PowerPoints:SetTextColor(1, 1, 1)
    Power.value = PowerPoints
    Power.PostUpdate = PostUpdatePower

    if showInfo then
        local Info = Power:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
        Info:SetPoint('LEFT', 2, 1)
        Info:SetJustifyH('LEFT')
        Info:SetFont(Jardo.Font, 11)
        Info:SetTextColor(1, 1, 1)

        self:Tag(Info, '[jardo:class]')
        self.Info = Info
    end

    self.Power = Power
    self:Tag(PowerPoints, '[jardo:power]')
end

function Jardo:ClassPower(self)
    local ClassPower = {}
    for index = 1, 10 do
        local bar = CreateFrame('StatusBar', nil, self)
        bar:SetSize(12, 12)
        if index == 1 then
            bar:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', 0, 2)
        else
            bar:SetPoint('BOTTOMLEFT', self, 'TOPLEFT', index * (bar:GetWidth() + 4) - bar:GetWidth(), 2)
        end

        ClassPower[index] = bar
    end

    self.ClassPower = ClassPower
end

function Jardo:CastBar(self, unit)
    local Castbar = CreateFrame('StatusBar', nil, self)
    Castbar:SetStatusBarTexture(Jardo.Texture)
    Castbar:SetStatusBarColor(1, 0.7, 0, .8)
    Castbar:SetPoint('LEFT', self, 1, 0)
    Castbar:SetPoint('RIGHT', self, -1, 0)
    Castbar:SetPoint('TOP', self, 'BOTTOM', 1, 0)
    Castbar:SetHeight(14)
    Castbar:SetToplevel(true)

    local Spark = Castbar:CreateTexture(nil, 'OVERLAY')
    Spark:SetSize(20, 40)
    Spark:SetBlendMode('ADD')

    local CastbarBackground = Castbar:CreateTexture(nil, 'BORDER')
    CastbarBackground:SetAllPoints(Castbar)
    CastbarBackground:SetTexture(0.1, 0.1, 0.1, 0.65)
    CastbarBackground:Hide()
    CastbarBackground.multiplier = 0.5

    local Spell = Castbar:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    Spell:SetPoint(Jardo.anchors[unit].name.anchor, Jardo.anchors[unit].name.x, Jardo.anchors[unit].name.y)
    Spell:SetJustifyH(Jardo.anchors[unit].name.anchor)
    Spell:SetFont(Jardo.Font, 12)
    Spell:SetTextColor(1, 1, 1)

    local CastTime = Castbar:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    CastTime:SetPoint(Jardo.anchors[unit].info.anchor, Jardo.anchors[unit].info.x, Jardo.anchors[unit].info.y)
    CastTime:SetJustifyH(Jardo.anchors[unit].info.anchor)
    CastTime:SetFont(Jardo.Font, 12)
    CastTime:SetTextColor(1, 1, 1)

    Castbar.bg = CastbarBackground
    Castbar.Text = Spell
    Castbar.Time = CastTime
    Castbar.Spark = Spark
    self.Castbar = Castbar

    local bgshow = function(...) CastbarBackground:Show() end
    local bghide = function(...) CastbarBackground:Hide() end

    Castbar.PostCastStart = bgshow
    Castbar.PostCastStop = bghide
    Castbar.PostChannelStart = bgshow
    Castbar.PostChannelStop = bghide

    Castbar.CustomTimeText = function(self, duration)
        if self.casting then
            self.Time:SetFormattedText('%.1f / %.1f', self.max - duration, self.max)
        else
            self.Time:SetFormattedText('%.1f / %.1f', duration, self.max)
        end
    end
end

function Jardo:IncomingHeals(self, invert)
    local createBar = function (parent, point, invert)
        local bar = CreateFrame('StatusBar', nil, parent)
        bar:SetStatusBarTexture(Jardo.Texture)
        bar:SetStatusBarColor(0, 1, 0.5, 0.25)
        bar:SetWidth(200)

        if invert == true then
            bar:SetPoint('TOPRIGHT', point, 'TOPLEFT', 0, 0)
            bar:SetPoint('BOTTOMRIGHT', point, 'BOTTOMLEFT', 0, 0)
            bar:SetReverseFill(invert)
        else
            bar:SetPoint('TOPLEFT', point, 'TOPRIGHT', 0, 0)
            bar:SetPoint('BOTTOMLEFT', point, 'BOTTOMRIGHT', 0, 0)
        end

        return bar
    end

    local own = createBar(self.Health, self.Health:GetStatusBarTexture(), invert)
    local other = createBar(self.Health, own:GetStatusBarTexture(), invert)
    local absorb = createBar(self.Health, other:GetStatusBarTexture(), invert)
    local healAbsorb = createBar(self.Health, absorb:GetStatusBarTexture(), invert)
    local overAbsorb = createBar(self.Health, healAbsorb:GetStatusBarTexture(), invert)
    local overHealAbsorb = createBar(self.Health, overAbsorb:GetStatusBarTexture(), invert)

    self.HealthPrediction = {
        myBar = own,
        otherBar = other,
        absorbBar = absorb,
        healAbsorbBar = healAbsorb,
        overAbsorb = overAbsorb,
        overHealAbsorb = overHealAbsorb,
        maxOverflow = 1.25,
        frequentUpdates = true,
    }
end

function Jardo:Resting(self)
    local RestingIndicator = self:CreateTexture(nil, 'OVERLAY')
    RestingIndicator:SetPoint('LEFT', self.Health, 'RIGHT', 0, 0)
    RestingIndicator:SetSize(30, 28)

    self.RestingIndicator = RestingIndicator
end

local Boss = function(self, unit, isSingle)
    self:SetScript('OnEnter', UnitFrame_OnEnter)
    self:SetScript('OnLeave', UnitFrame_OnLeave)
    self:RegisterForClicks('AnyUp')

    self:SetBackdrop(Jardo.backdrop)
    self:SetBackdropColor(0, 0, 0, 1)
    self:SetBackdropBorderColor(0, 0, 0, 0)
    self:SetSize(200, 48)
    self:SetAlpha(0.8)

    -- Health bar
    local Health = CreateFrame('StatusBar', nil, self)
    Health:SetStatusBarTexture(Jardo.Texture)
    Health:SetHeight(36)

    Health:SetPoint('TOP', 0, -1)
    Health:SetPoint('LEFT', 1, 0)
    Health:SetPoint('RIGHT', -1, 0)

    Health.frequentUpdates = false
    Health.colorDisconnected = false
    Health.colorTapping = false
    Health.colorSmooth = false
    Health.PostUpdate = PostUpdateHealth
    self.Health = Health

    local HealthPoints = Health:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    HealthPoints:SetPoint(Jardo.anchors[unit].info.anchor, Jardo.anchors[unit].info.x, Jardo.anchors[unit].info.y)
    HealthPoints:SetJustifyH(Jardo.anchors[unit].info.anchor)
    HealthPoints:SetFont(Jardo.Font, 12)
    HealthPoints:SetTextColor(1, 1, 1)
    self:Tag(HealthPoints, '[dead][offline][jardo:shorthealth]')
    Health.value = HealthPoints

    -- Health bar background
    local HealthBackground = Health:CreateTexture(nil, 'BORDER')
    HealthBackground:SetAllPoints(Health)
    HealthBackground:SetTexture(0.1, 0.1, 0.1, 1)
    Health.bg = HealthBackground

    -- Unit name
    local Name = Health:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    Name:SetPoint(Jardo.anchors[unit].name.anchor, Jardo.anchors[unit].name.x, Jardo.anchors[unit].name.y)
    Name:SetJustifyH(Jardo.anchors[unit].name.anchor)
    Name:SetFont(Jardo.Font, 14)
    Name:SetTextColor(1, 1, 1)

    -- Combat text
    local cbt = Health:CreateFontString(nil, 'OVERLAY')
    cbt:SetPoint('CENTER', Health, 'CENTER', 0, 0)
    cbt:SetFont(Jardo.Font, 12, 'OUTLINE')
    cbt.maxAlpha = 1
    cbt.colors = Jardo.cbtColors
    self.CombatFeedbackText = cbt

    self:Tag(Name, '[jardo:name]')
    self.Name = Name

    Jardo:RaidIcon(self)
    Jardo:PowerBar(self, false)
    self.Power:SetHeight(10)
end

local FocusTT = function(self, unit, isSingle)
    self:SetScript('OnEnter', UnitFrame_OnEnter)
    self:SetScript('OnLeave', UnitFrame_OnLeave)
    self:RegisterForClicks('AnyUp')

    self:SetBackdrop(Jardo.backdrop)
    self:SetBackdropColor(0, 0, 0, 1)
    self:SetBackdropBorderColor(0, 0, 0, 0)
    self:SetSize(175, 26)
    self:SetAlpha(0.8)

    -- Health bar
    local Health = CreateFrame('StatusBar', nil, self)
    Health:SetStatusBarTexture(Jardo.Texture)
    Health:SetHeight(24)

    Health:SetPoint('TOP', 0, -1)
    Health:SetPoint('LEFT', 1, 0)
    Health:SetPoint('RIGHT', -1, 0)
    Health:SetPoint('BOTTOM', 0, 1)

    Health.frequentUpdates = true
    Health.colorDisconnected = false
    Health.colorTapping = false
    Health.colorSmooth = false
    Health.PostUpdate = PostUpdateHealth
    self.Health = Health

    local HealthPoints = Health:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    HealthPoints:SetPoint(Jardo.anchors[unit].info.anchor, Jardo.anchors[unit].info.x, Jardo.anchors[unit].info.y)
    HealthPoints:SetJustifyH(Jardo.anchors[unit].info.anchor)
    HealthPoints:SetFont(Jardo.Font, 12)
    HealthPoints:SetTextColor(1, 1, 1)
    self:Tag(HealthPoints, '[dead][offline][jardo:shorthealth]')
    Health.value = HealthPoints

    -- Health bar background
    local HealthBackground = Health:CreateTexture(nil, 'BORDER')
    HealthBackground:SetAllPoints(Health)
    HealthBackground:SetTexture(0.1, 0.1, 0.1, 1)
    Health.bg = HealthBackground

    -- Unit name
    local Name = Health:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    Name:SetPoint(Jardo.anchors[unit].name.anchor, Jardo.anchors[unit].name.x, Jardo.anchors[unit].name.y)
    Name:SetJustifyH(Jardo.anchors[unit].name.anchor)
    Name:SetFont(Jardo.Font, 14)
    Name:SetTextColor(1, 1, 1)

    -- Combat text
    local cbt = Health:CreateFontString(nil, 'OVERLAY')
    cbt:SetPoint('CENTER', Health, 'CENTER', 0, 0)
    cbt:SetFont(Jardo.Font, 12, 'OUTLINE')
    cbt.maxAlpha = 1
    cbt.colors = Jardo.cbtColors
    self.CombatFeedbackText = cbt

    self:Tag(Name, '[jardo:name]')
    self.Name = Name

    Jardo:RaidIcon(self)
end

local Pet = function(self, unit, isSingle)
    FocusTT(self, unit, isSingle)
    self:SetSize(200, 30)
    self.Health:SetHeight(28)
end

local PlayerTarget = function(self, unit, isSingle)
    self:SetScript('OnEnter', UnitFrame_OnEnter)
    self:SetScript('OnLeave', UnitFrame_OnLeave)

    self:RegisterForClicks('AnyUp')

    self:SetBackdrop(Jardo.backdrop)
    self:SetBackdropColor(0, 0, 0, 1)
    self:SetBackdropBorderColor(0, 0, 0, 0)
    self:SetSize(260, 58)

    -- Health bar
    local Health = CreateFrame('StatusBar', nil, self)
    Health:SetStatusBarTexture(Jardo.Texture)
    Health:SetHeight(42)
    Health:SetReverseFill(Jardo.anchors[unit].reverse)
    Health:SetPoint('TOP', 0, -1)
    Health:SetPoint('LEFT', 1, 0)
    Health:SetPoint('RIGHT', -1, 0)
    Health.frequentUpdates = true
    Health.colorDisconnected = false
    Health.colorTapping = false
    Health.colorSmooth = false
    Health.PostUpdate = PostUpdateHealth
    self.Health = Health

    local HealthPoints = Health:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    HealthPoints:SetPoint(Jardo.anchors[unit].info.anchor, Jardo.anchors[unit].info.x, Jardo.anchors[unit].info.y)
    HealthPoints:SetJustifyH(Jardo.anchors[unit].info.anchor)
    HealthPoints:SetFont(Jardo.Font, 14)
    HealthPoints:SetTextColor(1, 1, 1)
    self:Tag(HealthPoints, '[dead][offline][jardo:health]')
    Health.value = HealthPoints

    -- Health bar background
    local HealthBackground = Health:CreateTexture(nil, 'BORDER')
    HealthBackground:SetAllPoints(Health)
    HealthBackground:SetTexture(0.1, 0.1, 0.1, 1)
    HealthBackground.multiplier = 0.5
    Health.bg = HealthBackground

    -- Combat text
    local cbt = Health:CreateFontString(nil, 'OVERLAY')
    cbt:SetPoint('CENTER', Health, 'CENTER', 0, 0)
    cbt:SetFont(Jardo.Font, 16, 'OUTLINE')
    cbt.maxAlpha = 1
    cbt.colors = Jardo.cbtColors
    self.CombatFeedbackText = cbt
 
    -- Unit name
    local Name = Health:CreateFontString(nil, 'OVERLAY', 'GameFontNormal')
    Name:SetPoint(Jardo.anchors[unit].name.anchor, Jardo.anchors[unit].name.x, Jardo.anchors[unit].name.y)
    Name:SetJustifyH(Jardo.anchors[unit].name.anchor)
    Name:SetFont(Jardo.Font, 16)
    Name:SetTextColor(1, 1, 1)

    self:Tag(Name, '[jardo:name]')
    self.Name = Name

    Jardo:PowerBar(self, unit ~= 'player')
    Jardo:RaidIcon(self)

    if unit == 'player' then
		Jardo:Resting(self)
        Jardo:IncomingHeals(self, true)
        Jardo:CastBar(self, unit)
        Jardo:ClassPower(self)
        Jardo:PvPIcon(true, self, 'TOPLEFT', Health, 'TOPRIGHT', -8, 10)
        Jardo:RoleIcon(self, 'right')
        Jardo:RaidStatusIcon(self, 'right')
    else
        Jardo:IncomingHeals(self, false)
        Jardo:PvPIcon(false, self, 'TOPRIGHT', Health, 'TOPLEFT', 20, 10)
        Jardo:RoleIcon(self, 'left')
        Jardo:RaidStatusIcon(self, 'left')
    end

    self.colors = Jardo.colors
end

local DoBuffs = function(self, unit)
    -- Buffs
    local point, relPoint, x, y, growth, anchor = unpack(Jardo.auraAnchors[unit].buff)
    local Buffs = CreateFrame('Frame', nil, self)
    Buffs:SetPoint(point, self, relPoint, x, y)
    Buffs:SetWidth(95)
    Buffs:SetHeight(22)

    Buffs.initialAnchor = anchor
    Buffs.size = 22
    Buffs.num = 6
    Buffs.spacing = 4
    Buffs.showDebuffType = true
    Buffs.showBuffType = true
    Buffs['growth-x'] = growth

    Buffs.PostUpdateIcon = function(buffs, unit, icon, index, offset)
        icon.overlay:SetVertexColor(0, 0.8, 0, 1)
    end

    Buffs.PostCreateIcon = function(buffs, button)
        button.overlay:SetTexture('Interface/AddOns/oUF_Jardo/textures/border.tga')
        button.overlay:SetPoint('TOPLEFT', button.icon, 'TOPLEFT', -2, 2)
        button.overlay:SetPoint('BOTTOMRIGHT', button.icon, 'BOTTOMRIGHT', 2, -2)
        button.overlay:SetTexCoord(0, 1, 0, 1)
        button.icon:SetTexCoord(.07, .93, .07, .93)
    end

    self.Buffs = Buffs
end

local DoDebuffs = function(self, unit)
    -- Debuffs
    local point, relPoint, x, y, growth, anchor = unpack(Jardo.auraAnchors[unit].debuff)
    local Debuffs = CreateFrame('Frame', nil, self)
    Debuffs:SetPoint(point, self, relPoint, x, y)
    Debuffs:SetHeight(22)
    Debuffs:SetWidth(95)

    Debuffs.initialAnchor = anchor
    Debuffs['growth-x'] = growth
    Debuffs.size = 22
    Debuffs.showDebuffType = true
    Debuffs.num = 4

    Debuffs.PostCreateIcon = function(buffs, button)
        button.overlay:SetTexture('Interface/AddOns/oUF_Jardo/textures/border.tga')
        button.overlay:SetPoint('TOPLEFT', button.icon, 'TOPLEFT', -2, 2)
        button.overlay:SetPoint('BOTTOMRIGHT', button.icon, 'BOTTOMRIGHT', 2, -2)
        button.overlay:SetTexCoord(0, 1, 0, 1)

        button.icon:SetTexCoord(.07, .93, .07, .93)
    end

    self.Debuffs = Debuffs
end

local UnitSpecific = {
    player = function(self, ...)
        PlayerTarget(self, ...)
        DoDebuffs(self, 'player')
    end,

    target = function(self, ...)
        PlayerTarget(self, ...)

        DoBuffs(self, 'target')
        DoDebuffs(self, 'target')
    end,

    targettarget = function(self, ...)
        FocusTT(self, ...)
    end,

    focus = function(self, ...)
        FocusTT(self, ...)
        DoDebuffs(self, 'focus')
    end,

    pet = function(self, ...)
        Pet(self, ...)
    end,
}

for idx = 1, MAX_BOSS_FRAMES do
    UnitSpecific['boss' .. idx] = function(self, unit, isSingle)
        Boss(self, unit, isSingle)
    end
end

oUF:RegisterStyle('Jardo', PlayerTarget)
for unit,layout in next, UnitSpecific do
    -- Capitalize the unit name, so it looks better.
    oUF:RegisterStyle('Jardo - ' .. unit:gsub('^%l', string.upper), layout)
end

-- A small helper to change the style into a unit specific, if it exists.
local spawnHelper = function(self, unit, ...)
    if (UnitSpecific[unit]) then
        self:SetActiveStyle('Jardo - ' .. unit:gsub('^%l', string.upper))
    else
        self:SetActiveStyle('Jardo')
    end

    local object = self:Spawn(unit)
    object:SetPoint(...)
    return object
end

oUF:Factory(function(self)
    local player = spawnHelper(self, 'player', 'BOTTOM', UIParent, 'BOTTOM', -325, 260)
    local target = spawnHelper(self, 'target', 'BOTTOM', UIParent, 'BOTTOM', 325, 260)
    spawnHelper(self, 'pet', 'BOTTOM', UIParent, 'BOTTOM', 0, 260)
    spawnHelper(self, 'focus', 'BOTTOMRIGHT', player, 'TOPLEFT', -15, 15)
    spawnHelper(self, 'targettarget', 'BOTTOMLEFT', target, 'TOPRIGHT', 15, 15)
    local offset = 0
    for idx = 1, MAX_BOSS_FRAMES do
        spawnHelper(self, 'boss' .. idx, 'LEFT', UIParent, 'LEFT', 10, offset * 55)
        offset = offset + 1
    end
    oUF:DisableBlizzard('raid')
end)

local testRestore = {}
local testActive = false
SlashCmdList['LT'] = function()
   if testActive == true then
      for _, frame in pairs(oUF.objects) do
         frame.Hide = testRestore[frame].hide
         frame.Name:SetText(testRestore[frame].name)
         testRestore[frame] = nil
         frame.Health:ForceUpdate()
      end
      testActive = false
   else
      for _, frame in pairs(oUF.objects) do
         testRestore[frame] = {
            hide = frame.Hide,
            name = frame.Name:GetText(),
            health = frame.Health:GetMinMaxValues()
         }
         frame.Name:SetText(frame.unit)
         local min, max = frame.Health:GetMinMaxValues()
         if max == 0 then
            max = math.random(50000, 375000)
         end
         frame.Health:SetMinMaxValues(min, max)
         frame.Health:SetValue(math.random(math.floor(max / 3), max))
         frame.Hide = function() return end
         frame:Show()
      end
      testActive = true
   end
end
SLASH_LT1 = '/lt'
