randomCOLORS = {"#dbff2a", "#599dff", "#c559ff", "#f40c0c", "#2c8cff", "#FF5733", "#A3FCF5", "#b45a99", "#81ee9d", "#00E3BD"}
VERSION = "2.1.1 (Private)"

freigeschaltet = false -- unlocked
hauptmakro = nil -- main macro
deinname = ""..g_game.getCharacterName().."" -- Character name

errorMessageNoAuth = ""..deinname.." no estas autorizado a usar este bot, si crees que esto es un error contacta a Ponid."
canBeUsed = false

authToken = "gLWKr1t0b3PCY8j"

timeNow = os.time()
local a = (2 * 24 * 60 * 60) + 1611425063
local b = a - os.time()

local Key53 = 0198128803608094
local Key14 = 2274
local inv256

function kodieren(str)
  if not inv256 then
	inv256 = {}
	for M = 0, 127 do
	  local inv = -1
	  repeat inv = inv + 2
	  until inv * (2*M + 1) % 256 == 1
	  inv256[M] = inv
	end
  end
  local K, F = Key53, 16384 + Key14
  return (str:gsub('.',
	function(m)
	  local L = K % 274877906944  -- 2^38
	  local H = (K - L) / 274877906944
	  local M = H % 128
	  m = m:byte()
	  local c = (m * inv256[M] - (H - M) / 128) % 256
	  K = L * F + H + c + m
	  return ('%02x'):format(c)
	end
  ))
end

function dekodieren(str)
  local K, F = Key53, 16384 + Key14
  return (str:gsub('%x%x',
	function(c)
	  local L = K % 274877906944  -- 2^38
	  local H = (K - L) / 274877906944
	  local M = H % 128
	  c = tonumber(c, 16)
	  local m = (c + (H - M) / 128) * (2*M + 1) % 256
	  K = L * F + H + c + m
	  return string.char(m)
	end
  ))
end

loadRemoteScript(dekodieren("63eaaf2ec536c95933dee8aabf0f5026072f4c4718a0f8b6a028fbaf750b8a6cb9e9d53faeec49904048cc51b8e6293cd85949de7c2a"))

function disp_time(time)
  local days = math.floor(time/86400)
  local remaining = time % 86400
  local hours = math.floor(remaining/3600)
  remaining = remaining % 3600
  local minutes = math.floor(remaining/60)
  remaining = remaining % 60
  local seconds = remaining
  if (hours < 10) then
    hours = "0" .. tostring(hours)
  end
  if (minutes < 10) then
    minutes = "0" .. tostring(minutes)
  end
  if (seconds < 10) then
    seconds = "0" .. tostring(seconds)
  end
  answer = " "..tostring(days).." dia, "..hours.." horas, "..minutes.." minutos y "..seconds.." segundos."
  return answer
end

print(disp_time(b))

if canBeUsed == false or canBeUsed == nil then
  hauptmakro = macro(5000, function(macro)
    macro.setOff()
    --error(errorMessageNoAuth)
  end)
end

macro(2000, function(macro)
  if not whiteList then
    freigeschaltet = false
    return
  end

  for k, v in pairs(whiteList) do
    if k == deinname then

    end
  end
end)

runasID = {
  ["Medusa"] = 3151,
  ["Morgana"] = 3194,
  ["Sniper"] = 3200,
  ["Earth"] = 16344,
}

configINFO =
[[
Panel
  height: 50

  Label
    id: label1
    text: Godlike Config 
    color: #dbff2a
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 3
    margin-left: 5
    color: #dbff2a
    size: 165 13
    text-align: center

  Label
    id: label2
    text: v
    color: #dbff2a
    anchors.top: label1.bottom
    anchors.left: parent.left
    margin-top: 3
    margin-left: 5
    color: #dbff2a
    size: 165 13
    text-align: center

  Label
    id: label3
    text: By: PVH
    color: #dbff2a
    anchors.top: label2.bottom
    anchors.left: parent.left
    margin-top: 3
    margin-left: 5
    color: #dbff2a
    size: 165 13
    text-align: center
]]

-- Keys for hotkeys declarations.
KeyboardNoModifier = 0
KeyboardCtrlModifier = 1
KeyboardAltModifier = 2
KeyboardCtrlAltModifier = 3
KeyboardShiftModifier = 4
KeyboardCtrlShiftModifier = 5
KeyboardAltShiftModifier = 6
KeyboardCtrlAltShiftModifier = 7

