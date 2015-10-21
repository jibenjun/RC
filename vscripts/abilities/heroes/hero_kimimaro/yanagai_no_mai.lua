 --[[
  Author: Jackie_龍
  Date: 9.1.2015
  
      柳之舞 Q
      伤        害: 延迟0.5/1.0/1.5/2.0秒后，对地方目标单位及其周围造成造成100/200/300/400的伤害   
      施法距离:720
      范        围:200 
]]


function YanagaiNoMai( keys )
  print("YanagaiNoMai.....")
  -- Cannot cast multiple stacks
  if keys.caster.sleight_of_fist_active ~= nil and keys.caster.sleight_of_fist_action == true then
    keys.ability:RefundManaCost()
    return nil
  end

  -- 继承变量
  local caster = keys.caster--施法者
  local target = keys.target--目标
  local targetPoint = keys.target_points[1]--目标点
  local ability = keys.ability--获取技能
  local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )--获取当前技能的施法范围
  local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )--正常伤害倍数
  local damage_r = ability:GetLevelSpecialValueFor( "damage_r", ability:GetLevel() - 1 )--咒印状态下伤害倍数
  local attack_interval = ability:GetLevelSpecialValueFor( "attack_interval", ability:GetLevel() - 1 )--每次攻击的间隔
  local dummyModifierName = "modifier_yanagai_no_mai_datadriven"--//创建特效
  local modifier_phased = "modifier_phased"--//创建特效
  local particleSlashName = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_tgt.vpcf"
  local particleTrailName = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleightoffist_trail.vpcf"
  local particleCastName = "particles/units/heroes/hero_ember_spirit/ember_spirit_sleight_of_fist_cast.vpcf"
  local slashSound = "hero_kimimaro.liuzhiwu"
  
  -- 目标变量
  local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY --目标所属团队：敌方单位
  local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO--目标所属的类型：基本单位和英雄
  local targetFlag = DOTA_UNIT_TARGET_FLAG_NO_INVIS--所要排除的单位：不是隐身的
  local unitOrder = FIND_ANY_ORDER--查找方式：通过命令查找
  
  -- 必须变量
  caster.sleight_of_fist_active = true
  ability:ApplyDataDrivenModifier( caster, target, dummyModifierName, {} )

  local agi = caster:GetAgility()
  local sawarabi_no_mai_r = caster:HasModifier("modifier_kimimaro_zhouyin_caster_datadriven")
  
  -- 创建特效
  local castFxIndex = ParticleManager:CreateParticle( particleCastName, PATTACH_CUSTOMORIGIN, caster )--创建的粒子特效，得到一个数值
 -- ParticleManager:SetParticleControl( castFxIndex, 0, targetPoint )
  --ParticleManager:SetParticleControl( castFxIndex, 1, Vector( radius, 0, 0 ) )
  
  Timers:CreateTimer( 0.5, function()
      ParticleManager:DestroyParticle( castFxIndex, false )--销毁castFxIndex
      ParticleManager:ReleaseParticleIndex( castFxIndex )
    end
  )
  
  -- 功能实现
  local castFxIndex = ParticleManager:CreateParticle( particleCastName, PATTACH_CUSTOMORIGIN, caster )--创建的粒子特效，得到一个数值
  local units = FindUnitsInRadius(
    caster:GetTeamNumber(), targetPoint, caster, radius, targetTeam,
    targetType, targetFlag, unitOrder, false
  )
  caster:SetForwardVector( ((targetPoint - caster:GetOrigin()):Normalized()) )
   -- 移动英雄
  Timers:CreateTimer( 0.1, function() 
    local caster_vec = caster:GetOrigin()   --获取施法者的位置
    if (targetPoint - caster_vec):Length()>50 then  --当单位移动到距离指定地点小于50时不在进行移动
      local caster_abs = caster:GetAbsOrigin()
      local face = (targetPoint - caster_abs):Normalized()
      local vec = face * 75.0
      caster:SetAbsOrigin(caster_abs + vec)
      
      return 0.01
    else
      for _, target in pairs( units ) do
       ability:ApplyDataDrivenModifier( caster, target, modifierTargetName, {} )
        Timers:CreateTimer( attack_interval, function()
            -- 单位活着
            if target:IsAlive() then
              -- 创建跟踪粒子
              local trailFxIndex = ParticleManager:CreateParticle( particleTrailName, PATTACH_CUSTOMORIGIN, target )
              ParticleManager:SetParticleControl( trailFxIndex, 0, target:GetAbsOrigin() )
              ParticleManager:SetParticleControl( trailFxIndex, 1, caster:GetAbsOrigin() )
              
              Timers:CreateTimer( 0.1, function()
                  ParticleManager:DestroyParticle( trailFxIndex, false )
                  ParticleManager:ReleaseParticleIndex( trailFxIndex )
                  return nil
                end
              )
                --FindClearSpaceForUnit( caster, target:GetAbsOrigin(), false )--在未被占用的敌方创建英雄
                -- 造成伤害
                if sawarabi_no_mai_r then
                    local damageTable = {victim=target,    --受到伤害的单位
                    attacker=caster,    --造成伤害的单位
                    damage=damage_r * agi,
                    damage_type=DAMAGE_TYPE_MAGICAL}
                    ApplyDamage(damageTable) 
                else
                    local damageTable = {victim=target,    --受到伤害的单位
                    attacker=caster,    --造成伤害的单位
                    damage=damage * agi,
                    damage_type=DAMAGE_TYPE_MAGICAL}
                    ApplyDamage(damageTable) 
                end
              -- 移除特效
              local slashFxIndex = ParticleManager:CreateParticle( particleSlashName, PATTACH_ABSORIGIN_FOLLOW, target )
              StartSoundEvent( slashSound, caster )
              
              Timers:CreateTimer( 2, function()
                  ParticleManager:DestroyParticle( slashFxIndex, false )
                  ParticleManager:ReleaseParticleIndex( slashFxIndex )
                  StopSoundEvent( slashSound, caster )
                  return nil
                end
              )
              
              -- 清空buff
            target:RemoveModifierByName( dummyModifierName )
            caster:RemoveModifierByName(modifier_phased)
            end
          return nil
        end)   
      end
    end
    caster:RemoveModifierByName("modifier_phased") 
  end)  
  caster.sleight_of_fist_active = false
  return nil
end