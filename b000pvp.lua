setDefaultTab("PvP")
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




