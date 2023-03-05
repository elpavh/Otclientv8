setDefaultTab("Tools")
local panelName = "spySetup"
local name = ""..g_game.getCharacterName()..""

local hotkeyAssignWindow
local spyLevel = posz()
local SpyFloor = {}
SpyFloor.values = {}

local spyUI = setupUI([[
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
      text: Ocultar Spy.
      
    $!on:
      text: Configurar Spy.
]])

if not storage[panelName .. name] then
    storage[panelName .. name] = {
      saved_hotkeys = {}
    }
end

local spyHotkey = UI.createWidget("SpyHotkeyWindow")
spyHotkey:hide()

local panels = {spyHotkey} -- All panels on this table will be looped and auto connected to the botton "close".

spyUI.switch:setOn(storage[panelName .. name].active)

local checkKeys = {}
local hotkeyCall = {}

SpyFloor.setup = function()
  SpyFloor.ui = UI.createWidget("SpyPanel")
  local add = SpyFloor.add

  add("floorUp", "Mirar Arriba", "nil", "button", nil, SpyFloor.spyUp, spyHotkey.hotkey1)
  add("floorDown", "Mirar Abajo", "nil", "button", nil, SpyFloor.spyDown, spyHotkey.hotkey2)
  add("floorReset", "Reset Spy", "nil", "button", nil, SpyFloor.resetSpy, spyHotkey.hotkey3)
  add("editHotkey", "Editar Hotkeys", 1, "button", spyHotkey, nil, nil)
end

SpyFloor.show = function()
  SpyFloor.ui:show()
end

SpyFloor.hide = function()
  SpyFloor.ui:hide()
end

local function updateHotkeyTable()
    checkKeys = {
        storage[panelName .. name].saved_hotkeys["floorUp"],
        storage[panelName .. name].saved_hotkeys["floorDown"],
        storage[panelName .. name].saved_hotkeys["floorReset"],
    }
end

SpyFloor.add = function(id, title, defaultValue, uiType, windowName, func, hotkeyName, saveOn)
  if SpyFloor.values[id] then
    return error("Duplicated config key: " .. id)
  end

  if storage[panelName .. name].saved_hotkeys[id] == nil then
    storage[panelName .. name].saved_hotkeys[id] = defaultValue
  end

  local panel
  if uiType == "button" then
    panel = UI.createWidget("SpyButton", SpyFloor.ui)
    panel.button.onClick = function(widget)
        if windowName then
            if windowName:isVisible() then
                windowName:hide()
            else
                windowName:show()
            end
        end

        if func then
            func()
        end
    end
  else
    return error("uiType not known for ID: "..id..".")
  end

  if hotkeyName then
    hotkeyName.onClick = function(widget)
        SpyFloor.hotkeys(id, widget, title, panel, func)
    end
    hotkeyName:setText("Editar "..title.." ["..storage[panelName .. name].saved_hotkeys[id].."]")
  end

  SpyFloor.values[id] = storage[panelName .. name].saved_hotkeys[id]
  hotkeyCall[storage[panelName .. name].saved_hotkeys[id]] = func

  if hotkeyName then
    panel.button:setText(""..title.." ["..storage[panelName .. name].saved_hotkeys[id].."]")
  else
    panel.button:setText(tr(title))
    panel.button:setColor("#dbff2a")
  end

  updateHotkeyTable()
end

local function hidePanels()
    for _, p in pairs(panels) do
      p:hide()
    end
  end

spyUI.switch.onClick = function()
  if not Misc then return end
  if spyUI.switch:isOn() then
    SpyFloor.hide()
    hidePanels()
    spyUI.switch:setOn(false)
    storage[panelName .. name].active = false
  else
    SpyFloor.show()
    spyUI.switch:setOn(true)
    storage[panelName .. name].active = true
  end
end

SpyFloor.get = function(id)
  if storage[panelName .. name].saved_values[id] == nil then
    return error("The selected ID doesn't exist, id: " .. id)
  end
  return storage[panelName .. name].saved_values[id]
end

onPlayerPositionChange(function(newPos, oldPos)
    if oldPos.z ~= newPos.z then
        spyLevel = posz()
        modules.game_interface.getMapPanel():unlockVisibleFloor()
    end
end)

SpyFloor.spyUp = function()
    spyLevel = spyLevel - 1
    modules.game_interface.getMapPanel():lockVisibleFloor(spyLevel)
end

SpyFloor.spyDown = function()
    spyLevel = spyLevel + 1
    modules.game_interface.getMapPanel():lockVisibleFloor(spyLevel)
end

SpyFloor.resetSpy = function()
    modules.game_interface.getMapPanel():unlockVisibleFloor()
    spyLevel = posz()
end

SpyFloor.hotkeys = function(id, widget, title, panel, func)
  if not id then return end
  if hotkeyAssignWindow then
    hotkeyAssignWindow:destroy()
  end
  local assignWindow = g_ui.createWidget('ActionAssignWindow', mainWidget)
  assignWindow:grabKeyboard()
  assignWindow.comboPreview.keyCombo = ''
  assignWindow.onKeyDown = function(assignWindow, keyCode, keyboardModifiers)
    local keyCombo = determineKeyComboDesc(keyCode, keyboardModifiers)
    assignWindow.comboPreview:setText(tr('Current action hotkey: %s', keyCombo))
    assignWindow.comboPreview.keyCombo = keyCombo
    assignWindow.comboPreview:resizeToText()
    return true
  end
  assignWindow.onDestroy = function(widget)
    if widget == hotkeyAssignWindow then
      hotkeyAssignWindow = nil
    end
  end
  assignWindow.addButton.onClick = function()
    local hotkey = tostring(assignWindow.comboPreview.keyCombo)
    widget:setText("Editar "..title.." ["..hotkey.."]")
    panel.button:setText(""..title.." ["..hotkey.."]")

    storage[panelName .. name].saved_hotkeys[id] = hotkey
    hotkeyCall[storage[panelName .. name].saved_hotkeys[id]] = func
    updateHotkeyTable()

    assignWindow:destroy()
  end
  hotkeyAssignWindow = assignWindow
end

SpyFloor.setup()

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
  SpyFloor.show()
  spyUI.switch:setOn(true)
else
  SpyFloor.hide()
  spyUI.switch:setOn(false)
end

onKeyDown(function(keys)
  if not table.find(checkKeys, keys) then
    return
  end

  local call = hotkeyCall[keys]
  call()
end)

UI.Separator()


local key = "Shift+S"
local parent = nil

-- script
local creatureId = 0

macro(100, "Keep Attack", key, function()
  if g_game.getFollowingCreature() then
    creatureId = 0
    return
  end
  local creature = g_game.getAttackingCreature()
  if creature then
    creatureId = creature:getId()
  elseif creatureId > 0 then
    local target = getCreatureById(creatureId)
    if target then
      attack(target)
      delay(500)
    end
  end
end)

UI.Separator()