  --[[
  Author: Jackie_龍
  Date: 9.1.2015
  
      唐松之舞  E
      伤        害: 延迟0.5/1.0/1.5/2.0秒后，对地方目标单位及其周围造成造成100/200/300/400的伤害   
      施法距离:720
      范        围:200 
]]


function Karamatsu_No_Mai( keys )
  print("Karamatsu_No_Mai.....")
  -- Cannot cast multiple stacks
  if keys.caster.sleight_of_fist_active ~= nil and keys.caster.sleight_of_fist_action == true then
    keys.ability:RefundManaCost()
    return nil
  end

  -- Inheritted variables
  local caster = keys.caster--施法者
  local target = keys.target--目标
  local targetPoint = keys.target_points[1]--目标点
  local ability = keys.ability--获取技能
  local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )--获取当前技能的施法范围
  --local attack_interval = ability:GetLevelSpecialValueFor( "attack_interval", ability:GetLevel() - 1 )--每次攻击的间隔
  local modifierEffectName = "modifier_effectName_datadriven"
  local modifierarmorIncreaseName = "modifier_armor_increase_caster_hero_datadriven"
  local modifierCreepName = "modifier_sleight_if_fist_target_creep_datadriven"
  local modifierEffect1Name = "particles/econ/items/sven/sven_warcry_ti5/sven_spell_warcry_ti_5.vpcf"
  local slashSound = "Hero_Sven.Layer.GodsStrength"
  
  -- Targeting variables
  local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY --目标所属团队：敌方单位
  local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO--目标所属的类型：基本单位和英雄
  local targetFlag = DOTA_UNIT_TARGET_FLAG_NO_INVIS--所要排除的单位：不是隐身的
  local unitOrder = FIND_ANY_ORDER--查找方式：通过命令查找
  
  -- Necessary varaibles
  caster.sleight_of_fist_active = true
  ability:ApplyDataDrivenModifier( caster, caster, modifierarmorIncreaseName, {} )
  
  -- Casting particles
  local castFxIndex = ParticleManager:CreateParticle( modifierEffectName, PATTACH_CUSTOMORIGIN, caster )--创建的粒子特效，得到一个数值
  ParticleManager:SetParticleControl( castFxIndex, 0, caster:GetOrigin() )
  
  Timers:CreateTimer( 2, function()
      ParticleManager:DestroyParticle( castFxIndex, false )--销毁castFxIndex
      ParticleManager:ReleaseParticleIndex( castFxIndex )
      
    end
  )
  
  -- Start function
  local castFxIndex = ParticleManager:CreateParticle( modifierEffect1Name, PATTACH_CUSTOMORIGIN, caster )--创建的粒子特效，得到一个数值
  local units = FindUnitsInRadius(
    caster:GetTeamNumber(), targetPoint, caster, radius, targetTeam,
    targetType, targetFlag, unitOrder, false
  )
  
  for _, target in pairs( units ) do
    Timers:CreateTimer( 0.5, function()
        -- Only jump to it if it's alive
        if target:IsAlive() then
          -- Create trail particles
          local damageTable = {victim=target,    --受到伤害的单位
          attacker=caster,    --造成伤害的单位
          damage=300,
          damage_type=DAMAGE_TYPE_MAGICAL}
          ApplyDamage(damageTable)    --造成伤害
        end
        return nil
      end
    )
  end
end