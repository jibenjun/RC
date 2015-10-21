--[[
  Author: Jackie_龍
  Date: 9.1.2015
  
      螺旋丸 W
     施法延迟:0.3
      伤        害:对敌方目标单位造成敏捷*2.5/5.0/7.5/10倍伤害   
      施法距离:720
      范         围:200 
]]


function RaSenGan( keys )
  print("RaSenGan.....")
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
  local tgo = target:GetOrigin()    --获取目标的位置，及三围坐标
  local cgfv = caster:GetForwardVector()
  local c_team = caster:GetTeam()   --获取施法者所在的队伍
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
          attacker=caster,    --造成伤害的单位
          damage=500,
          damage_type=DAMAGE_TYPE_MAGICAL}
          ApplyDamage(damageTable)    --造成伤害
          if (caster:GetOrigin() - target:GetOrigin()):Length() > 50 and (#targets) == 1 then
            GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("yidong"),
            function()  --当单位移动到距离指定地点小于50时不在进行移动
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
          attacker=caster,    --造成伤害的单位
          damage=200,
          damage_type=DAMAGE_TYPE_MAGICAL}
          ApplyDamage(damageTable)    --造成伤害
        end
      end
    end,0.2)

  end
end