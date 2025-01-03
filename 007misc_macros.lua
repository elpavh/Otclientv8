-- Locals --
local name = ""..g_game.getCharacterName()..""
local panelName = "miscSetup"

-- Utamo Macro --
macro(100, function()
  if not Misc.get("utamoVita") then return end
  if hasManaShield() then return end
    say("utamo vita")
end)

-- Wall Timers --
local activeTimers = {}
local alreadyCounted = {}
local checkWalls = {2129, 2130, 7931, 7928, 10616}
local walls = {
    [2129] = 20000,
    [2130] = 45300,
    [7931] = 27000,
    [7928] = 27000,
    [10616] = 60000
}

onAddThing(function(tile, thing)
  if not Misc.get("wallTimers") then return end
	if not thing:isItem() then
		return
  end

  if not table.find(checkWalls, thing:getId()) then
    return
  end

  local timer = 0
  local isPutin = false
	for id, time in pairs(walls) do
		if thing:getId() == id then
      timer = time
    end
  end

  if thing:getId() == 10616 then
    isPutin = true
  end

	local pos = tile:getPosition().x .. "," .. tile:getPosition().y .. "," .. tile:getPosition().z
  if not activeTimers[pos] or activeTimers[pos].time < now then
    local total = now + timer
    activeTimers[pos] = {time = total, pos = tile, isPutin = isPutin}
  end
	tile:setTimer(activeTimers[pos].time - now)
end)

onRemoveThing(function(tile, thing)
  if not Misc.get("wallTimers") then return end
	if not thing:isItem() then
		return
  end

  if not table.find(checkWalls, thing:getId()) then
    return
  end

	for id, time in pairs(walls) do
		if thing:getId() == id and tile:getGround() then
			local pos = tile:getPosition().x .. "," .. tile:getPosition().y .. "," .. tile:getPosition().z
			activeTimers[pos] = nil
			tile:setTimer(0)
		end
	end
end)

macro(100, function(macro)
  if not Misc.get("wallTimers") then return end
  for _, wall in pairs(activeTimers) do
    if wall.isPutin then
      local tile = wall.pos
      if tile:getTimer() > 0 then
        if tile:getTimer() < 31000 then
          tile:setTimer(60000)
        end
      end
    end
  end
end)

-- Remover Walls --
local wallIds = {2129, 7928, 7931,24126,7931,7928}
local numpadKeys = {"Numpad9", "Numpad1", "Numpad2", "Numpad3", "Numpad4", "Numpad6", "Numpad7", "Numpad8"}
local wasdKeys = {"W", "A", "S", "D", "Q", "E", "Z", "C"}
local removerID2 = {"17744"}

local function getNextRemoverID(currentID)
  local idIndex = table.find(removerID2, currentID)
  if not idIndex then
    return removerID2[1]
  elseif idIndex == #wallIds then
    return removerID2[1]
  else
    return removerID2[idIndex+1]
  end
end

local function autoRemoveWalls(tile, removerID2)
  if not tile then return end
  if tile then
	  local things = tile:getThings()
	  for _, item in pairs(things) do
      if table.find(wallIds, item:getId()) then
			  usewith(tonumber(removerID2), tile:getTopUseThing())
		  end
	  end
  end
end

onKeyPress(function(keys)
  if not Misc.get("removerStatus") then return end
  if not table.find(wasdKeys, keys) and not table.find(numpadKeys, keys) then return end
  if Misc.get("wasdStatus") then
    if table.find(wasdKeys, keys) then
      local directions = {
        ["W"] = g_map.getTile({x = posx(), y = posy() - 1, z = posz()}),
        ["A"] = g_map.getTile({x = posx() - 1, y = posy(), z = posz()}),
        ["S"] = g_map.getTile({x = posx(), y = posy() + 1, z = posz()}),
        ["D"] = g_map.getTile({x = posx() + 1, y = posy(), z = posz()}),
        ["Q"] = g_map.getTile({x = posx() - 1, y = posy() - 1, z = posz()}),
        ["E"] = g_map.getTile({x = posx() + 1, y = posy() - 1, z = posz()}),
        ["Z"] = g_map.getTile({x = posx() - 1, y = posy() + 1, z = posz()}),
        ["C"] = g_map.getTile({x = posx() + 1, y = posy() + 1, z = posz()})
      }
      local thisWall = directions[keys]
      autoRemoveWalls(thisWall, currentRemoverID)
      currentRemoverID = getNextRemoverID(currentRemoverID)
    end
  elseif not Misc.get("wasdStatus") then
    if table.find(numpadKeys, keys) then
      local directions = {
          ["Numpad8"] = g_map.getTile({x = posx(), y = posy() - 1, z = posz()}),
          ["Numpad4"] = g_map.getTile({x = posx() - 1, y = posy(), z = posz()}),
          ["Numpad2"] = g_map.getTile({x = posx(), y = posy() + 1, z = posz()}),
          ["Numpad6"] = g_map.getTile({x = posx() + 1, y = posy(), z = posz()}),
          ["Numpad7"] = g_map.getTile({x = posx() - 1, y = posy() - 1, z = posz()}),
          ["Numpad9"] = g_map.getTile({x = posx() + 1, y = posy() - 1, z = posz()}),
          ["Numpad1"] = g_map.getTile({x = posx() - 1, y = posy() + 1, z = posz()}),
          ["Numpad3"] = g_map.getTile({x = posx() + 1, y = posy() + 1, z = posz()})
      }
      local thisWall = directions[keys]
      autoRemoveWalls(thisWall, currentRemoverID)
      currentRemoverID = getNextRemoverID(currentRemoverID)
    end
  end
end)

