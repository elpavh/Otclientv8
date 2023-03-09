setDefaultTab("PvP")

local enemyPanel = "enemySetup"
local name = ""..g_game.getCharacterName()..""
if not storage[enemyPanel .. name] then
  storage[enemyPanel .. name] = {
    enemyList = {}
  }
end

mainWidget = g_ui.getRootWidget()
enemyWindow = g_ui.createWidget("EnemyWindow", mainWidget)
enemyWindow:hide()

local enemyUI = setupUI([[
Panel
  height: 20

  BotSwitch
    id: switch
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Enemy List')

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    height: 17
    margin-left: 4
    text: Edit
]])

enemyUI.switch:setOn(storage[enemyPanel .. name].active)

enemyUI.switch.onClick = function(widget)
  storage[enemyPanel .. name].active = not storage[enemyPanel .. name].active
  widget:setOn(storage[enemyPanel .. name].active)
end

enemyUI.edit.onClick = function(widget)
	if enemyWindow:isVisible() then
    enemyWindow:hide()
    return
	end
  enemyWindow:show()
  enemyWindow:focus()
end

enemyWindow.close.onClick = function(widget)
  enemyWindow:hide()
end

if storage[enemyPanel .. name].enemyList and #storage[enemyPanel .. name].enemyList > 0 then
  for _, player in pairs(storage[enemyPanel .. name].enemyList) do
    local listInsert = g_ui.createWidget("EnemyRow", enemyWindow.enemy.enList)
    listInsert.delete.onClick = function(widget)
      table.removevalue(storage[enemyPanel .. name].enemyList, listInsert:getText())
      listInsert:destroy()
    end
    listInsert:setText(player)
  end
end

enemyWindow.enemy.add.onClick = function(widget)
  local nameToAdd = enemyWindow.enemy.text:getText()
  if not table.find(storage[enemyPanel .. name].enemyList, nameToAdd) and nameToAdd:len() > 0 then
    table.insert(storage[enemyPanel .. name].enemyList, nameToAdd)

    local listInsert = g_ui.createWidget("EnemyRow", enemyWindow.enemy.enList)
    listInsert.delete.onClick = function(widget)
      table.removevalue(storage[enemyPanel .. name].enemyList, listInsert:getText())
      listInsert:destroy()
    end
    listInsert:setText(nameToAdd)
    enemyWindow.enemy.text:setText("")
  end
end

enemyWindow.enemy.pasar.onClick = function(widget)
  local string = ''
  for _, player in pairs(storage[enemyPanel .. name].enemyList) do
    if string == '' then
      string = ""..player..""
    else
      string = ""..string..","..player..""
    end
    enemyWindow.enemy.guardarText:setText(string)
  end
end

enemyWindow.enemy.cargar.onClick = function(widget)
  local string = enemyWindow.enemy.guardarText:getText()
  for player in string.gmatch(string, "([^,]+)") do
    if not table.find(storage[enemyPanel .. name].enemyList, player) and player:len() > 0 then
      table.insert(storage[enemyPanel .. name].enemyList, player)

      local listInsert = g_ui.createWidget("EnemyRow", enemyWindow.enemy.enList)
      listInsert.delete.onClick = function(widget)
        table.removevalue(storage[enemyPanel .. name].enemyList, player)
        listInsert:destroy()
      end
    listInsert:setText(player)
    end
  end
  enemyWindow.enemy.guardarText:setText("")
end

local enemyMacro = macro(100, function()
  if not storage[enemyPanel .. name].active then return end
  if isInPz() then return end
  for _, n in ipairs(getSpectators(false)) do
	  for _, e in pairs(storage[enemyPanel .. name].enemyList) do
		  local current = g_game.getAttackingCreature()
		  if current and table.find(storage[enemyPanel .. name].enemyList, current:getName()) then
			  return true
		  end

		  if n:isPlayer() and n:getName() == e and getDistanceBetween(pos(), n:getPosition()) <= 7 then
			  g_game.cancelAttack()
			  g_game.attack(n)
		  end
	  end
  end
end)

UI.Separator()