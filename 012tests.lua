-- Poni Tests --
-- local msg = "17:46 You see an exercise rod that has 171 charges left. It weighs 10.00 oz."

--UI.Button("Force Logout", function()
--    logout()
--end)

--addTextEdit("nombrePlayer", storage.nombrePlayer or "Rollback", function(widget, text)
--    storage.nombrePlayer = text
--end)
--UI.Button("Buscar Personaje", function()
--  g_platform.openUrl("https://www.armada-azteca.com/characterprofile.php?name="..storage.nombrePlayer.."")
--end)
--UI.Button("Ver Deathlist", function()
--    say('!deathlist "'..storage.nombrePlayer..'')
 -- end)

  UI.Separator()
  UI.Label("Follow Player:")
addTextEdit("playerToFollow", storage.followLeader or "Rollback", function(widget, text)
    storage.followLeader = text
    target = tostring(text) -- Actualizar el target dinámicamente.
end)



UI.Separator()
local followThis = tostring(storage.followLeader)

FloorChangers = {
	Ladders = {
		Up = {1948, 5542, 16693, 16692},
		Down = {432, 412, 469, 1949, 469}
	},

	Holes = {
		Up = {},
		Down = {293, 294, 595, 4728, 385, 9853}
	},

	RopeSpots = {
		Up = {386,},
		Down = {}
	},

	Stairs = {
		Up = {16690, 1958, 7548, 7544, 1952, 1950, 1947, 7542, 855, 856, 1978, 1977, 6911, 6915, 1954, 5259, 20492, 1956, 1957, 1955, 5257},
		Down = {482, 414, 413, 437, 7731, 469, 413, 434, 469, 859, 438, 6127, 566, 7476, 4826}
	},

	Sewers = {
		Up = {},
		Down = {435}
	},
}

local target = followThis
local lastKnownPosition

local function goLastKnown()
	if getDistanceBetween(pos(), {x = lastKnownPosition.x, y = lastKnownPosition.y, z = lastKnownPosition.z}) > 1 then
		local newTile = g_map.getTile({x = lastKnownPosition.x, y = lastKnownPosition.y, z = lastKnownPosition.z})
		if newTile then
			g_game.use(newTile:getTopUseThing())
			delay(math.random(300, 700))
		end
	end
end

local function handleUse(pos)
	goLastKnown()
	local lastZ = posz()
	if posz() == lastZ then
		local newTile = g_map.getTile({x = pos.x, y = pos.y, z = pos.z})
		if newTile then
			g_game.use(newTile:getTopUseThing())
			delay(math.random(400, 800))
		end
	end
end

local function handleStep(pos)
	goLastKnown()
	local lastZ = posz()
	if posz() == lastZ then
		autoWalk(pos)
		delay(math.random(400, 800))
	end
end

local function handleRope(pos)
	goLastKnown()
	local lastZ = posz()
	if posz() == lastZ then
		local newTile = g_map.getTile({x = pos.x, y = pos.y, z = pos.z})
		if newTile then
			useWith(3003, newTile:getTopUseThing())
			delay(math.random(400, 800))
		end
	end
end

local floorChangeSelector = {
	Ladders = {Up = handleUse, Down = handleStep},
	Holes = {Up = handleStep, Down = handleStep},
	RopeSpots = {Up = handleRope, Down = handleRope},
	Stairs = {Up = handleStep, Down = handleStep},
	Sewers = {Up = handleUse, Down = handleUse},
}

local function checkTargetPos()
	local c = getCreatureByName(target)
	if c and c:getPosition().z == posz() then
		lastKnownPosition = c:getPosition()
	end
end

local function distance(pos1, pos2)
	local pos2 = pos2 or lastKnownPosition or pos()
	return math.abs(pos1.x - pos2.x) + math.abs(pos1.y - pos2.y)
end

local function executeClosest(possibilities)
	local closest
	local closestDistance = 99999
	for _, data in ipairs(possibilities) do
		local dist = distance(data.pos)
		if dist < closestDistance then
			closest = data
			closestDistance = dist
		end
	end

	if closest then
		closest.changer(closest.pos)
	end
end