-- Auto Hurs --
macro(1000, function()
  if not Misc.get("utaniHur") then return end
  if hasHaste() then return end
  say(storage[panelName .. name].utaniSpell)
end)

-- Auto Fishing --
local fishingConfig = {
  waterSpots = {633}, -- Water IDs to launch your fishing rod.
  fishingRod = 3483, -- Your fishing rod ID.
  CheckPOS = 5 -- Distance to check water spots to fish (must have the water ID in waterSpots)
}

macro(100, "", function()
  if not Misc.get("fishing") then return end
  for x = -fishingConfig.CheckPOS, fishingConfig.CheckPOS do
      for y = -fishingConfig.CheckPOS, fishingConfig.CheckPOS do
          local tile = g_map.getTile({x = posx() + x, y = posy() + y, z = posz()})
          if tile then
              local things = tile:getThings()
              for _, item in pairs(things) do
                  if table.find(fishingConfig.waterSpots, item:getId()) then
                      local fr = findItem(fishingConfig.fishingRod)
                      g_game.useWith(fr, item)
                  end
              end
          end
      end
  end
end)

-- Click ReUse --
onUseWith(function(pos, itemId, target, subType)
  if not Misc.get("reUse") then return end
  if table.find(storage[panelName .. name].itemsList, itemId) then
    schedule(50, function()
      local item = Item.create(itemId)
      if item then
        modules.game_interface.startUseWith(item)
      end
    end)
  end
end)

-- Mina Detector v2 --
local checkMinas = {6493, 371}
local minasItems = {26077, 26078, 26079}
local configMinas = {
  [6493] = 26079,
  [371] = 26078
}
local minasPosition = {}
onAddThing(function(tile, thing)
  if not Misc.get("verMinas") then return end
	if not thing:isItem() then
		return
  end

  if not table.find(checkMinas, thing:getId()) then
    return
  end

  local pos = tile:getPosition().x .. "," .. tile:getPosition().y .. "," .. tile:getPosition().z
  local newItem = configMinas[thing:getId()]
  if not newItem then
    return error("Mina with the ID: "..thing:getId().." is not correctly configured.")
  end
  local virtualItem = Item.create(newItem)
  tile:addThing(virtualItem, -2)
  minasPosition[pos] = virtualItem
end)

onRemoveThing(function(tile, thing)
  if not Misc.get("verMinas") then return end
	if not thing:isItem() then
		return
  end

  if not table.find(checkMinas, thing:getId()) then
    return
  end

  local pos = tile:getPosition().x .. "," .. tile:getPosition().y .. "," .. tile:getPosition().z
  if table.find(checkMinas, thing:getId()) and minasPosition[pos] then
    for _, i in pairs(tile:getThings()) do
      if table.find(minasItems, i:getId()) then
        tile:removeThing(i)
        minasPosition[pos] = nil
      end
    end
  end
end)

-- AntiAFK --
macro(10000, function()
  if not Misc.get("antiAFK") then return end
  turn(0)
  schedule(2200, function() turn(1) end)
  schedule(3400, function() turn(3) end)
  schedule(4600, function() turn(2) end)
end)

-- Anti INV --
macro(200, function()
  if not Misc.get("verMonsters") then return end
  for _, n in ipairs(getSpectators(false)) do
    if n:isMonster() and n:isInvisible() then
      local outfit = n:getOutfit()
      n:setOutfit(outfit)
    end
  end
end)

-- Auto BLESS --
local function buyBless()
  if not Misc.get("autoBless") then return end
  containers = getContainers()
  if #containers < 1 and containers[0] == nil then
    bpItem = getBack()
    if bpItem ~= nil then
      g_game.open(bpItem)
    end
  end
  say("!bless")
end

macro(600000, function()
  if not Misc.get("autoBless") then return end
  say("!bless")
end)

buyBless()

-- Auto AOL --
local function buyAol()
  if not Misc.get("autoAol") then return end
  containers = getContainers()
  if #containers < 1 and containers[0] == nil then
    bpItem = getBack()
    if bpItem ~= nil then
      g_game.open(bpItem)
    end
  end
  if getNeck() and (getNeck():getId() == 816 or getNeck():getId() == 3057 or getNeck():getId() == 9301 or getNeck():getId() == 9302  or getNeck():getId() == 9303 or  getNeck():getId() == 9304) then return end
  say("!aol")
end
  


macro(600000, function()
  if not Misc.get("autoAol") then return end
  if getNeck() and (getNeck():getId() == 816 or getNeck():getId() == 3057 or getNeck():getId() == 9301 or getNeck():getId() == 9302  or getNeck():getId() == 9303 or  getNeck():getId() == 9304) then return end
  say("!aol")
end)


buyAol()


--   Auto Nextto; Sirve para tirar runa aun lado del target . --
local key = "SHIFT+L" 
local Medusaid = 3151
local squaresThreshold = 1 

-- script
macro(600, function()
  if not Misc.get("runeNextTo") then return end
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
    end
  end
end)