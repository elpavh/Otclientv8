setDefaultTab("Tools")
UI.Separator()

local info = setupUI(configINFO)

info.label2:setText("v" .. VERSION)

macro(300, function(macro)
    local color = randomCOLORS[math.random(#randomCOLORS)]
    info.label1:setColor(color)
    info.label2:setColor(color)
    info.label3:setColor(color)
end)

UI.Separator()
local autoStairs = {1948}
macro(20, "Auto Stairs", "Shift+A", function()
    for x = -1, 1 do
        for y = -1, 1 do
            local tile = g_map.getTile({x = posx() + x, y = posy() + y, z = posz()})
            if tile then
                local things = tile:getThings()
                for _, item in pairs(things) do
                    if table.find(autoStairs, item:getId()) then
                        g_game.use(item)
                    end
                end
            end
        end
    end
end)

UI.Separator()

macro(500, "Smarter targeting", function() 
  local battlelist = getSpectators();
  local closest = 10
  local lowesthpc = 101
  for key, val in pairs(battlelist) do
    if val:isMonster() then
      if getDistanceBetween(player:getPosition(), val:getPosition()) <= closest then
        closest = getDistanceBetween(player:getPosition(), val:getPosition())
        if val:getHealthPercent() < lowesthpc then
          lowesthpc = val:getHealthPercent()
        end
      end
    end
  end
  for key, val in pairs(battlelist) do
    if val:isMonster() then
      if getDistanceBetween(player:getPosition(), val:getPosition()) <= closest then
        if g_game.getAttackingCreature() ~= val and val:getHealthPercent() <= lowesthpc then 
          g_game.attack(val)
          break
        end
      end
    end
  end
end)

UI.Separator()
macro(100, "Follow Attack","SHIFT+Q",function(macro1)
  if not macro1:isOn() then
    g_keyboard.pressKey("Escape")
    return
end
  if g_game.getAttackingCreature() then
    g_game.setChaseMode(1)
    g_game.setFightMode(1)
  end
end)
UI.Separator()
local deadBodys = {"dead", "remains", "slains"}
local lootItems = {688, 17012, 5809, 3151, 3199, 3183, 3194, 7883, 3335, 11701, 4033, 18203, 141, 3187, 9655, 12805, 3163, 11686, 11473, 11475, 6531, 3184, 3169, 669, 3556,
9306, 10385, 3186, 9653, 11468, 10200, 14684, 788, 9645, 11478, 8096, 14760, 2869, 4033, 12670, 11691, 11486, 16344, 16110, 16105, 13994, 13993, 22733, 22729, 10344, 11455,
27082, 9304, 9301, 9302, 9303, 12669, 24704, 1781, 12730, 3040, 10278,
2865, 3253, 10327, 5926, 5466, 9611, 6542, 10387,18287}

macro(100, "Loot Red","SHIFT+F2", function()
    for i, container in pairs(getContainers()) do
        for _, corpse in ipairs(deadBodys) do
            if container:getName():lower():find(corpse) then
                for __, item in ipairs(container:getItems()) do
                    if table.find(lootItems, item:getId()) then
                        return g_game.move(item, {x=65535, y=SlotBack, z=0}, item:getCount())
                    end
                end
            end
        end
    end
end)
UI.Separator()

local c = {
	pickUp = {688, 17012, 5809, 3151, 3199, 3183, 3194, 7883, 3335, 11701, 4033, 18203, 141, 3187, 9655, 12805, 3163, 11686, 11473, 11475, 6531, 3184, 3169, 669, 3556,
	9306, 10385, 3186, 9653, 11468, 10200, 14684, 788, 9645, 11478, 8096, 14760, 2869, 4033, 12670, 11691, 11486, 16344, 16110, 16105, 13994, 13993, 22733, 22729, 10344, 11455,
	27082, 9304, 9301, 9302, 9303, 12669, 24704, 1781, 12730, 3040, 10278,
	2865, 3253, 10327, 5926, 5466, 9611, 6542, 10387,18287}, -- Item list to pickup, separated by a comma.
	CheckPOS = 1 -- The SQM from your character to check if theres an item.
}
macro(20, "Free Items", "SHIFT+0", function()
	for x = -storage.freeItemsPosCheck, storage.freeItemsPosCheck do
		for y = -storage.freeItemsPosCheck, storage.freeItemsPosCheck do
			local tile = g_map.getTile({x = posx() + x, y = posy() + y, z = posz()})
			if tile then
				local things = tile:getThings()
				for _, item in pairs(things) do
					if table.find(c.pickUp, item:getId()) then
						local containers = getContainers()
						for _, container in pairs(containers) do
							g_game.move(item, container:getSlotPosition(container:getItemsCount()), item:getCount())
						end
					end
				end
			end
		end
	end
end)

addTextEdit("freeItemsPosCheck", storage.freeItemsPosCheck or "2", function(widget, text)    
	storage.freeItemsPosCheck = text
end)

UI.Separator()

local c = {
	pickUp = {688, 17012, 5809, 3151, 3199, 3183, 3194, 7883, 3335, 11701, 4033, 18203, 141, 3187, 9655, 12805, 3163, 11686, 11473, 11475, 6531, 3184, 3169, 669, 3556,
	9306, 10385, 3186, 9653, 11468, 10200, 14684, 788, 9645, 11478, 8096, 14760, 2869, 4033, 12670, 11691, 11486, 16344, 16110, 16105, 13994, 13993, 22733, 22729, 10344, 11455,
	27082, 9304, 9301, 9302, 9303, 12669, 24704, 1781, 12730, 3040, 10278,
	2865, 3253, 10327, 5926, 5466, 9611, 6542, 10387,18287,3577,3579,3590,3589,3586,3582,3581,8016,5096,3585,3587,3597,3603,229,7373,7374,7375,7376,7377,6392,904,8013,7366,7368,3287,3447,3507,
  774,763,762,761,675,676,678,677,3028,5921,8017,3602,9057,3591,3741,9636,10296,12252,11448,3043,6097}, -- Item list to pickup, separated by a comma.
	CheckPOS = 1 -- The SQM from your character to check if theres an item.
}
macro(20, "Anti-Push", "SHIFT+P", function()
	for x = -storage.freeItemsPosCheck, storage.freeItemsPosCheck do
		for y = -storage.freeItemsPosCheck, storage.freeItemsPosCheck do
			local tile = g_map.getTile({x = posx() + x, y = posy() + y, z = posz()})
			if tile then
				local things = tile:getThings()
				for _, item in pairs(things) do
					if table.find(c.pickUp, item:getId()) then
						local containers = getContainers()
						for _, container in pairs(containers) do
							g_game.move(item, container:getSlotPosition(container:getItemsCount()), item:getCount())
						end
					end
				end
			end
		end
	end
end)
addTextEdit("freeItemsPosCheck", storage.freeItemsPosCheck or "2", function(widget, text)    
	storage.freeItemsPosCheck = text
end)
UI.Separator()
macro(2500, "Activar Minas", "SHIFT+X", function()
    for i, tile in ipairs(g_map.getTiles(posz())) do
      for u,item in ipairs(tile:getItems()) do
        if (item and item:getId() == 2862) then
          g_game.use(item)
          return
        end
      end  
    end
end)
UI.Separator()
-- local ahora5 = '!activa "banderasrandom'
-- local banderasrandom = macro(100, 'banderasrandom', 'SHIFT+O', function() end)
-- onTextMessage(function(mode, text)
--   if banderasrandom.isOn() then
--     if not text:find(ahora5:lower()) then return end
--     say '!concurso "banderasrandom'
--   end
-- end)
local ahora = '!activa "banderasrandom'
local banderasrandom = macro(100, 'banderasrandom', '', function() end)
onTalk(function(name, level, mode, text, channelId, pos)
  if banderasrandom.isOn() then
    if not text:lower():find(ahora:lower()) then return end
    say '!concurso "banderasrandom'
  end
end)

UI.Separator()

local ahora = "**************** AHORA MORROS ****************"

local sillas = macro(100, 'sillas', 'SHIFT+6', function() end)
onTextMessage(function(mode, text)
   if sillas.isOn() then
    if not text:lower():find(ahora:lower()) then return end
  for i, tile in ipairs(g_map.getTiles(posz())) do
      for u,item in ipairs(tile:getItems()) do
          if (item:getId() == 1999 or item:getId() == 5022) then
            autoWalk(tile:getPosition(), 1, {ignoreNonPathable = true})
          end
        end
    end
	  end
end)

UI.Separator()

macro(500, "walter", "SHIFT+8", function()
	NPC.say("adivinar")
	schedule((2000), function() NPC.say("13") end)
	delay(math.random(3500, 3500))
end)

UI.Separator()
-- local function calculateResult(n1, n2, charOperation)
--   if charOperation == "/" then
--     return n1 / n2
--   elseif charOperation == "*" then
--     return n1 * n2
--   elseif charOperation == "+" then
--     return n1 + n2
--   elseif charOperation == "-" then
--     return n1 - n2
--   end
-- end

-- local regex = "([0-9]+) ([^)]+) ([0-9]+)"
-- local re = regexMatch(text, regex)
-- local Materapidas = macro(100, 'Materapidas', 'SHIFT+P', function() end)
-- onTextMessage(function(mode, text)
--   if Materapidas.isOn() then
--     if not text:lower():match(regex) then return end
--     local n1, n2 = tonumber(re[1][2]), tonumber(re[1][4])
--     local result = calculateResult(n1, n2, charOperation)
--     say('!r "'..result)
--   end
-- end)
-- local Materapidas = macro(100, 'Materapidas', 'SHIFT+P', function() end)
-- local function calculateResult(n1, n2, charOperation)
--   if charOperation == "/" then
--     return n1 / n2
--   elseif charOperation == "*" then
--     return n1 * n2
--   elseif charOperation == "+" then
--     return n1 + n2
--   elseif charOperation == "-" then
--     return n1 - n2
--   end
-- end

-- onTextMessage(function(mode, text)
--   if Materapidas.isOn() then
--     local regex = "([0-9]+) ([^)]+) ([0-9]+)"
--     local re = {text:lower():match(regex)}
--     if not re[1] then return end
--     local n1, n2 = tonumber(re[1]), tonumber(re[3])
--     local charOperation = re[2]
--     local result = calculateResult(n1, n2, charOperation)
--     say('!r "'..result)
--   end
-- end)

UI.Separator()
local key = "F10" 
local Medusaid = 3151
local squaresThreshold = 1 

-- script
singlehotkey(key, "MEDUSA target", function()
  local target = g_game.getAttackingCreature()
  if target then
    local targetPos = target:getPosition()
    local targetDir = target:getDirection()
    local mwallTile
    if targetDir == 0 then -- north
      targetPos.y = targetPos.y - squaresThreshold
      mwallTile = g_map.getTile(targetPos)
      useWith(Medusaid, mwallTile:getTopUseThing())
    elseif targetDir == 1 then -- east
      targetPos.x = targetPos.x + squaresThreshold
      mwallTile = g_map.getTile(targetPos)
      useWith(Medusaid, mwallTile:getTopUseThing())
    elseif targetDir == 2 then -- south
      targetPos.y = targetPos.y + squaresThreshold
      mwallTile = g_map.getTile(targetPos)
      useWith(Medusaid, mwallTile:getTopUseThing())
    elseif targetDir == 3 then -- west
      targetPos.x = targetPos.x - squaresThreshold
      mwallTile = g_map.getTile(targetPos)
      useWith(Medusaid, mwallTile:getTopUseThing())
    elseif targetDir == 4 then -- northeast
      targetPos.x = targetPos.x + squaresThreshold
      targetPos.y = targetPos.y - squaresThreshold
      mwallTile = g_map.getTile(targetPos)
      useWith(Medusaid, mwallTile:getTopUseThing())
    elseif targetDir == 5 then -- southeast
      targetPos.x = targetPos.x + squaresThreshold
      targetPos.y = targetPos.y + squaresThreshold
      mwallTile = g_map.getTile(targetPos)
      useWith(Medusaid, mwallTile:getTopUseThing())
    elseif targetDir == 6 then -- southwest
      targetPos.x = targetPos.x - squaresThreshold
      targetPos.y = targetPos.y + squaresThreshold
      mwallTile = g_map.getTile(targetPos)
      useWith(Medusaid, mwallTile:getTopUseThing())
    elseif targetDir == 7 then -- northwest
      targetPos.x = targetPos.x - squaresThreshold
      targetPos.y = targetPos.y - squaresThreshold
      mwallTile = g_map.getTile(targetPos)
      useWith(Medusaid, mwallTile:getTopUseThing())
    end
  end
end)
UI.Separator()

local ahora3 = 'ha activado el concurso: blackjack. Para entrar di: !concurso "blackjack. Al entrar se te cobraran 3 fichas de casino.'
local blackjack = macro(100, 'blackjack', 'SHIFT+P', function() end)
onTextMessage(function(mode, text)
  if blackjack.isOn() then
    if not text:lower():find(ahora3:lower()) then return end
    say '!concurso "blackjack'
  end
end)

UI.Separator()

local key = "F11" 
singlehotkey(key, "Closest Enemy target", function()
  local battlelist = getSpectators();
  local closest = 10
  local lowesthpc = 101
  for key2, val in pairs(battlelist) do
    if val:isPlayer() and val ~= g_game.getLocalPlayer() then
      if getDistanceBetween(player:getPosition(), val:getPosition()) <= closest then
        closest = getDistanceBetween(player:getPosition(), val:getPosition())
        if val:getHealthPercent() < lowesthpc then
          lowesthpc = val:getHealthPercent()
        end
      end
    end
  end
  for key2, val in pairs(battlelist) do
    if val:isPlayer() and val ~= g_game.getLocalPlayer() then
      if getDistanceBetween(player:getPosition(), val:getPosition()) <= closest then
        if g_game.getAttackingCreature() ~= val and val:getHealthPercent() <= lowesthpc then 
          g_game.attack(val)
          break
        end
      end
    end
  end
end)

UI.Separator()