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

local nombres =
{
  "Goblin Ninja",
  "Alma Contaminada",
  "Training Monk",
  "La Mole",
  "Gozzler",
  "Goblin Vip"
}

macro(2000, "Auto Spell", function()
    local cantidad = 0
    local rango = tonumber(storage.rango) or 7 -- Rango por defecto de 7 si no está configurado
    for _, spec in ipairs(getSpectators(false)) do
        if spec.getDistance and spec:getDistance() <= rango then -- Verificar si 'getDistance' existe y si está dentro del rango
            for _, creature in pairs(nombres) do
                if spec:getName():lower():find(creature:lower()) then
                    cantidad = cantidad + 1
                end
            end
        end
    end
    if cantidad >= tonumber(storage.numeroMonster) then
        say(storage.palabra)
        delay(10000)
    end
end)

addTextEdit("numeroMonster", storage.numeroMonster or "1", function(widget, text)
    storage.numeroMonster = text
end)

addTextEdit("palabra", storage.palabra, function(widget, text) 
    storage.palabra = text
end)

addTextEdit("rango", storage.rango or "7", function(widget, text)
    storage.rango = text
end)

UI.Separator()

local panelName = "tcLastExiva"
local tcLastExiva = setupUI([[
ExivaLabel < Label
  height: 12
  background-color: #00000055
  opacity: 0.89
  anchors.horizontalCenter: parent.horizontalCenter
  text-auto-resize: true
  font: verdana-11px-rounded

Panel
  id: msgPanel
  height: 26
  width: 100
  anchors.bottom: parent.bottom
  anchors.horizontalCenter: parent.horizontalCenter
  margin-bottom: 20

  ExivaLabel
    id: lblMessage
    color: green
    anchors.bottom: parent.bottom
    !text: 'None.'

  ExivaLabel
    id: lblExiva
    color: orange
    anchors.bottom: prev.top
    !text: 'Last Exiva: None'

]], modules.game_interface.getMapPanel())

local tclastExivaUI = setupUI([[
Panel
  margin: 3
  height: 66
  layout:
    type: verticalBox

  HorizontalSeparator
    id: separator

  Label
    id: title
    text: Last Exiva
    margin-top: 1
    text-align: center
    font: verdana-11px-rounded

  Panel
    id: time
    height: 22
    Label
      !text: 'Time in seconds:'
      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter
      anchors.right: next.left
      text-align: center
      height: 15
      margin-right: 6
      font: verdana-11px-rounded

    BotTextEdit
      id: text
      text: 5
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      margin-left: 5
      height: 17
      width: 55
      font: verdana-11px-rounded

  ]], parent)

if not storage[panelName] then
  storage[panelName] = {
    name = '',
    timer = 5,
  }
end

tclastExivaUI.time.text:setText(storage[panelName].timer)
tclastExivaUI.time.text.onTextChange = function(widget, text)
  storage[panelName].timer = tonumber(text)
end

local lastExiva = ''
lastExiva = storage[panelName].name
tcLastExiva.lblExiva:setText('Last Exiva: ' .. lastExiva)

onTalk(function(name, level, mode, text, channelId, pos)
  if name ~= player:getName() then return end
  text = text:lower()
  -- uncomment the warn below to find the channel mode if this doesn't work
  -- cast exiva and you should see NUMBER :  exiva "name"
  -- warn(mode.. ':'..text)
  if (mode == 34 or mode == 44) and text:find('exiva ') then
   lastExiva = string.match(text, [[exiva "([^"]+)]])
    if lastExiva then
      storage[panelName].name = lastExiva
      tcLastExiva.lblExiva:setText('Last Exiva: ' .. lastExiva)
    end
  end
end)

onTextMessage(function(mode, text)
  if mode ~= 20 then return end
  local regex = "([a-z A-Z]*) is ([a-z -A-Z]*)(?:to the|standing|below|above) ([a-z -A-Z]*)."
  local data = regexMatch(text, regex)[1]
  if data and data[2] and data[3] then
    schedule(10, function()
      tcLastExiva.lblMessage:setText(text)
    end)
  end
end)

tclastExivaMacro = macro(100, "Enable", "SHIFT+F1", function()
  if lastExiva:len() > 0 then
    say('exiva "' .. lastExiva)
  end
  delay(tonumber(storage[panelName].timer) * 1000)
end, tclastExivaUI)
UI.Separator(tclastExivaUI)

UI.Separator()
macro(200, "RangeAttack Spell", function()
  local target = g_game.getAttackingCreature()
  if target and getDistanceBetween(pos(), target:getPosition()) <= 8 then
      say(storage.autoAttackSpell)
  end
end)
addTextEdit("autoAttackSpell", storage.autoAttackSpell or "exevo vis mas", function(widget, text)
  storage.autoAttackSpell = text
end)

UI.Separator()
