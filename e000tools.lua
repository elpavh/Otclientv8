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

macro(100, "Smarter targeting","Shift+Z", function() 
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

local c = {
	pickUp = {688, 17012, 5809, 3151, 3199, 3183, 3194, 7883, 3335, 11701, 4033, 18203, 141, 3187, 9655, 12805, 3163, 11686, 11473, 11475, 6531, 3184, 3169, 669, 3556,
	9306, 10385, 3186, 9653, 11468, 10200, 14684, 788, 9645, 11478, 8096, 14760, 2869, 4033, 12670, 11691, 11486, 16344, 16110, 16105, 13994, 13993, 22733, 22729, 10344, 11455,
	27082, 9304, 9301, 9302, 9303, 12669, 24704, 1781, 12730, 3040, 10278,
	2865, 3253, 10327, 5926, 5466, 9611, 6542, 10387

	}, -- Item list to pickup, separated by a comma.
	CheckPOS = 1 -- The SQM from your character to check if theres an item.
}
macro(20, "Free Items", "0", function()
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
        if (item and item:getId() == 9655) then
          g_game.use(item)
          return
        end
      end  
    end
end)

UI.Separator()

local ahora = "**************** AHORA MORROS ****************"

local sillas = macro(100, 'sillas', '6', function() end)
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

macro(500, "walter", "8", function()
	NPC.say("adivinar")
	schedule((2000), function() NPC.say("13") end)
	delay(math.random(3500, 3500))
end)