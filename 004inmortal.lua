UI.Separator()

local inmortalPanel = "inmortalSetup"
local name = ""..g_game.getCharacterName()..""

if type(storage.rpInmortal) ~= "table" then
	storage.rpInmortal = {
        on = false,
        title = "Inmortal Ring",
        item1 = 406,
        item2 = 3097,
        slot = 9
    }
end

if not storage[inmortalPanel .. name] then
    storage[inmortalPanel .. name] = {
      ponerEnHP = 50,
      quitarEnHP = 80
    }
end

local rpInmorltalMacro = macro(100, function()
	local slotItem = getSlot(storage.rpInmortal.slot)
	local itemOne = findItem(storage.rpInmortal.item1)
	local itemTwo = findItem(storage.rpInmortal.item2)

	if hppercent() <= storage[inmortalPanel .. name].ponerEnHP then
		if not slotItem then
			if not itemOne then return end
			g_game.move(itemOne, {x = 65535, y = storage.rpInmortal.slot, z = 0}, itemOne:getCount())
			return
		end

		if slotItem:getId() ~= storage.manoCambiada.item1 then
			if not itemOne then return end
			g_game.move(itemOne, {x = 65535, y = storage.rpInmortal.slot, z = 0}, itemOne:getCount())
		end
		return
	elseif hppercent() >= storage[inmortalPanel .. name].quitarEnHP then
		if storage.rpInmortal.item2 ~= 0 and itemTwo and slotItem then
			if slotItem:getId() ~= storage.manoCambiada.item2 then
				g_game.move(itemTwo, {x = 65535, y = storage.rpInmortal.slot, z = 0}, itemTwo:getCount())
				return
			end
		end
		if storage.rpInmortal.item2 == 0 then
			g_game.move(getInventoryItem(9), {x = 65535, y = 3, z = 0})
		end
	end

	if not slotItem or slotItem == nil and storage.rpInmortal.item2 ~= 0 then
		if not itemTwo then return end
		g_game.move(itemTwo, {x = 65535, y = storage.rpInmortal.slot, z = 0}, itemTwo:getCount())
	end
end)
rpInmorltalMacro.setOn(storage.rpInmortal.on)

UI.TwoItemsAndSlotPanel(storage.rpInmortal, function(widget, newParams) 
	storage.rpInmortal = newParams
	rpInmorltalMacro.setOn(storage.rpInmortal.on)
end)

local inmortalUI = setupUI([[
Panel
  height: 20

  Button
    id: edit
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 17
    margin-top: 5
    text: Setup
]])

mainWidget = g_ui.getRootWidget()
inmortalWindow = g_ui.createWidget("InmortalWindow", mainWidget)
inmortalWindow:hide()

inmortalWindow.PonerHP.scroll:setValue(storage[inmortalPanel .. name].ponerEnHP)
inmortalWindow.PonerHP.label:setText("Poner anillo en "..storage[inmortalPanel .. name].ponerEnHP.."% Health")
inmortalWindow.QuitarHP.scroll:setValue(storage[inmortalPanel .. name].quitarEnHP)
inmortalWindow.QuitarHP.label:setText("Quitar anillo en "..storage[inmortalPanel .. name].quitarEnHP.."% Health")

inmortalUI.edit.onClick = function(widget)
	if inmortalWindow:isVisible() then
    inmortalWindow:hide()
    return
	end
  inmortalWindow:show()
  inmortalWindow:focus()
end

inmortalWindow.close.onClick = function(widget)
  inmortalWindow:hide()
end

inmortalWindow.PonerHP.scroll.onValueChange = function(scroll, value)
    storage[inmortalPanel .. name].ponerEnHP = value
    inmortalWindow.PonerHP.label:setText("Poner anillo en "..value.."% Health")
end

inmortalWindow.QuitarHP.scroll.onValueChange = function(scroll, value)
    storage[inmortalPanel .. name].quitarEnHP = value
    inmortalWindow.QuitarHP.label:setText("Quitar anillo en "..value.."% Health")
end

UI.Separator()