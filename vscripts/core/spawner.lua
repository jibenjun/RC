--SPAWN，单位创建
if SPAWN == nil then
	SPAWN = class({})
end
LWILDBOSSN1=1
LWILDBOSSN2=2
LBOSS=3
LWILDBOSSN4=4
LWILDBOSSN5=5
LWAVE=6
LWAVE_SG=7
SPAWN.Spawner={}
SPAWN.Spawner_1={}
SPAWN.Team={}
SPAWN.WayPoint={}
SPAWN.WayPoint_1={}
SPAWN.Boss={}
SPAWN.OtherUnit={} 
SPAWN.CurrentBoss=nil
SPAWN.BossAlive=false
SPAWN.SculptureAlive=false
SPAWN.Sculpture=nil
SPAWN.Sculpture_2=nil
SPAWN.Sculpture_3=nil
SPAWN.per_time=120
SPAWN.boss_last_dead_time = 0
SPAWN.wave_rc_lasttime = 0
SPAWN.Start = false 

function SPAWN:Init()--初始化野怪刷怪器 在InitGameMode()中调用一次
	-- body
end
function SPAWN:SpawnStart()
	-- body
    --刷野怪，在游戏进入开始阶段时调用一次
    self:PointCollect()--遍历所有野怪点，并刷怪
	  self:UnitCollect()--遍历所有BOSS，并刷怪
    print("SpawnStart!")
    self.__spawnBossWave=1
    self.__spawn_start_time = GameRules:GetGameTime()
    self.__last_spawn_time = GameRules:GetGameTime()
    local unit=SPAWN:DoSpawn("boss",Entities:FindByName(nil,"xia_boss"):GetAbsOrigin()+RandomVector(200),DOTA_TEAM_NEUTRALS,nil,3)
    local unit=SPAWN:DoSpawn("boss",Entities:FindByName(nil,"xia_boss"):GetAbsOrigin()+RandomVector(200),DOTA_TEAM_NEUTRALS,nil,3)
    local unit=SPAWN:DoSpawn("boss",Entities:FindByName(nil,"xia_boss"):GetAbsOrigin()+RandomVector(200),DOTA_TEAM_NEUTRALS,nil,3)
    GameRules:GetGameModeEntity():SetContextThink(DoUniqueString("SpawnerTimer"),function()
        local now = GameRules:GetGameTime()
        local _go=false
        if not self.CurrentBoss  then 
            _go= true 
        elseif not self.BossAlive then 
            _go= true
        end
        if not self.BossAlive then
           local time= math.floor((self.boss_last_dead_time+self.per_time)-now)
        end
        if not self.Start then
          for i=1,8 do 
            local unit=SPAWN:DoSpawn("xiaobing_jinzhan",Entities:FindByName(nil,"muye"):GetAbsOrigin(),DOTA_TEAM_GOODGUYS,nil,1)
            local unit=SPAWN:DoSpawn("xiaobing_jinzhan",Entities:FindByName(nil,"xiao"):GetAbsOrigin(),DOTA_TEAM_BADGUYS,nil,2)
            local unit=SPAWN:DoSpawn("xiaobing_jinzhan",Entities:FindByName(nil,"sha"):GetAbsOrigin(),DOTA_TEAM_CUSTOM_1,nil,3)
          end
          SPAWN.Start = true
        end
        if now - SPAWN.wave_rc_lasttime >= 20 then 
         -- print("now - SPAWN.wave_rc_lasttime  "..now - SPAWN.wave_rc_lasttime)
             SPAWN.wave_rc_lasttime=now 
             for i=1,5 do 
              local unit=SPAWN:DoSpawn("xiaobing_jinzhan",Entities:FindByName(nil,"muye_up"):GetAbsOrigin(),DOTA_TEAM_GOODGUYS,Entities:FindByName(nil,"muye_up_1"),1)
              local unit=SPAWN:DoSpawn("xiaobing_jinzhan",Entities:FindByName(nil,"muye_mid"):GetAbsOrigin(),DOTA_TEAM_GOODGUYS,Entities:FindByName(nil,"muye_mid_1"),1)
              local unit=SPAWN:DoSpawn("xiaobing_jinzhan",Entities:FindByName(nil,"muye_down"):GetAbsOrigin(),DOTA_TEAM_GOODGUYS,Entities:FindByName(nil,"muye_down_1"),1)
              local unit=SPAWN:DoSpawn("xiaobing_jinzhan",Entities:FindByName(nil,"xiao_up"):GetAbsOrigin(),DOTA_TEAM_BADGUYS,Entities:FindByName(nil,"xiao_up_1"),2)
              local unit=SPAWN:DoSpawn("xiaobing_jinzhan",Entities:FindByName(nil,"xiao_mid"):GetAbsOrigin(),DOTA_TEAM_BADGUYS,Entities:FindByName(nil,"xiao_mid_1"),2)
              local unit=SPAWN:DoSpawn("xiaobing_jinzhan",Entities:FindByName(nil,"xiao_down"):GetAbsOrigin(),DOTA_TEAM_BADGUYS,Entities:FindByName(nil,"xiao_down_1"),2)
              local unit=SPAWN:DoSpawn("xiaobing_jinzhan",Entities:FindByName(nil,"sha_left"):GetAbsOrigin(),DOTA_TEAM_CUSTOM_1,Entities:FindByName(nil,"sha_left_1"),3)
              local unit=SPAWN:DoSpawn("xiaobing_jinzhan",Entities:FindByName(nil,"sha_mid"):GetAbsOrigin(),DOTA_TEAM_CUSTOM_1,Entities:FindByName(nil,"sha_mid_1"),3)
              local unit=SPAWN:DoSpawn("xiaobing_jinzhan",Entities:FindByName(nil,"sha_right"):GetAbsOrigin(),DOTA_TEAM_CUSTOM_1,Entities:FindByName(nil,"sha_right_1"),3)
             end                                                   
        end 
      return 0.5    
    end,0)
