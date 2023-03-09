setDefaultTab("Tools")
local banderasAttacker = {
  [83] = {atk = 92},
  [114] = {atk = 0},
  [92] = {atk = 83},
  [0] = {atk = 114}
}
macro(100, "Target Banderas", "9", function()
  local target = g_game.getAttackingCreature()
  if target then return end
  if isInPz() then return end

  for _, n in ipairs(getSpectators(false)) do
    if n:isPlayer() then
      local selfOutfit = banderasAttacker[outfit().body]
      local enemigoOutfit = banderasAttacker[n:getOutfit().body]
      if selfOutfit ~= enemigoOutfit then
        attack(n)
      end
    end
  end
end)
UI.Separator()