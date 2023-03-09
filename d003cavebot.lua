setDefaultTab("Cave")

UI.Separator()


CaveBot = {} -- global namespace
CaveBot.Extensions = {}
importStyle("/cavebot/cavebot.otui")
importStyle("/cavebot/config.otui")
importStyle("/cavebot/editor.otui")
importStyle("/cavebot/supply.otui")
dofile("/cavebot/actions.lua")
dofile("/cavebot/config.lua")
dofile("/cavebot/editor.lua")
dofile("/cavebot/example_functions.lua")
dofile("/cavebot/recorder.lua")
dofile("/cavebot/walking.lua")
-- in this section you can add extensions, check extension_template.lua
--dofile("/cavebot/extension_template.lua")
dofile("/cavebot/depositer.lua")
dofile("/cavebot/supply.lua")
-- main cavebot file, must be last


-- main cavebot file, must be last

local expPerHourUI = setupUI([[
Panel
  height: 20

  Label
    id: label
    text: CaveBot
    anchors.left: parent.left
    anchors.top: parent.top
    margin-left: 60
    color: #dbff25
    text-align: center
]])
dofile("/cavebot/cavebot.lua")

UI.Separator()

TargetBot = {} -- global namespace
local expPerHourUI = setupUI([[
Panel
  height: 20

  Label
    id: label
    text: Targetting
    anchors.left: parent.left
    anchors.top: parent.top
    margin-left: 50
    color: #25ffc4
    text-align: center
]])
importStyle("/targetbot/looting.otui")
importStyle("/targetbot/target.otui")
importStyle("/targetbot/creature_editor.otui")
dofile("/targetbot/creature.lua")
dofile("/targetbot/creature_attack.lua")
dofile("/targetbot/creature_editor.lua")
dofile("/targetbot/creature_priority.lua")
dofile("/targetbot/looting.lua")
dofile("/targetbot/walking.lua")
-- main targetbot file, must be last
dofile("/targetbot/target.lua")