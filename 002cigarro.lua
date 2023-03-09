local cigarroPanel = "cigarroSetup"
local UI = setupUI([[
Panel
  height: 20

  BotSwitch
    id: switch
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Cigarro')

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    height: 17
    margin-left: 4
    text: Edit
]])

local name = ""..g_game.getCharacterName()..""

if not storage[cigarroPanel .. name] then
    storage[cigarroPanel .. name] = {
      cigarroID = 141,
      useTime = 20 -- In miliseconds.
    }
end

mainWidget = g_ui.getRootWidget()
cigarroWindow = g_ui.createWidget("CigarroWindow", mainWidget)
cigarroWindow:hide()

UI.switch:setOn(storage[cigarroPanel .. name].active)
cigarroWindow.labelCount:setText(""..storage[cigarroPanel .. name].useTime.." MS")
cigarroWindow.scroll:setValue(storage[cigarroPanel .. name].useTime)
cigarroWindow.item:setItemId(storage[cigarroPanel .. name].cigarroID)

UI.switch.onClick = function(widget)
  storage[cigarroPanel .. name].active = not storage[cigarroPanel .. name].active
  widget:setOn(storage[cigarroPanel .. name].active)
end

UI.edit.onClick = function(widget)
	if cigarroWindow:isVisible() then
    cigarroWindow:hide()
    return
	end
  cigarroWindow:show()
  cigarroWindow:focus()
end

cigarroWindow.close.onClick = function(widget)
  cigarroWindow:hide()
end

cigarroWindow.item.onItemChange = function(widget)
  storage[cigarroPanel .. name].cigarroID = widget:getItemId()
end

local cigarroMacro = macro(storage[cigarroPanel .. name].useTime, function(macro)
  if not storage[cigarroPanel .. name].active then return end
  local skull = skull()
  if skull >= 4 then
      use(storage[cigarroPanel .. name].cigarroID)
  end
end)

cigarroWindow.scroll.onValueChange = function(scroll, value)
  storage[cigarroPanel .. name].useTime = value
  cigarroWindow.labelCount:setText(""..value.." MS")
  cigarroMacro.timeout = storage[cigarroPanel .. name].useTime
end