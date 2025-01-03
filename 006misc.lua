local panelName = "miscSetup"
local name = ""..g_game.getCharacterName()..""
Misc = {}
Misc.values = {}

local miscUI = setupUI([[
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
      text: Ocultar Misc.
      
    $!on:
      text: Mostrar Misc.
]])

if not storage[panelName .. name] then
    storage[panelName .. name] = {
      default_values = {},
      saved_values = {},
      items = {{id = 3151, count = 81}, {id = 16344, count = 12}, {id = 3194, count = 72}, {id = 3192, count = 75}},
      itemsList = {},
      utaniSpell = "utani hur",
      removerID = 688,
      saved_panels = {}
    }
end
--removerID = 688,
-- Panels
local hurPanel = UI.createWidget("HurWindow")
hurPanel:hide()

local reUsePanel = UI.createWidget("ReuseWindow")
local reUseIcons = g_ui.createWidget("ItemUse", reUsePanel.itemList)
reUsePanel:hide()

local removerPanel = UI.createWidget("RemoverWindow")
removerPanel:hide()

local panels = {hurPanel, reUsePanel, removerPanel} -- All panels on this table will be looped and auto connected to the botton "close".

miscUI.switch:setOn(storage[panelName .. name].active)

Misc.setup = function()
  Misc.ui = UI.createWidget("MiscPanel")
  local add = Misc.add

  add("removerStatus", "AutoRemover", true, "switchEdit", removerPanel)
  add("wasdStatus", "Usar WASD", true, "switch")
  add("wallTimers", "Wall Timers", true, "switch")
  add("reUse", "Click ReUse", false, "switchEdit", reUsePanel)
  add("verMinas", "Revelar Minas v2", true, "switch")
  add("verMonsters", "Revelar INV", true, "switch")
  add("autoBless", "Auto Bless", true, "switch")
  add("autoAol", "Auto Aol", true, "switch")
  add("antiAFK", "ANTI-AFK", false, "switch")
  add("utamoVita", "Auto Utamo", false, "switch")
  add("utaniHur", "Auto Hur", false, "switchEdit", hurPanel)
  add("fishing", "Auto Fishing", false, "switch")
  add("runeNextTo", "Auto Nextto", false, "switch") 

end


Misc.show = function()
  Misc.ui:show()
end

Misc.hide = function()
  Misc.ui:hide()
end

Misc.add = function(id, title, defaultValue, uiType, windowName)
  if Misc.values[id] then
    return error("Duplicated config key: " .. id)
  end

  if storage[panelName .. name].saved_values[id] == nil then
    storage[panelName .. name].saved_values[id] = defaultValue
  end

  local panel
  if uiType == "number" then
    panel = UI.createWidget("MiscNumber", Misc.ui)
    panel.value:setText(storage[panelName .. name].saved_values[id])
    Misc.values[id] = storage[panelName .. name].saved_values[id]
    panel.value.onTextChange = function(widget, newValue)
      newValue = tonumber(newValue)
      if newValue then
        storage[panelName .. name].saved_values[id] = newValue
      end
    end
  elseif uiType == "switch" then
    panel = UI.createWidget("MiscSwitch", Misc.ui)
    panel.value:setOn(storage[panelName .. name].saved_values[id])
    Misc.values[id] = storage[panelName .. name].saved_values[id]
    panel.value.onClick = function(widget)
      widget:setOn(not widget:isOn())
      storage[panelName .. name].saved_values[id] = widget:isOn()
    end
  elseif uiType == "switchEdit" then
    panel = UI.createWidget("MiscSwitchEdit", Misc.ui)
    panel.value:setOn(storage[panelName .. name].saved_values[id])
    Misc.values[id] = storage[panelName .. name].saved_values[id]
    panel.value.onClick = function(widget)
      widget:setOn(not widget:isOn())
      storage[panelName .. name].saved_values[id] = widget:isOn()
    end
    panel.edit.onClick = function(widget)
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
end

local function hidePanels()
  for _, p in pairs(panels) do
    p:hide()
  end
end

miscUI.switch.onClick = function()
  if not Misc then return end
  if miscUI.switch:isOn() then
    Misc.hide()
    hidePanels()
    miscUI.switch:setOn(false)
    storage[panelName .. name].active = false
  else
    Misc.show()
    miscUI.switch:setOn(true)
    storage[panelName .. name].active = true
  end
