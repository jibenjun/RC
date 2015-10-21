--[[
  Author: Jackie_龍
  Date: 9.1.2015
  
      飞雷神之术 D
       施法延迟:0.3
      伤        害:对范围内目标造成当前力量*10的伤害  
      施法距离:600
      范         围:500 
]]

-- 飞雷神之术 D
function HiraiJinNojiYutsu( keys )
  print("HiraiJinNojiYutsu.....")
  -- Cannot cast multiple stacks
  if keys.caster.sleight_of_fist_active ~= nil and keys.caster.sleight_of_fist_action == true then
    keys.ability:RefundManaCost()
    return nil
  end

  -- Inheritted variables
  local caster = keys.caster--施法者
  local targetPoint = keys.target_points[1]--目标点
  local ability = keys.ability--获取技能
  local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )--获取当前技能的施法范围
  local attack_interval = ability:GetLevelSpecialValueFor( "attack_interval", ability:GetLevel() - 1 )--每次攻击的间隔
  local modifierTargetName = "modifier_sleight_of_fist_target_datadriven"
  local modifierHeroName = "modifier_sleight_of_fist_target_hero_datadriven"
  local modifierCreepName = "modifier_sleight_if_fist_target_creep_datadriven"
  local casterModifierName = "modifier_sleight_of_fist_caster_datadriven"
  local dummyModifierName = "modifier_sleight_of_fist_dummy_datadriven"
  local particleSlashName = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt.vpcf"
  local particleTrailName = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf"
  local particleCastName = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf"
  local slashSound = "Hero_EmberSpirit.SleightOfFist.Damage"
  
  -- Targeting variables
  local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY --目标所属团队：敌方单位
  local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO--目标所属的类型：基本单位和英雄
  local targetFlag = DOTA_UNIT_TARGET_FLAG_NO_INVIS--所要排除的单位：不是隐身的
  local unitOrder = FIND_ANY_ORDER--查找方式：通过命令查找
  
  -- Necessary varaibles
  local counter = 0
  caster.sleight_of_fist_active = true
  local dummy = CreateUnitByName( caster:GetName(), caster:GetAbsOrigin(), false, caster, nil, caster:GetTeamNumber() )
  ability:ApplyDataDrivenModifier( caster, dummy, dummyModifierName, {} )
  
  -- Casting particles
  local castFxIndex = ParticleManager:CreateParticle( particleCastName, PATTACH_CUSTOMORIGIN, caster )--创建的粒子特效，得到一个数值
  ParticleManager:SetParticleControl( castFxIndex, 0, targetPoint )
  ParticleManager:SetParticleControl( castFxIndex, 1, Vector( radius, 0, 0 ) )
  
  Timers:CreateTimer( 0.1, function()
      ParticleManager:DestroyParticle( castFxIndex, false )--销毁castFxIndex
      ParticleManager:ReleaseParticleIndex( castFxIndex )
    end
  )
  
  -- Start function
  local castFxIndex = ParticleManager:CreateParticle( particleCastName, PATTACH_CUSTOMORIGIN, caster )--创建的粒子特效，得到一个数值
  local units = FindUnitsInRadius(
    caster:GetTeamNumber(), targetPoint, caster, radius, targetTeam,
    targetType, targetFlag, unitOrder, false
  )
  
  for _, target in pairs( units ) do
    counter = counter + 1
    ability:ApplyDataDrivenModifier( caster, target, modifierTargetName, {} )
    Timers:CreateTimer( counter * attack_interval, function()
        -- Only jump to it if it's alive
        if target:IsAlive() then
          -- Create trail particles
          local trailFxIndex = ParticleManager:CreateParticle( particleTrailName, PATTACH_CUSTOMORIGIN, target )
          ParticleManager:SetParticleControl( trailFxIndex, 0, target:GetAbsOrigin() )
          ParticleManager:SetParticleControl( trailFxIndex, 1, caster:GetAbsOrigin() )
          
          Timers:CreateTimer( 0.1, function()
              ParticleManager:DestroyParticle( trailFxIndex, false )
              ParticleManager:ReleaseParticleIndex( trailFxIndex )
              return nil
            end
          )
          
          -- Move hero there
          FindClearSpaceForUnit( caster, target:GetAbsOrigin(), false )--在未被占用的敌方创建英雄
          
          if target:IsHero() then
            ability:ApplyDataDrivenModifier( caster, caster, modifierHeroName, {} )
          else
            ability:ApplyDataDrivenModifier( caster, caster, modifierCreepName, {} )
          end
          
          caster:PerformAttack( target, true, false, true, false )
          
          -- Slash particles
          local slashFxIndex = ParticleManager:CreateParticle( particleSlashName, PATTACH_ABSORIGIN_FOLLOW, target )
          StartSoundEvent( slashSound, caster )
          
          Timers:CreateTimer( 0.1, function()
              ParticleManager:DestroyParticle( slashFxIndex, false )
              ParticleManager:ReleaseParticleIndex( slashFxIndex )
              StopSoundEvent( slashSound, caster )
              return nil
            end
          )
          
          -- Clean up modifier
          caster:RemoveModifierByName( modifierHeroName )
          caster:RemoveModifierByName( modifierCreepName )
          target:RemoveModifierByName( modifierTargetName )
        end
        return nil
      end
    )
  end
  
  -- Return caster to origin position
  Timers:CreateTimer( ( counter + 1 ) * attack_interval, function()
      FindClearSpaceForUnit( caster, dummy:GetAbsOrigin(), false )
      dummy:RemoveSelf()
      caster:RemoveModifierByName( casterModifierName )
      caster.sleight_of_fist_active = false
      return nil
    end
  )
end