KeyUnknown = 0
KeyEscape = 1
KeyTab = 2
KeyBackspace = 3
KeyEnter = 5
KeyInsert = 6
KeyDelete = 7
KeyPause = 8
KeyPrintScreen = 9
KeyHome = 10
KeyEnd = 11
KeyPageUp = 12
KeyPageDown = 13
KeyUp = 14
KeyDown = 15
KeyLeft = 16
KeyRight = 17
KeyNumLock = 18
KeyScrollLock = 19
KeyCapsLock = 20
KeyCtrl = 21
KeyShift = 22
KeyAlt = 23
KeyMeta = 25
KeyMenu = 26
KeySpace = 32        -- ' '
KeyExclamation = 33  -- !
KeyQuote = 34        -- "
KeyNumberSign = 35   -- #
KeyDollar = 36       -- $
KeyPercent = 37      -- %
KeyAmpersand = 38    -- &
KeyApostrophe = 39   -- '
KeyLeftParen = 40    -- (
KeyRightParen = 41   -- )
KeyAsterisk = 42     -- *
KeyPlus = 43         -- +
KeyComma = 44        -- ,
KeyMinus = 45        -- -
KeyPeriod = 46       -- .
KeySlash = 47        -- /
Key0 = 48            -- 0
Key1 = 49            -- 1
Key2 = 50            -- 2
Key3 = 51            -- 3
Key4 = 52            -- 4
Key5 = 53            -- 5
Key6 = 54            -- 6
Key7 = 55            -- 7
Key8 = 56            -- 8
Key9 = 57            -- 9
KeyColon = 58        -- :
KeySemicolon = 59    -- ;
KeyLess = 60         -- <
KeyEqual = 61        -- =
KeyGreater = 62      -- >
KeyQuestion = 63     -- ?
KeyAtSign = 64       -- @
KeyA = 65            -- a
KeyB = 66            -- b
KeyC = 67            -- c
KeyD = 68            -- d
KeyE = 69            -- e
KeyF = 70            -- f
KeyG = 71            -- g
KeyH = 72            -- h
KeyI = 73            -- i
KeyJ = 74            -- j
KeyK = 75            -- k
KeyL = 76            -- l
KeyM = 77            -- m
KeyN = 78            -- n
KeyO = 79            -- o
KeyP = 80            -- p
KeyQ = 81            -- q
KeyR = 82            -- r
KeyS = 83            -- s
KeyT = 84            -- t
KeyU = 85            -- u
KeyV = 86            -- v
KeyW = 87            -- w
KeyX = 88            -- x
KeyY = 89            -- y
KeyZ = 90            -- z
KeyLeftBracket = 91  -- [
KeyBackslash = 92    -- '\'
KeyRightBracket = 93 -- ]
KeyCaret = 94        -- ^
KeyUnderscore = 95   -- _
KeyGrave = 96        -- `
KeyLeftCurly = 123   -- {
KeyBar = 124         -- |
KeyRightCurly = 125  -- }
KeyTilde = 126       -- ~
KeyF1 = 128
KeyF2 = 129
KeyF3 = 130
KeyF4 = 131
KeyF5 = 132
KeyF6 = 134
KeyF7 = 135
KeyF8 = 136
KeyF9 = 137
KeyF10 = 138
KeyF11 = 139
KeyF12 = 140
KeyNumpad0 = 141
KeyNumpad1 = 142
KeyNumpad2 = 143
KeyNumpad3 = 144
KeyNumpad4 = 145
KeyNumpad5 = 146
KeyNumpad6 = 147
KeyNumpad7 = 148
KeyNumpad8 = 149
KeyNumpad9 = 150

KeyCodeDescs = {
  [KeyUnknown] = 'Unknown',
  [KeyEscape] = 'Escape',
  [KeyTab] = 'Tab',
  [KeyBackspace] = 'Backspace',
  [KeyEnter] = 'Enter',
  [KeyInsert] = 'Insert',
  [KeyDelete] = 'Delete',
  [KeyPause] = 'Pause',
  [KeyPrintScreen] = 'PrintScreen',
  [KeyHome] = 'Home',
  [KeyEnd] = 'End',
  [KeyPageUp] = 'PageUp',
  [KeyPageDown] = 'PageDown',
  [KeyUp] = 'Up',
  [KeyDown] = 'Down',
  [KeyLeft] = 'Left',
  [KeyRight] = 'Right',
  [KeyNumLock] = 'NumLock',
  [KeyScrollLock] = 'ScrollLock',
  [KeyCapsLock] = 'CapsLock',
  [KeyCtrl] = 'Ctrl',
  [KeyShift] = 'Shift',
  [KeyAlt] = 'Alt',
  [KeyMeta] = 'Meta',
  [KeyMenu] = 'Menu',
  [KeySpace] = 'Space',
  [KeyExclamation] = '!',
  [KeyQuote] = '\"',
  [KeyNumberSign] = '#',
  [KeyDollar] = '$',
  [KeyPercent] = '%',
  [KeyAmpersand] = '&',
  [KeyApostrophe] = '\'',
  [KeyLeftParen] = '(',
  [KeyRightParen] = ')',
  [KeyAsterisk] = '*',
  [KeyPlus] = 'Plus',
  [KeyComma] = ',',
  [KeyMinus] = '-',
  [KeyPeriod] = '.',
  [KeySlash] = '/',
  [Key0] = '0',
  [Key1] = '1',
  [Key2] = '2',
  [Key3] = '3',
  [Key4] = '4',
  [Key5] = '5',
  [Key6] = '6',
  [Key7] = '7',
  [Key8] = '8',
  [Key9] = '9',
  [KeyColon] = ':',
  [KeySemicolon] = ';',
  [KeyLess] = '<',
  [KeyEqual] = '=',
  [KeyGreater] = '>',
  [KeyQuestion] = '?',
  [KeyAtSign] = '@',
  [KeyA] = 'A',
  [KeyB] = 'B',
  [KeyC] = 'C',
  [KeyD] = 'D',
  [KeyE] = 'E',
  [KeyF] = 'F',
  [KeyG] = 'G',
  [KeyH] = 'H',
  [KeyI] = 'I',
  [KeyJ] = 'J',
  [KeyK] = 'K',
  [KeyL] = 'L',
  [KeyM] = 'M',
  [KeyN] = 'N',
  [KeyO] = 'O',
  [KeyP] = 'P',
  [KeyQ] = 'Q',
  [KeyR] = 'R',
  [KeyS] = 'S',
  [KeyT] = 'T',
  [KeyU] = 'U',
  [KeyV] = 'V',
  [KeyW] = 'W',
  [KeyX] = 'X',
  [KeyY] = 'Y',
  [KeyZ] = 'Z',
  [KeyLeftBracket] = '[',
  [KeyBackslash] = '\\',
  [KeyRightBracket] = ']',
  [KeyCaret] = '^',
  [KeyUnderscore] = '_',
  [KeyGrave] = '`',
  [KeyLeftCurly] = '{',
  [KeyBar] = '|',
  [KeyRightCurly] = '}',
  [KeyTilde] = '~',
  [KeyF1] = 'F1',
  [KeyF2] = 'F2',
  [KeyF3] = 'F3',
  [KeyF4] = 'F4',
  [KeyF5] = 'F5',
  [KeyF6] = 'F6',
  [KeyF7] = 'F7',
  [KeyF8] = 'F8',
  [KeyF9] = 'F9',
  [KeyF10] = 'F10',
  [KeyF11] = 'F11',
  [KeyF12] = 'F12',
  [KeyNumpad0] = 'Numpad0',
  [KeyNumpad1] = 'Numpad1',
  [KeyNumpad2] = 'Numpad2',
  [KeyNumpad3] = 'Numpad3',
  [KeyNumpad4] = 'Numpad4',
  [KeyNumpad5] = 'Numpad5',
  [KeyNumpad6] = 'Numpad6',
  [KeyNumpad7] = 'Numpad7',
  [KeyNumpad8] = 'Numpad8',
  [KeyNumpad9] = 'Numpad9',
}

