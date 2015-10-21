--[[
  Author: Jackie_龍
  Date: 9.1.2015
  
      时空标记 Q
      施法延迟:0.5/1.0/1.5/2.0
      伤        害:对敌方目标单位及其周围造成造成100/200/300/400的伤害
      施法距离:500
      范         围:250     
]]

--时空标记 Q
function MarkE( keys )
  print("MarkE.....")
  local caster = keys.caster
  local target = keys.target
  local c_team = caster:GetTeam()   --获取施法者所在的队伍
  local al = keys.ability:GetLevel() - 1   --获取技能等级，并且减1
  local radius = keys.radius   --设置范围
  local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
  local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
  local flags = DOTA_UNIT_TARGET_FLAG_NONE
  local damage = keys.ability:GetLevelSpecialValueFor("damage", al)
  local duration = keys.duration
  local tgo = target:GetOrigin()
  --判断单位是否死亡，是否存在，是否被击晕
  if caster:IsAlive() and IsValidEntity(caster) and not(caster:IsStunned()) then
    --不是死亡，存在这个单位，没被击晕，就运行这里面的内容
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("yidong"),
    function()
      FindClearSpaceForUnit(target, tgo, true) --caster:施法者，point:目标矢量，
      --创建特效
      local particleID = ParticleManager:CreateParticle(keys.effect_name, PATTACH_ABSORIGIN_FOLLOW,target)
      --我们将施法者的所在的三维坐标传给了CP0
      ParticleManager:SetParticleControl(particleID,0,target:GetOrigin())
      ParticleManager:SetParticleControl(particleID,1,target:GetOrigin())
      --获取范围内的单位，效率不是很高，在计时器里面注意使用
      local targets = FindUnitsInRadius(c_team, tgo, nil, radius, teams, types, flags, FIND_CLOSEST, true)
      --利用Lua的循环迭代，循环遍历每一个单位组内的单位
      for i,unit in pairs(targets) do
        local damageTable = {victim=unit,    --受到伤害的单位
          attacker=caster,    --造成伤害的单位
          damage=damage,
          damage_type=DAMAGE_TYPE_MAGICAL}
        ApplyDamage(damageTable)    --造成伤害
      end
    end,duration)
  end

end