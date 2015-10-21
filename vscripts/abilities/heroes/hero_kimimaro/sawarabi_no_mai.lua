--[[
  Author: Jackie_龍
  Date: 9.1.2015
  
      早蕨之舞  D
      伤        害: 延迟0.5/1.0/1.5/2.0秒后，对地方目标单位及其周围造成造成100/200/300/400的伤害   
      施法距离:720
      范        围:200 
]]

--[[
  Author: Jackie_龍
  Date: 9.1.2015
  
      柳之舞 Q
      伤        害: 延迟0.5/1.0/1.5/2.0秒后，对地方目标单位及其周围造成造成100/200/300/400的伤害   
      施法距离:720
      范        围:200 
]]


function SawarabiNoMai( keys )
  print("SawarabiNoMai.....")
  -- Cannot cast multiple stacks
  if keys.caster.sleight_of_fist_active ~= nil and keys.caster.sleight_of_fist_action == true then
    keys.ability:RefundManaCost()
    return nil
  end

  -- 继承变量
  local caster = keys.caster--施法者
  local ability = keys.ability--获取技能
  local targetPoint = keys.target_points[1]--目标点
  local radius = ability:GetLevelSpecialValueFor( "radius", ability:GetLevel() - 1 )--获取当前技能的施法范围
  local damage = ability:GetLevelSpecialValueFor( "damage", ability:GetLevel() - 1 )--正常伤害倍数
  local damage_r = ability:GetLevelSpecialValueFor( "damage_r", ability:GetLevel() - 1 )--咒印状态下伤害倍数

  
  -- 目标变量
  local targetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY --目标所属团队：敌方单位
  local targetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO--目标所属的类型：基本单位和英雄
  local targetFlag = DOTA_UNIT_TARGET_FLAG_NO_INVIS--所要排除的单位：不是隐身的
  local unitOrder =  FIND_ANY_ORDER--查找方式：通过命令查找
  
  -- 必须变量
  caster.sleight_of_fist_active = true
  local agi = caster:GetAgility()
  local zhouyin = caster:HasModifier("modifier_kimimaro_zhouyin_caster_datadriven")
  local particleName = "particles/units/heroes/hero_tidehunter/tidehunter_ravage_tentacle_model.vpcf"
  -- 创建特效
  
  
  -- 功能实现
  
  local units = FindUnitsInRadius(
    caster:GetTeamNumber(), targetPoint, caster, radius, targetTeam,
    targetType, targetFlag, unitOrder, false
  )
  for i = 1, 10 do
     Timers:CreateTimer( 0.5, function()
              local castFxIndex = ParticleManager:CreateParticle( particleName, PATTACH_CUSTOMORIGIN, caster )--创建的粒子特效，得到一个数值
              local p =  targetPoint + RandomVector(RandomFloat(0, radius))                  
              ParticleManager:SetParticleControl( castFxIndex, 0, p )
              ParticleManager:ReleaseParticleIndex( castFxIndex )
              return nil
            end
          )
  end
  for _, target in pairs( units ) do
    Timers:CreateTimer( 0.5, function()
        -- 单位活着
        if target:IsAlive() then
          -- 造成伤害
          local tgo = target:GetOrigin()   --获取施法者的位置

          if (targetPoint - tgo):Length()<200 then  --当单位移动到距离指定地点不小于200时不在进行移动
            if zhouyin then
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
          else
            if zhouyin then
                local damageTable = {victim=target,    --受到伤害的单位
                attacker=caster,    --造成伤害的单位
                damage=damage_r * agi/2,
                damage_type=DAMAGE_TYPE_MAGICAL}
                ApplyDamage(damageTable) 
            else
                local damageTable = {victim=target,    --受到伤害的单位
                attacker=caster,    --造成伤害的单位
                damage=damage * agi/2,
                damage_type=DAMAGE_TYPE_MAGICAL}
                ApplyDamage(damageTable) 
            end
          end
        
          if zhouyin then
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

          
          -- 清空buff
        end
        return nil
      end
    )
  end
  caster.sleight_of_fist_active = false
end