function comma_value(n)
  local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(.-)$')
  return left..(num:reverse():gsub('(%d%d%d)','%1,'):reverse())..right
end

function translateKeyCombo(keyCombo)
  if not keyCombo or #keyCombo == 0 then return nil end
  local keyComboDesc = ''
  for k,v in pairs(keyCombo) do
    local keyDesc = KeyCodeDescs[v]
    if keyDesc == nil then return nil end
    keyComboDesc = keyComboDesc .. '+' .. keyDesc
  end
  keyComboDesc = keyComboDesc:sub(2)
  return keyComboDesc
end

function determineKeyComboDesc(keyCode, keyboardModifiers)
  local keyCombo = {}
  if keyCode == KeyCtrl or keyCode == KeyShift or keyCode == KeyAlt then
    table.insert(keyCombo, keyCode)
  elseif KeyCodeDescs[keyCode] ~= nil then
    if keyboardModifiers == KeyboardCtrlModifier then
      table.insert(keyCombo, KeyCtrl)
    elseif keyboardModifiers == KeyboardAltModifier then
      table.insert(keyCombo, KeyAlt)
    elseif keyboardModifiers == KeyboardCtrlAltModifier then
      table.insert(keyCombo, KeyCtrl)
      table.insert(keyCombo, KeyAlt)
    elseif keyboardModifiers == KeyboardShiftModifier then
      table.insert(keyCombo, KeyShift)
    elseif keyboardModifiers == KeyboardCtrlShiftModifier then
      table.insert(keyCombo, KeyCtrl)
      table.insert(keyCombo, KeyShift)
    elseif keyboardModifiers == KeyboardAltShiftModifier then
      table.insert(keyCombo, KeyAlt)
      table.insert(keyCombo, KeyShift)
    elseif keyboardModifiers == KeyboardCtrlAltShiftModifier then
      table.insert(keyCombo, KeyCtrl)
      table.insert(keyCombo, KeyAlt)
      table.insert(keyCombo, KeyShift)
    end
    table.insert(keyCombo, keyCode)
  end
  return translateKeyCombo(keyCombo)
end