setDefaultTab("Cave")
local firstTime = now
local firstLevel = lvl()
local timeUp
local totalLevels

local expPerHourUI = setupUI([[
Panel
  height: 30

  Label
    id: label
    text: Levels por Hora:
    anchors.left: parent.left
    anchors.top: parent.top
    margin-left: 39
    color: #599dff
    text-align: center

  Label
    id: labelHour
    width: 150
    text: 0 (LvL * HR)
    anchors.left: parent.left
    anchors.top: prev.bottom
    margin-left: 13
    margin-top: 5
    color: #4ae842
    text-align: center
]])


local macroExpPerHour = macro(3000, function()
  timeUp = math.floor((now - firstTime) / 1000)
  totalLevels = math.floor(lvl() - firstLevel)
  local levelPerHour = math.floor( (3600 * totalLevels) / timeUp )
  expPerHourUI.labelHour:setText(""..levelPerHour.." (LvL * HR)")
end)