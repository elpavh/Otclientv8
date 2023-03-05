setDefaultTab("PvP")

local name = ""..g_game.getCharacterName()..""
local panelName = "targetLeader"
local toAttack = nil

if not storage[panelName .. name] then
storage[panelName .. name] = {
    attackLeader = "Nombre del Lider"
}
end

onMissle(function(missle)
    if not storage[panelName .. name].attackLeader or storage[panelName .. name].attackLeader:len() == 0 then
        return
    end
    local src = missle:getSource()
    if src.z ~= posz() then
        return
    end
    local from = g_map.getTile(src)
    local to = g_map.getTile(missle:getDestination())
    if not from or not to then
        return
    end
    local fromCreatures = from:getCreatures()
    local toCreatures = to:getCreatures()
    if #fromCreatures ~= 1 or #toCreatures ~= 1 then
        return
    end
    local c1 = fromCreatures[1]
    if c1:getName():lower() == storage[panelName .. name].attackLeader:lower() then
        toAttack = toCreatures[1]
    end
end)

macro(50, "Attack Leader", nil, function()
    if isInPz() then return end
    if toAttack and storage[panelName .. name].attackLeader:len() > 0 and toAttack ~= g_game.getAttackingCreature() then
        if toAttack:getName() ~= storage[panelName .. name].attackLeader then
            g_game.cancelAttack()
            g_game.attack(toAttack)
            toAttack = nil
        end
    end
end)

addTextEdit("attackLeader", storage[panelName .. name].attackLeader or "Nombre del Lider", function(widget, text)
    storage[panelName .. name].attackLeader = text
end)

UI.Separator()