--[[
  Author: Jackie_龍
  Date: 9.1.2015
  
      瞬身之术  E
      施法延迟:0.5/1.0/1.5/2.0
      伤        害: 对地方目标单位及其周围造成造成100/200/300/400的伤害   
      施法距离:720
      范         围:200 
]]

--瞬身之术  E
function TransientBodyE( keys )
  print("TransientBodyE.....")
  local caster = keys.caster       --获取施法者
  local target = keys.target
  local al = keys.ability:GetLevel() - 1   --获取技能等级，并且减1
  local c_team = caster:GetTeam()   --获取施法者所在的队伍
  local tgo = target:GetOrigin()    --获取目标的位置，及三围坐标
  local damage = keys.ability:GetLevelSpecialValueFor("damage", al)   --造成伤害

  local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
  local types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
  local flags = DOTA_UNIT_TARGET_FLAG_NONE
  FindClearSpaceForUnit(caster, target:GetAbsOrigin(), true) --unit1:施法者，point:目标矢量
  GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("W"),
  function()
    local damageTable = {victim=target,    --受到伤害的单位
              attacker=caster,    --造成伤害的单位
              damage=damage,
              damage_type=DAMAGE_TYPE_MAGICAL}
              ApplyDamage(damageTable)    --造成伤害
  end,0.3)
end