local function handleFloorChange()
	local c = getCreatureByName(target)
	local range = 2
	local p = pos()
	local possibleChangers = {}
	for _, dir in ipairs({"Down", "Up"}) do
		for changer, data in pairs(FloorChangers) do
			for x = -range, range do
				for y = -range, range do
					local tile = g_map.getTile({x = p.x + x, y = p.y + y, z = p.z})
					if tile then
						if table.find(data[dir], tile:getTopUseThing():getId()) then
							table.insert(possibleChangers, {changer = floorChangeSelector[changer][dir], pos = {x = p.x + x, y = p.y + y, z = p.z}})
						end
					end
				end
			end
		end
	end
	executeClosest(possibleChangers)
end

local function targetMissing()
	for _, n in ipairs(getSpectators(false)) do
		if n:getName() == target then
			return n:getPosition().z ~= posz()
		end
	end
	return true
end


macro(500, "Advanced Follow", "", function(macro)
	if not macro:isOn() then
        g_keyboard.pressKey("Escape")
        return
    end
	if not target or target == "" then
        return warn("Target is empty or invalid.")
    end
	local c = getCreatureByName(target)

    local c = getCreatureByName(target)

    if c then
        if getDistanceBetween(pos(), c:getPosition()) > 1 then
            if not g_game.isFollowing() or g_game.getFollowingCreature() ~= c then
                g_game.follow(c)
            end
        end
        checkTargetPos()
    elseif lastKnownPosition then
        handleFloorChange()
    else
        print("Target not found and no last known position.")
    end
end)
UI.Separator()

-- local search = 'that has (%d+) charges left'
-- local excerciseID = 9599
-- local chargesLeft = 50 -- Once you have this charges in the configured ID the script will take you to the label specified in label.
-- local label = "test2" -- Specify the label for your cavebot to go to once you have the charges specified.
-- macro(5000, "DO Charges", function()
--     local containers = g_game.getContainers()
--     for _, container in pairs(containers) do
--         for _, item in ipairs(container:getItems()) do
--             if item:getId() == excerciseID then
--                 g_game.look(item)
--             end
--         end
--     end
-- end)

-- onTextMessage(function(mode, text)
--     if mode ~= 20 then return end
--     for r in string.gmatch(msg, search) do
--         if tonumber(r) <= chargesLeft then
--             CaveBot.gotoLabel(label)
--             CaveBot.setOn()
--         end
--     end
-- end)

-- onMissle(function(missle)
--       local src = missle:getSource()
--       local src2 = missle:getDestination()
--       if src.z ~= posz() then
--         return
--       end
--       local shooterTile = g_map.getTile(src)
--       local destTile = g_map.getTile(src2)
--       if shooterTile and destTile then
--         local creatures = shooterTile:getCreatures()
--         local destEffects = destTile:getEffects()
--         for _, i in ipairs(destEffects) do  end
--         if player:getName() == creatures[1]:getName() then
--             print(missle:getId())
--         end
--     end
--   end)

--macro(300, "Shot Morgana on Free SQM", function()
--    local target = g_game.getAttackingCreature()
--    if not target then return end
--
--    local tile = target:getTile()
--    if not tile then return end
--    local tilePos = tile:getPosition()
--    for x = -1, 1 do
--        for y = 0, 1 do
--            local shotPos = g_map.getTile({x = tilePos.x + x, y = tilePos.y + y, z = posz()})
--            if not shotPos then return end
--            if shotPos ~= tile:getPosition() then
--                local path = findPath(pos(), shotPos:getPosition(), 7, {ignoreCreatures = false, ignoreNonPathable = true, ignoreCost = true, precision = 1})
--
--                local terraID = shotPos:getTopUseThing():getId()
--               if terraID then
--                    useWith(3194, shotPos:getTopUseThing())
--                    return
--                end
--
--                if path then
--                    useWith(3194, shotPos:getTopUseThing())
--                    delay(1000)
--                end
--            end
--        end
--    end
--end)


-- Medusa on Free SQM --
--[[
    local target = g_game.getAttackingCreature()
    if not target then return end

    local tile = target:getTile()
    if not tile then return end
    local tilePos = tile:getPosition()
    for x = -1, 1 do
        for y = -1, 1 do
            local shotPos = g_map.getTile({x = tilePos.x + x, y = tilePos.y + y, z = posz()})
            if not shotPos then return end
            if shotPos ~= tile:getPosition() then
                local path = findPath(pos(), shotPos:getPosition(), 7, {ignoreCreatures = false, ignoreNonPathable = false, ignoreCost = true})
                if path then
                    useWith(3151, shotPos:getTopUseThing())
                    delay(1000)
                end
            end
        end
    end
]]

UI.Separator()