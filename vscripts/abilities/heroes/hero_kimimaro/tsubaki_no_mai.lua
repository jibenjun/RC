--[[
  Author: Jackie_龍
  Date: 9.1.2015
  
      椿之舞  W
      伤        害: 延迟0.5/1.0/1.5/2.0秒后，对地方目标单位及其周围造成造成100/200/300/400的伤害   
      施法距离:720
      范        围:200 
]]


function TsubakiNoMai( keys )
  print("TsubakiNoMai.....")
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
  --local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )--获取当前技能的施法范围
  --local attack_interval = ability:GetLevelSpecialValueFor( "attack_interval", ability:GetLevel() - 1 )--每次攻击的间隔
  local modifierTargetName = "modifier_sleight_of_fist_target_datadriven"
  local modifierHeroName = "modifier_sleight_of_fist_target_hero_datadriven"
  local modifierCreepName = "modifier_sleight_if_fist_target_creep_datadriven"
  local dummyModifierName = "modifier_sleight_of_fist_dummy_datadriven"
  local particleSlashName = "particles/units/heroes/hero_bane/bane_fiends_grip.vpcf"
  local particleTrailName = "particles/units/heroes/hero_silencer/silencer_last_word_status.vpcf"
  local particleCastName = "particles/units/heroes/hero_siren/naga_siren_mirror_image.vpcf"
  local slashSound = "Hero_EmberSpirit.SleightOfFist.Damage"
  
  -- Targeting variables
  local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY --目标所属团队：敌方单位
  local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO--目标所属的类型：基本单位和英雄
  local targetFlag = DOTA_UNIT_TARGET_FLAG_NO_INVIS--所要排除的单位：不是隐身的
  local unitOrder = FIND_ANY_ORDER--查找方式：通过命令查找
  
  -- Necessary varaibles
 
  -- Casting particles
  local castFxIndex = ParticleManager:CreateParticle( particleCastName, PATTACH_CUSTOMORIGIN, caster )--创建的粒子特效，得到一个数值
  ParticleManager:SetParticleControl( castFxIndex, 0, caster:GetOrigin() )
  ParticleManager:SetParticleControl( castFxIndex, 1, Vector( 500, 0, 0 ) )
  
  Timers:CreateTimer( 10, function()
      ParticleManager:DestroyParticle( castFxIndex, false )--销毁castFxIndex
      ParticleManager:ReleaseParticleIndex( castFxIndex )
    end
  )
  
  -- Start function
  local castFxIndex = ParticleManager:CreateParticle( particleCastName, PATTACH_CUSTOMORIGIN, caster )--创建的粒子特效，得到一个数值
  local units = FindUnitsInRadius(
    caster:GetTeamNumber(), targetPoint, caster, 200, targetTeam,
    targetType, targetFlag, unitOrder, false
  )
  
  for _, target in pairs( units ) do
    ability:ApplyDataDrivenModifier( caster, target, modifierTargetName, {} )
    Timers:CreateTimer( 0.5, function()
        -- Only jump to it if it's alive
        if target:IsAlive() then
          -- Create trail particles
          local trailFxIndex = ParticleManager:CreateParticle( particleTrailName, PATTACH_CUSTOMORIGIN, target )
          ParticleManager:SetParticleControl( trailFxIndex, 0, target:GetAbsOrigin() )
          
          Timers:CreateTimer( 1, function()
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
  Timers:CreateTimer(1, function()
      caster:RemoveModifierByName( dummyModifierName )
      caster.sleight_of_fist_active = false
      return nil
    end
  )
end