--[[
  Author: Jackie_龍
  Date: 9.20.2015
  
      火遁．头刻苦  Q
      施法延迟:0.3
      伤        害: 立即杀死地方单位并获得50/100/150/200的额外收入   
      施法距离:500
      范         围:单体目标 
]]


function TouKeKu( keys )
 print("TouKeKu.....")
  -- Cannot cast multiple stacks
  if keys.caster.sleight_of_fist_active ~= nil and keys.caster.sleight_of_fist_action == true then
    keys.ability:RefundManaCost()
    return nil
  end

  -- 继承变量
  local caster = keys.caster--施法者
  local targetes = keys.target_entities--单位
  local ability = keys.ability--获取技能
  local targetPoint = keys.target_points[1]--目标点
  local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )--正常伤害倍数
  
  -- 目标变量
  local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY --目标所属团队：敌方单位
  local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO--目标所属的类型：基本单位和英雄
  local targetFlag = DOTA_UNIT_TARGET_FLAG_NO_INVIS--所要排除的单位：不是隐身的
  local unitOrder =  FIND_ANY_ORDER--查找方式：通过命令查找
  
  -- 必须变量
  caster.sleight_of_fist_active = true
  local int = caster:GetIntellect()  --获取智力

  -- 创建特效
  
  -- 功能实现
  print("...."..table.getn(targetes))
  for _, target in pairs( targetes ) do
    Timers:CreateTimer( 0.001, function()
        -- 单位活着
        if target:IsAlive() then
          -- 造成伤害
                local damageTable = {victim=target,    --受到伤害的单位
                attacker=caster,    --造成伤害的单位
                damage=damage * int,
                damage_type=DAMAGE_TYPE_MAGICAL}
                ApplyDamage(damageTable) 
        end 
        -- 移除特效  
  
          
        -- 清空buff
        return nil
      end)
  end

  
  caster.sleight_of_fist_active = false
end