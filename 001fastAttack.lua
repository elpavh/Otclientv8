local fastAttackPanel = "fastAttackSetup"
local UI = setupUI([[
Panel
  height: 20

  BotSwitch
    id: switch
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 130
    !text: tr('Fast Attack')

  Button
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    height: 17
    margin-left: 4
    text: Edit
]])
UI:setId(fastAttackPanel)

local name = ""..g_game.getCharacterName()..""

if not storage[fastAttackPanel .. name] then
    storage[fastAttackPanel .. name] = {
      atkPerUse = 5,
      useTime = 30 -- In miliseconds.
    }
end

mainWidget = g_ui.getRootWidget()
fastAtkWindow = g_ui.createWidget("FastAtkWindow", mainWidget)
fastAtkWindow:hide()

UI.switch:setOn(storage[fastAttackPanel .. name].active)
fastAtkWindow.labelUsoCount:setText(""..storage[fastAttackPanel .. name].atkPerUse.." USOS")
fastAtkWindow.labelCount:setText(""..storage[fastAttackPanel .. name].useTime.." MS")
fastAtkWindow.scrollPorVes:setValue(storage[fastAttackPanel .. name].useTime)
fastAtkWindow.scrollPorUso:setValue(storage[fastAttackPanel .. name].atkPerUse)

UI.switch.onClick = function(widget)
  storage[fastAttackPanel .. name].active = not storage[fastAttackPanel .. name].active
  widget:setOn(storage[fastAttackPanel .. name].active)
end

UI.edit.onClick = function(widget)
	if fastAtkWindow:isVisible() then
    fastAtkWindow:hide()
    return
	end
  fastAtkWindow:show()
  fastAtkWindow:focus()
end

fastAtkWindow.close.onClick = function(widget)
  fastAtkWindow:hide()
end
local target
local fastAttackMacro = macro(storage[fastAttackPanel .. name].useTime, function(macro)
  if not storage[fastAttackPanel .. name].active then return end
      if g_game.isAttacking() and not target then
          target = g_game.getAttackingCreature()
      end

      if target and g_game.isAttacking() and getDistanceBetween(pos(), target:getPosition()) <= 8 and not isInPz() then
          local atk = OutputMessage.create()
          local protocol = g_game.getProtocolGame()
          local id = target:getId()
          atk:addU8(161)
          atk:addU32(id)
          for i = storage[fastAttackPanel .. name].atkPerUse, 1, -1 do
              if i > 1 then
                  protocol:send(atk)
                  protocol:send(atk)
                  protocol:send(atk)
              end
          end
      end

      if not g_game.isAttacking() and target ~= nil then
          target = nil
      end
end)

onCreatureDisappear(function(creature)
  if not storage[fastAttackPanel .. name].active then return end
  if target then
      if creature:getId() == target:getId() then
          target = nil
      end
  end
end)

fastAtkWindow.scrollPorVes.onValueChange = function(scroll, value)
  storage[fastAttackPanel .. name].useTime = value
  fastAtkWindow.labelCount:setText(""..value.." MS")
  fastAttackMacro.timeout = storage[fastAttackPanel .. name].useTime
end

fastAtkWindow.scrollPorUso.onValueChange = function(scroll, value)
  storage[fastAttackPanel .. name].atkPerUse = value
  fastAtkWindow.labelUsoCount:setText(""..value.." USOS")
  --fastAttackMacro.timeout = storage[fastAttackPanel .. name].useTime
end