local checkTerra = {2130}
local checkNew = {7928, 7931}

local function checkRune(check, thingy)
    if not check then return end
    local count = 0
    for x = -1, 1 do
        for y = -1, 1 do
        local tile = g_map.getTile({x = check.x + x, y = check.y + y, z = posz()})
            if tile and check then
                if tile:getTopUseThing() then
                    local thingId = tile:getTopUseThing():getId()
                    if table.find(thingy, thingId) and getDistanceBetween(pos(), check) > 1 then
                        count = count + 1
                    end
                end
            end
        end
    end
    return count
end

UI.Separator()