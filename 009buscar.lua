local panelName = "buscarSetup"
local name = ""..g_game.getCharacterName()..""
local firstTime = true

local info = {
  ["Level"] = {str = 'Level%s*</td>%s*<td>(%d+)<'},
  ["Vocation"] = {str = 'Vocation%s*</td>%s*<td>(.-)%<'},
  ["Status"] = {str = 'Status</td>%s*<td>(%a+)<'},
  ["Login"] = {str = 'Last Login</td>%s*<td>(.-)%<'},
  ["Ultimo"] = {str = 'Last Logout</td>%s*<td>(.-)%<'}
}
local buscarUI = setupUI([[
Panel
  height: 40

  Button
    id: buscar
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 17
    text: Buscar Personaje

  BotTextEdit
    id: text
    text: Rollback
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: buscar.bottom
    margin-top: 3
    margin-bottom: 3
    text-align: center
]])

if not storage[panelName .. name] then
  storage[panelName .. name] = {
    name = "Rollback"
  }
end

mainWidget = g_ui.getRootWidget()
buscarWindow = g_ui.createWidget("BuscarWindow", mainWidget)
buscarWindow:hide()

buscarUI.text:setText(storage[panelName .. name].name)
buscarWindow.text:setText(storage[panelName .. name].name)

local function resetDefault()
  buscarWindow.buscar.label2:setText("PERSONAJE NO EXISTE")
  buscarWindow.buscar.label4:setText("PERSONAJE NO EXISTE")
  buscarWindow.buscar.label6:setText("PERSONAJE NO EXISTE")
  buscarWindow.buscar.label8:setText("PERSONAJE NO EXISTE")
  buscarWindow.buscar.label10:setText("PERSONAJE NO EXISTE")
  buscarWindow.buscar.label12:setText("PERSONAJE NO EXISTE")
end

local function updateText()
  local levelflag = false
  local vocationflag = false
  local statusflag = false
  resetDefault()
  HTTP.get("https://armada-azteca.com/characterprofile.php?name="..buscarUI.text:getText().."", function(data, err)
    if err then return warn("HTTP error") end
    local result = string.gsub(tostring(data), "%,", "")
    for k, s in pairs(info) do
      for r in string.gmatch(result, s.str) do
        if k == "Level" then
          levelflag = true
          buscarWindow.buscar.label4:setText(comma_value(r)) -- Nivel
        elseif k == "Vocation" then
          buscarWindow.buscar.label6:setText(r) -- Vocation
        elseif k == "Status" then -- Esta On/Off
          if r:find("offline") then
            buscarWindow.buscar.label8:setColor("#f40c0c")
            buscarWindow.buscar.label8:setText("Offline")
          elseif r:find("online") then
            buscarWindow.buscar.label12:setText("Esta Online!")
            buscarWindow.buscar.label12:setColor("#2cff3c")
            buscarWindow.buscar.label8:setColor("#2cff3c")
            buscarWindow.buscar.label8:setText("Online")
          end
        elseif k == "Login" then
          buscarWindow.buscar.label10:setText(r) -- Last Login
        elseif k == "Ultimo" then
          buscarWindow.buscar.label12:setColor("#f40c0c")
          buscarWindow.buscar.label12:setText(r) -- Tiempo Off
        end
      end
    end
    buscarWindow.buscar.label2:setText(buscarUI.text:getText()) -- Name
  end)
end

buscarUI.buscar.onClick = function(widget)
	if buscarWindow:isVisible() then
    buscarWindow:hide()
    return
  end

  updateText()

  buscarWindow:show()
  buscarWindow:focus()
end

buscarWindow.close.onClick = function(widget)
  buscarWindow:hide()
end

buscarWindow.get.onClick = function(widget)
  updateText()
end

buscarWindow.buscar.deathList.onClick = function(widget)
  say('!deathlist  "'..buscarUI.text:getText()..'')
end

buscarUI.text.onTextChange = function(widget, text)
  buscarWindow.text:setText(text)
  storage[panelName .. name].name = text
end

buscarWindow.text.onTextChange = function(widget, text)
  buscarUI.text:setText(text)
  storage[panelName .. name].name = text
  updateText()
end

--UI.Button("Armada Facebook", function()
--  g_platform.openUrl("https://www.facebook.com/armadaazteca/")
--end)

UI.Button("Force Logout", function()
    logout()
end)


UI.Separator()