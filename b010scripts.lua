setDefaultTab("PvP")

UI.Button("Agregar Macro", function(newText)
  UI.MultilineEditorWindow(storage.ingame_macros_bat or "", {title="Agregar Macro", description="You can add your custom macros (or any other lua code) here"}, function(text)
	storage.ingame_macros_bat = text
	reload()
  end)
end)

UI.Button("Agregar Hotkey", function(newText)
  UI.MultilineEditorWindow(storage.ingame_hotkeys_bat or "", {title="Agregar Hotkey", description="You can add your custom hotkeys/singlehotkeys here"}, function(text)
	storage.ingame_hotkeys_bat = text
	reload()
  end)
end)

for _, scripts in ipairs({storage.ingame_macros_bat, storage.ingame_hotkeys_bat}) do
  if type(scripts) == "string" and scripts:len() > 3 then
	local status, result = pcall(function()
	  assert(load(scripts, "ingame_editor"))()
	end)
	if not status then 
	  error("Ingame edior error:\n" .. result)
	end
  end
end
UI.Separator()

macro(100, "Auto FireBomb", "", function()
	for x = -7, 7 do
		for y = -7, 7 do
			local xp = posx()
			local yp = posy()
			local tile = g_map.getTile({x = xp + x, y = yp + y, z = posz()})
			if tile then
				local a = tile:getEffects()[1]
				if a then 
					if a:getId() ~= 51 then return end
				end
			end
			if tile then
				for k, v in pairs(tile:getEffects()) do
					if v:getId() == 51 then
						local newTile = g_map.getTile({x = tile:getPosition().x + 1, y = tile:getPosition().y + 1, z = posz()})
						usewith(3192, newTile:getTopUseThing())
						delay(2000)
					end
				end
			end
		end
	end
end)

UI.Separator()

Panels.AttackItem(batTab)

UI.Separator()

UI.Label("Mana training")
if type(storage.manaTrain) ~= "table" then
  storage.manaTrain = {on=false, title="MP%", text="utevo lux", min=80, max=100}
end

local manatrainmacro = macro(1000, function()
  local mana = math.min(100, math.floor(100 * (player:getMana() / player:getMaxMana())))
  if storage.manaTrain.max >= mana and mana >= storage.manaTrain.min then
	say(storage.manaTrain.text)
  end
end)
manatrainmacro.setOn(storage.manaTrain.on)

UI.DualScrollPanel(storage.manaTrain, function(widget, newParams) 
  storage.manaTrain = newParams
  manatrainmacro.setOn(storage.manaTrain.on)
end)


UI.Separator()

Panels.AntiPush(batTab)

UI.Separator()


macro(200, "UH Anti-Paralyze", "", function()
	if not isParalyzed() then return end
	usewith(3187, player)
end)

UI.Separator()

macro(100, "Enable SUH Friend", function()
  for _, creature in pairs(getSpectators(posz())) do
    local heal_player = creature:getName();
    if (heal_player == storage.uhFriend) then
      if (creature:getHealthPercent() < tonumber(storage.uhFriendPercent)) then
        useWith(3187, creature);
        return;
      end
    end
  end
end)
addLabel("uhname", "Player Name:")
addTextEdit("uhfriend", storage.uhFriend or "", function(widget, text)
  storage.uhFriend = text
end) 
addLabel("uhpercent", "Porcentagem HP %:")
addTextEdit("uhfriendpercent", storage.uhFriendPercent or "", function(widget, text)
  storage.uhFriendPercent = text
end)


UI.Separator()