end

Misc.get = function(id)
  if storage[panelName .. name].saved_values[id] == nil then
    return error("The selected ID doesn't exist, id: " .. id)
  end
  return storage[panelName .. name].saved_values[id]
end

Misc.setup()

-- ReUse Icons functions.
storage[panelName .. name].itemsList = {}
for _, v in pairs(storage[panelName .. name].items) do
  if not table.find(storage[panelName .. name].itemsList, v.id) then
    table.insert(storage[panelName .. name].itemsList, v.id)
  end
end

local function updateItemList(info)
  if not info then return end
  storage[panelName .. name].itemsList = {}
  for _, v in pairs(info) do
      table.insert(storage[panelName .. name].itemsList, v.id)
  end
end

reUseIcons.items.onItemUpdate = function(info)
  local i = info:getItems()
  updateItemList(i)
  storage[panelName .. name].items = i
end

UI.Container(reUseIcons.items.onItemUpdate, true, nil, reUseIcons.items)
reUseIcons.items:setItems(storage[panelName .. name].items)

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

if storage[panelName .. name].active then
  Misc.show()
  miscUI.switch:setOn(true)
else
  Misc.hide()
  miscUI.switch:setOn(false)
end

-- Panels callbacks
hurPanel.hurValue:setText(storage[panelName .. name].utaniSpell)
hurPanel.hurValue.onTextChange = function(widget, text)
  storage[panelName .. name].utaniSpell = text
end

removerPanel.removerValue:setText(storage[panelName .. name].removerID)
removerPanel.removerValue.onTextChange = function(widget, text)
  storage[panelName .. name].removerID = text
end

UI.Separator()


local panelName = "autoSpellConfig"
local name = "" .. g_game.getCharacterName() .. ""
AutoSpell = {}

-- Default Storage Initialization
if not storage[panelName .. name] then
    storage[panelName .. name] = {
        numeroMonsters = 3,
        palabra = "exura ico",
        rango = 5,
        active = false
    }
end

-- Main UI Button
local autoSpellUI = setupUI([[  
Panel
  height: 20

  BotSwitch
    id: spellSwitch
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    width: 130
    $on:
      text: Ocultar Spell Config
      color: #00FF00
    $!on:
      text: Mostrar Spell Config
]])

autoSpellUI.spellSwitch:setOn(storage[panelName .. name].active)

-- AutoSpell Configuration Panel
local spellConfigPanel = setupUI([[  
Panel
  id: autoSpellPanel
  anchors.top: parent.top
  anchors.left: parent.left
  margin-top: 25
  width: 200

  Label
    text: Configuración de AutoSpell
    font: verdana-11b
    anchors.left: parent.left
    anchors.top: parent.top

  Label
    text: Cantidad de Monstruos:
    anchors.top: prev.bottom
    anchors.left: parent.left

  SpinBox
    id: numeroMonsters
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    min: 1
    max: 100

  Label
    text: Spell:
    anchors.top: prev.bottom
    anchors.left: parent.left

  TextEdit
    id: palabra
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right

  Label
    text: Rango del Spell:
    anchors.top: prev.bottom
    anchors.left: parent.left

  SpinBox
    id: rango
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    min: 1
    max: 20
]])

spellConfigPanel:hide()

-- Load Saved Values
spellConfigPanel.numeroMonsters:setValue(storage[panelName .. name].numeroMonsters)
spellConfigPanel.palabra:setText(storage[panelName .. name].palabra)
spellConfigPanel.rango:setValue(storage[panelName .. name].rango)

-- Save Input Values
spellConfigPanel.numeroMonsters.onValueChange = function(widget, value)
    storage[panelName .. name].numeroMonsters = value
end

spellConfigPanel.palabra.onTextChange = function(widget, text)
    storage[panelName .. name].palabra = text
end

spellConfigPanel.rango.onValueChange = function(widget, value)
    storage[panelName .. name].rango = value
end

-- Show/Hide Panel Logic
autoSpellUI.spellSwitch.onClick = function()
    if storage[panelName .. name].active then
        spellConfigPanel:hide()
        autoSpellUI.spellSwitch:setOn(false)
        storage[panelName .. name].active = false
    else
        spellConfigPanel:show()
        autoSpellUI.spellSwitch:setOn(true)
        storage[panelName .. name].active = true
    end
end
