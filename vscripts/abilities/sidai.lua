function RC_NPC_SiDai_Q( keys )
	print("RC_NPC_SiDai_Q.....")
	local caster = keys.caster
	local target = keys.target
	local c_team = caster:GetTeam() 	--获取施法者所在的队伍
	local al = keys.ability:GetLevel() - 1   --获取技能等级，并且减1
	local radius = keys.radius		--设置范围
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
					attacker=caster,	  --造成伤害的单位
					damage=damage,
					damage_type=DAMAGE_TYPE_MAGICAL}
				ApplyDamage(damageTable)    --造成伤害
			end
		end,duration)
	end

end

function RC_NPC_SiDai_W( keys )
	local caster = keys.caster
	local target = keys.target
	local castrange = keys.castrange
	local radius = keys.radius
	local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
	local flags = DOTA_UNIT_TARGET_FLAG_NONE
	local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	print("RC_NPC_SiDai_W.....")
	local al = keys.ability:GetLevel() - 1   --获取技能等级，并且减1
	local cgo = caster:GetOrigin()
	local tgo = target:GetOrigin()		--获取目标的位置，及三围坐标
	local cgfv = caster:GetForwardVector()
	local c_team = caster:GetTeam() 	--获取施法者所在的队伍
	--判断单位是否死亡，是否存在，是否被击晕
	if caster:IsAlive() and IsValidEntity(caster) and not(caster:IsStunned()) then
		--不是死亡，存在这个单位，没被击晕，就运行这里面的内容
		--设置施法者的面向角度
		caster:SetForwardVector( ((target:GetAbsOrigin() - caster:GetOrigin()):Normalized()) )

		GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("W"),
		function()
			FindClearSpaceForUnit(caster, tgo, true) --unit1:施法者，point:目标矢量，
			--获取范围内的单位，效率不是很高，在计时器里面注意使用
			local targets = FindUnitsInRadius(c_team, tgo, nil, 150, teams, types, flags, FIND_CLOSEST, true)
			--利用Lua的循环迭代，循环遍历每一个单位组内的单位
			for i,unit in pairs(targets) do
				if i == 1 then
					local damageTable = {victim=unit,    --受到伤害的单位
					attacker=caster,	  --造成伤害的单位
					damage=500,
					damage_type=DAMAGE_TYPE_MAGICAL}
					ApplyDamage(damageTable)    --造成伤害
					if (caster:GetOrigin() - target:GetOrigin()):Length() > 50 and (#targets) == 1 then
						GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("yidong"),
						function()	--当单位移动到距离指定地点小于50时不在进行移动
							if (caster:GetOrigin() - target:GetOrigin()):Length() > 700 then
								return nil
							else		
								FindClearSpaceForUnit(unit, target:GetAbsOrigin() - 50 * cgfv, true) --unit1:施法者，point:目标矢量
								return 0.001
							end
						end,0.1)
					end
				else
					local damageTable = {victim=unit,    --受到伤害的单位
					attacker=caster,	  --造成伤害的单位
					damage=200,
					damage_type=DAMAGE_TYPE_MAGICAL}
					ApplyDamage(damageTable)    --造成伤害
				end
			end
		end,0.2)

	end
end

function RC_NPC_SiDai_E( keys )

	local caster = keys.caster       --获取施法者
	local target = keys.target
	local al = keys.ability:GetLevel() - 1   --获取技能等级，并且减1
	local c_team = caster:GetTeam() 	--获取施法者所在的队伍
	local tgo = target:GetOrigin()		--获取目标的位置，及三围坐标
	local damage = keys.ability:GetLevelSpecialValueFor("damage", al)   --造成伤害

	local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
	local types = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
	local flags = DOTA_UNIT_TARGET_FLAG_NONE
	FindClearSpaceForUnit(caster, target:GetAbsOrigin(), true) --unit1:施法者，point:目标矢量
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("W"),
	function()
		local damageTable = {victim=target,    --受到伤害的单位
							attacker=caster,	  --造成伤害的单位
							damage=damage,
							damage_type=DAMAGE_TYPE_MAGICAL}
							ApplyDamage(damageTable)    --造成伤害
	end,0.3)
end

function RC_NPC_SiDai_R( keys )
  local caster = keys.caster
  local point = keys.target_points[1]

  local radius = 400    --设置范围
  local teams = DOTA_UNIT_TARGET_TEAM_ENEMY
  local types = DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO
  local flags = DOTA_UNIT_TARGET_FLAG_NONE

  --设置施法者的面向角度
  caster:SetForwardVector( ((point - caster:GetOrigin()):Normalized()) )
  GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("Modifier_MyAbility_Point_2_1"), 
    function( )
      --判断单位是否死亡，是否存在，是否被击晕
      if caster:IsAlive() and IsValidEntity(caster) and not(caster:IsStunned()) then  
        --不是死亡，存在这个单位，没被击晕，就运行这里面的内容
        local caster_vec = caster:GetOrigin()   --获取施法者的位置

        if (point - caster_vec):Length()>50 then  --当单位移动到距离指定地点小于50时不在进行移动

          local caster_abs = caster:GetAbsOrigin()
          local face = (point - caster_abs):Normalized()
          local vec = face * 75.0
          caster:SetAbsOrigin(caster_abs + vec)

          return 0.01
        else
          --获取范围内的单位，效率不是很高，在计时器里面注意使用
          local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetOrigin(), nil, radius, teams, types, flags, FIND_CLOSEST, true)

          --利用Lua的循环迭代，循环遍历每一个单位组内的单位
          for i,unit in pairs(targets) do
            local damageTable = {victim=unit,    --受到伤害的单位
              attacker=caster,    --造成伤害的单位
              damage=100,
              damage_type=DAMAGE_TYPE_PURE}
            ApplyDamage(damageTable)    --造成伤害
          end

          caster:RemoveModifierByName("modifier_phased")
          print("MyAbility_point Over")
          return nil
        end

      else
        caster:RemoveModifierByName("modifier_phased")
        print("Caster is death or stunned")
        return nil
      end
    end, 0)

  print("Run MyAbility_point Succeed")
end


function RC_NPC_SiDai_D( keys )
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

function RC_NPC_SiDai_F_1_1( caster, charge_replenish_time )
	caster.shrapnel_cooldown = charge_replenish_time
	GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("3"),
	function()
		local current_cooldown = caster.shrapnel_cooldown - 0.1
		if current_cooldown > 0.1 then
			caster.shrapnel_cooldown = current_cooldown
			return 0.1
		else
			return nil
		end
	end,0.1)
end
