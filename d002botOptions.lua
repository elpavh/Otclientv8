setDefaultTab("Cave")
UI.Separator()

local panelName = "botOptions"
local botOptions = {}
botOptions.values = {}

local botUI = setupUI([[
Panel
  height: 20

  BotSwitch
    id: switch
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    width: 130
    $on:
      text: Ocultar Opciones.
      
    $!on:
      text: Mostrar Opciones.
]])


if not storage[panelName] then
    storage[panelName] = {
      bot_option = {},
      useRune = 3151,
      useRuneOption = "Medusa",
      spellName = "exevo mas lux",
      runeCustom = 1
    }
end

local runeSpam = UI.createWidget("RuneSpamWindow")
runeSpam:hide()

local spellSpam = UI.createWidget("SpellWindow")
spellSpam:hide()

botUI.switch:setOn(storage[panelName].active)

local panels = {runeSpam, spellSpam} -- All panels on this table will be looped and auto connected to the botton "close".

botOptions.setup = function()
  botOptions.ui = UI.createWidget("BotOpPanel")
  local add = botOptions.add

  add("spamRune", "Spam Rune", false, "switchEdit", runeSpam)
  add("spamSpell", "Spam Spell", false, "switchEdit", nil)
  add("pausarMonster", "Pausa Monsters", false, "switchEdit", nil)
  add("usarTarget", "Usar Targetting", false, "switch", nil)
  add("usarBoost", "Usar Booster", false, "switchEdit", nil)
--   add("pauseMonster", "Pausar en cantidad", "false", "switch", nil)
--   add("pauseMonster2", "Test2", "false", "switchEdit", nil)

end

botOptions.show = function()
  botOptions.ui:show()
end

botOptions.hide = function()
  botOptions.ui:hide()
end

botOptions.add = function(id, title, defaultValue, uiType, windowName)
  if botOptions.values[id] then
    return error("Duplicated config key: " .. id)
  end

  if storage[panelName].bot_option[id] == nil then
    storage[panelName].bot_option[id] = defaultValue
  end

  local panel
  if uiType == "switch" then
    panel = UI.createWidget("BotOpSwitch", botOptions.ui)
    panel.value:setOn(storage[panelName].bot_option[id])
    botOptions.values[id] = storage[panelName].bot_option[id]
    panel.value.onClick = function(widget)
      widget:setOn(not widget:isOn())
      storage[panelName].bot_option[id] = widget:isOn()
    end
  elseif uiType == "switchEdit" then
    panel = UI.createWidget("BotOpSwitchEdit", botOptions.ui)
    panel.value:setOn(storage[panelName].bot_option[id])
    botOptions.values[id] = storage[panelName].bot_option[id]
    panel.value.onClick = function(widget)
      widget:setOn(not widget:isOn())
      storage[panelName].bot_option[id] = widget:isOn()
    end
    panel.edit.onClick = function(widget)
        if not windowName then return end
        widget:setOn(not widget:isOn())
        if windowName:isVisible() then
            windowName:hide()
        else
            windowName:show()
        end
    end
  else
    return error("uiType not known for ID: "..id..".")
  end

  panel.title:setText(tr(title) .. ":")
  botOptions.values[id] = storage[panelName].bot_option[id]
end

local function hidePanels()
  for _, p in pairs(panels) do
    p:hide()
  end
end

botUI.switch.onClick = function()
  if not botOptions then return end
  if botUI.switch:isOn() then
    botOptions.hide()
    hidePanels()
    botUI.switch:setOn(false)
    storage[panelName].active = false
  else
    botOptions.show()
    botUI.switch:setOn(true)
    storage[panelName].active = true
  end
end

botOptions.get = function(id)
  if storage[panelNamee].saved_values[id] == nil then
    return error("The selected ID doesn't exist, id: " .. id)
  end
  return storage[panelName].saved_values[id]
end

botOptions.setup()

if storage[panelName].active then
  botOptions.show()
  botUI.switch:setOn(true)
else
  botOptions.hide()
  botUI.switch:setOn(false)
end

-- Loops trought panels table to create the onClick callback.
for _, p in pairs(panels) do
    p.close.onClick = function(widget)
        if p:isVisible() then
            p:hide()
            return
        end
        p:show()
    end
end

-- Windows Callbacks
runeSpam.runaValue:setOption(storage[panelName].useRuneOption)
runeSpam.runaValue.onOptionChange = function(widget)
    storage[panelName].useRune = runasID[widget:getText()]
    storage[panelName].useRuneOption = widget:getText()
end

spellSpam.removerValue:setText(storage[panelName].spellName)
spellSpam.removerValue.onTextChange = function(widget, text)
  storage[panelName].spellName = text
end