end

function SPAWN:InitJidi() --基地初始化
  -- body
   local jidi_good=Entities:FindByName(nil,"good_fort") 
   local jidi_bad=Entities:FindByName(nil,"bad_fort") 
   jidi_good:AddAbility("ability_jidi") 
   jidi_bad:AddAbility("ability_jidi")  
   local good_ability=jidi_good:FindAbilityByName("ability_jidi")   
   good_ability:SetLevel(1)
   local bad_ability=jidi_bad:FindAbilityByName("ability_jidi")   
   bad_ability:SetLevel(1)
end

function SPAWN:UnitCollect()--记录BOSS点
	-- body 
    self.Boss[1]="xia"
    self.Boss[2]="zuo"
    self.Boss[3]="you"
end

function SPAWN:DoSpawn(unit_name,spawn_location,team,initial_target,label)
	-- body
	--uniy_name ：野怪名称 spawn_location：出生点位置   team ：队伍  initial_target ：初始路径点，没有就写nil label：标记，本例用2代表野怪
	local unit = CreateUnitByName(unit_name, spawn_location, true, nil, nil, team)
	  FindClearSpaceForUnit(unit,unit:GetAbsOrigin(), false)
    --设置标签
    if  label then 
        unit:SetContextNum("Label",label,0)
    end  
    unit:SetMustReachEachGoalEntity(false)
    if initial_target then 
        unit:SetInitialGoalEntity(initial_target)
    end
    return unit
end
function SPAWN:WildBossSpawn()
	-- body
end
function SPAWN:PointCollect() --记录野怪点
	-- body
    local _spawner={
          "muye",
          "xiao",
          "sha"
    }
    local _waypoint={
          "muye_1",
          "xiao_1",
          "sha_1"
    }
    if _spawner[1] then
    	for _,__spwaner in pairs(_spawner) do
    		self.Spawner[__spwaner]=Entities:FindByName(nil,__spwaner)
    	end
    end
      
    if _waypoint[1] then 
    	for _,__waypoint in pairs(_waypoint) do
    		self.WayPoint[__waypoint]=Entities:FindByName(nil,__waypoint)
    	end
    end
    
end
