setDefaultTab("PVP")
local manoPanel = "manoSetup"
local name = ""..g_game.getCharacterName()..""
if not storage[manoPanel .. name] then
  storage[manoPanel .. name] = {
    wandOneList = {"Green Demon", "Xerxes", "Virus de Influenza", "Oso Polar", "Yeti Chan", "Bato Infectado", "Teibolera Infectada", "Perro con Sida", "Harry Putter"},
    cigarroID = 141,
    useTime = 20 -- In miliseconds.
  }
end

mainWidget = g_ui.getRootWidget()
manoWindow = g_ui.createWidget("ManoWindow", mainWidget)
manoWindow:hide()

local titleUI = setupUI([[
Panel
  height: 20

  Label
    id: label
    text: Mano Cambiada
    anchors.left: parent.left
    anchors.top: parent.top
    margin-left: 39
    color: #0ef11c
    text-align: center
]])

if type(storage.manoCambiada) ~= "table" then
	storage.manoCambiada = {on = false, title = "Mano Cambiada", item1 = 22729, item2 = 18287, slot = 6}
end

local manoCambiadaMacro = macro(100, function()
	local target = g_game.getAttackingCreature()
	local slotItem = getSlot(storage.manoCambiada.slot)
	if not target or target == nil then
		local item = findItem(storage.manoCambiada.item1)
		if not slotItem or slotItem == nil then
			if not item then return end
			g_game.move(item, {x = 65535, y = storage.manoCambiada.slot, z = 0}, item:getCount())
			return
		end

		if slotItem:getId() ~= storage.manoCambiada.item1 then
			if not item then return end
			g_game.move(item, {x = 65535, y = storage.manoCambiada.slot, z = 0}, item:getCount())
		end
		return
	end

	if table.find(storage[manoPanel .. name].wandOneList, target:getName()) and slotItem:getId() ~= storage.manoCambiada.item2 then
		local item = findItem(storage.manoCambiada.item2)
		if not item then return end
		g_game.move(item, {x = 65535, y = storage.manoCambiada.slot, z = 0}, item:getCount())
	elseif not table.find(storage[manoPanel .. name].wandOneList, target:getName()) and slotItem:getId() ~= storage.manoCambiada.item1 then
		local item = findItem(storage.manoCambiada.item1)
		if not item then return end
		g_game.move(item, {x = 65535, y = storage.manoCambiada.slot, z = 0}, item:getCount())
	end
end)
manoCambiadaMacro.setOn(storage.manoCambiada.on)

UI.TwoItemsAndSlotPanel(storage.manoCambiada, function(widget, newParams) 
	storage.manoCambiada = newParams
	manoCambiadaMacro.setOn(storage.manoCambiada.on)
end)

local manoUI = setupUI([[
Panel
  height: 20

  Button
    id: edit
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 17
    margin-top: 5
    text: Configurar Monsters
]])
manoUI:setId(manoPanel)

manoUI.edit.onClick = function(widget)
	if manoWindow:isVisible() then
    manoWindow:hide()
    return
	end
  manoWindow:show()
  manoWindow:focus()
end

manoWindow.close.onClick = function(widget)
  manoWindow:hide()
end

if storage[manoPanel .. name].wandOneList and #storage[manoPanel .. name].wandOneList > 0 then
  for _, player in pairs(storage[manoPanel .. name].wandOneList) do
    local listInsert = g_ui.createWidget("Wand1Row", manoWindow.wand1.wandList)
    listInsert.delete.onClick = function(widget)
      table.removevalue(storage[manoPanel .. name].wandOneList, listInsert:getText())
      listInsert:destroy()
    end
    listInsert:setText(player)
  end
end

manoWindow.wand1.add.onClick = function(widget)
  local nameToAdd = manoWindow.wand1.text:getText()
  if not table.find(storage[manoPanel .. name].wandOneList, nameToAdd) and nameToAdd:len() > 0 then
    table.insert(storage[manoPanel .. name].wandOneList, nameToAdd)

    local listInsert = g_ui.createWidget("Wand1Row", manoWindow.wand1.wandList)
    listInsert.delete.onClick = function(widget)
      table.removevalue(storage[manoPanel .. name].wandOneList, listInsert:getText())
      listInsert:destroy()
    end
    listInsert:setText(nameToAdd)
    manoWindow.wand1.text:setText("")
  end
end

manoWindow.wand1.pasar.onClick = function(widget)
  local string = ''
  for _, player in pairs(storage[manoPanel .. name].wandOneList) do
    if string == '' then
      string = ""..player..""
    else
      string = ""..string..","..player..""
    end
    manoWindow.wand1.guardarText:setText(string)
  end
end

manoWindow.wand1.cargar.onClick = function(widget)
  local string = manoWindow.wand1.guardarText:getText()
  for player in string.gmatch(string, "([^,]+)") do
    if not table.find(storage[manoPanel .. name].wandOneList, player) and player:len() > 0 then
      table.insert(storage[manoPanel .. name].wandOneList, player)

      local listInsert = g_ui.createWidget("Wand1Row", manoWindow.wand1.wandList)
      listInsert.delete.onClick = function(widget)
        table.removevalue(storage[manoPanel .. name].wandOneList, player)
        listInsert:destroy()
      end
    listInsert:setText(player)
    end
  end
  manoWindow.wand1.guardarText:setText("")
end

UI.Separator()

