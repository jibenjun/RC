--SPAWN，单位创建
require("utils.utils_print")
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
SPAWN.WayPoint={}
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
SPAWN.wave_sanguo_lasttime = 0 

function SPAWN:Init()
	-- body
	
end
function SPAWN:BossSpawnStart()
	-- body
    -- 记录开始刷兵时间
    self:PointCollect()--出生点、路径点获取
	  self:UnitCollect()--BOSS信息收集
    print("BossSpawnStart!")
    self.__spawnBossWave=1
    self.__spawn_start_time = GameRules:GetGameTime()
    self.__last_spawn_time = GameRules:GetGameTime()
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
           
           PUI:UpdataTimer(false,time)
        end
        if now - SPAWN.wave_sanguo_lasttime >= 60 then 
             SPAWN.wave_sanguo_lasttime=now 
             for i=1,5 do           
                if DIFFICULTY.count == 1 then 
                   if PLAYERINFO.hero then 
                     for _,hero in pairs(PLAYERINFO.hero) do
                       _team = hero.team
                       print("single ".._team)
                     end
                   end 
                   if _team == DOTA_TEAM_GOODGUYS then 
                       local unit=SPAWN:DoSpawn("npc_zs_creep_wei_melee_1",Entities:FindByName(nil,"spawaner_boss"):GetAbsOrigin()+RandomVector(400),DOTA_TEAM_NEUTRALS,Entities:FindByName(nil,"boss_way_left_1"),7)
                   else 
                       local unit=SPAWN:DoSpawn("npc_zs_creep_shu_melee_1",Entities:FindByName(nil,"spawaner_boss"):GetAbsOrigin()+RandomVector(400),DOTA_TEAM_NEUTRALS,Entities:FindByName(nil,"boss_way_right_1"),7)
                   end
                else 
                       local unit=SPAWN:DoSpawn("npc_zs_creep_wei_melee_1",Entities:FindByName(nil,"spawaner_boss"):GetAbsOrigin()+RandomVector(400),DOTA_TEAM_NEUTRALS,Entities:FindByName(nil,"boss_way_left_1"),7)
                       local unit=SPAWN:DoSpawn("npc_zs_creep_shu_melee_1",Entities:FindByName(nil,"spawaner_boss"):GetAbsOrigin()+RandomVector(400),DOTA_TEAM_NEUTRALS,Entities:FindByName(nil,"boss_way_right_1"),7)                                       
                end 
             end                                                   
        end 
        if now >= self.boss_last_dead_time+self.per_time and  _go then
            PUI:UpdataTimer(true,"#attacking")
            self.__last_spawn_time = now -- 记录上次刷怪时间
            local _boss=self.Boss[self.__spawnBossWave] 
            if self.__spawnBossWave > #self.Boss then 
            	--return 
               local count=self.__spawnBossWave % #self.Boss 
               if count == 0 then count = #self.Boss end 
               _boss=self.Boss[count]
            end 
            local unit=self:DoSpawn(_boss,Entities:FindByName(nil,"spawaner_boss"):GetAbsOrigin(),DOTA_TEAM_NEUTRALS,Entities:FindByName(nil,"point_1"),3)
            self.CurrentBoss=unit
            self.BossAlive=true
            DAMAGESTAT:InitBoss(unit)
            if self.__spawnBossWave > #self.Boss then 
                local grade= math.ceil( self.__spawnBossWave / #self.Boss )
                local wave=math.floor(self.__spawnBossWave / #self.Boss)                 
                grade = grade + wave 
                if   unit:GetLevel()< grade then  
                      unit:CreatureLevelUp(grade-1) 
                      --unit:SetMaxHealth(unit:GetMaxHealth()+500*(grade-1))          
                end
            end 
            local ability=unit:FindAbilityByName("zs2_damage_stat")
            self.__spawnBossWave=self.__spawnBossWave+1
           
        end
        
            return 0.5    
    end,0)
end
function SPAWN:WaveSpawnStart(keys)  --请求支援
    print("WaveSpawnStart!")  
     local playerid=keys.PlayerID
     local team = PlayerResource:GetTeam( playerid )        
     local player = PlayerResource:GetPlayer(playerid)  
     local hero = player:GetAssignedHero()
        if team == DOTA_TEAM_GOODGUYS then 
            if Lumber.good < 20 then 
                PUI:MSG("需要20个战利品，队伍战利品不足！！！",MSG_TYPE_ALL,nil,hero,1)
            else                
                for i=1,5 do           
                   local unit=SPAWN:DoSpawn("npc_zs_creep_shu_melee",Entities:FindByName(nil,"spawn_left"):GetAbsOrigin()+RandomVector(400),team,Entities:FindByName(nil,"point_left_1"),6)
                   
                end
                Lumber.good=Lumber.good-20
            end 
        elseif team == DOTA_TEAM_BADGUYS then 
            if Lumber.bad < 20 then 
                PUI:MSG("需要20个战利品，队伍战利品不足！！！",MSG_TYPE_ALL,nil,hero,1)
            else 
                for i=1,5 do           
                   local unit=SPAWN:DoSpawn("npc_zs_creep_wei_melee",Entities:FindByName(nil,"spawn_right"):GetAbsOrigin()+RandomVector(400),team,Entities:FindByName(nil,"point_right_1"),6)
                   
                end
                Lumber.good=Lumber.good-20
            end 
        end 

    local data={good=Lumber.good,bad=Lumber.bad}
    CustomGameEventManager:Send_ServerToAllClients( "updata_zlp", data )
end
function SPAWN:WildBossStart()
  -- body
  local wild_N1l=Entities:FindByName(nil,"spawaner_wild_1")
  local wild_N1r=Entities:FindByName(nil,"spawaner_wild_2")
  local wild_N2=Entities:FindByName(nil,"spawaner_wild_4")
  local wild_N4=Entities:FindByName(nil,"spawaner_wild_3")
  local wild_N5=Entities:FindByName(nil,"spawaner_wild_5")

  local unit_wild_N1l=self:DoSpawn("npc_zs_beifangzhilang_b",wild_N1l:GetAbsOrigin(),DOTA_TEAM_NEUTRALS,nil,1)
  unit_wild_N1l:SetContextNum("spaner",1,0)
  local unit_wild_N1r=self:DoSpawn("npc_zs_beifangzhilang_b",wild_N1r:GetAbsOrigin(),DOTA_TEAM_NEUTRALS,nil,1)
  unit_wild_N1r:SetContextNum("spaner",2,0)
  local unit_wild_N2=self:DoSpawn("npc_zs_aoxiao",wild_N2:GetAbsOrigin(),DOTA_TEAM_NEUTRALS,nil,2)
  unit_wild_N2:SetContextNum("spaner",4,0)
  local unit_wild_N4=self:DoSpawn("npc_zs_chuanzhang",wild_N4:GetAbsOrigin(),DOTA_TEAM_NEUTRALS,nil,4)
  unit_wild_N4:SetContextNum("spaner",3,0)
  local unit_wild_N5=self:DoSpawn("npc_dota_long",wild_N5:GetAbsOrigin(),DOTA_TEAM_NEUTRALS,nil,5)
  unit_wild_N5:SetContextNum("spaner",5,0)

end

function SPAWN:WildRespawn(unit)
  -- body
     local _type = unit:GetContext("Label")
     local spawn_num = unit:GetContext("spaner")
     local _name=unit:GetUnitName()
     local spawner=Entities:FindByName(nil,"spawaner_wild_"..tostring(spawn_num))
     local unit_wild_N1l=self:DoSpawn(_name,spawner:GetAbsOrigin(),DOTA_TEAM_NEUTRALS,nil,_type)
     unit_wild_N1l:SetContextNum("spaner",spawn_num,0)
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
function SPAWN:SculptureSpawnStart()
  -- body
        --local unit=self:DoSpawn("npc_zs2_sculpture",Entities:FindByName(nil,"mid_1"):GetOrigin(),6,nil,LBOSS)
        local unit = CreateUnitByName("npc_zs2_sculpture", Entities:FindByName(nil,"mid_1"):GetOrigin(), true, nil, nil, 6)
        self.SculptureAlive=true
        self.Sculpture=unit
        GAME.AttackTarget=nil
        local origin=unit:GetOrigin()
        unit:SetContextThink(DoUniqueString("SpawnerTimer_2"),function()
              if unit:GetOrigin() ~= origin then 
                  unit:SetOrigin(origin)

              end
              return 1
        end,1)
end
function SPAWN:Sculpture_2_SpawnStart()
  -- body
        --local unit=self:DoSpawn("npc_zs2_sculpture",Entities:FindByName(nil,"mid_1"):GetOrigin(),6,nil,LBOSS)
        local unit = CreateUnitByName("npc_zs2_sculpture_2", Entities:FindByName(nil,"npc_zs2_sculpture_spawn"):GetOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
        local origin=unit:GetOrigin()
        unit:SetForwardVector(Vector(0,90,0)) 
        unit:SetContextThink(DoUniqueString("SpawnerTimer_2"),function()
              if unit:GetOrigin() ~= origin then 
                  unit:SetOrigin(origin)

              end
              return 1
        end,1)
end
function SPAWN:Sculpture_3_SpawnStart()
  -- body
        --local unit=self:DoSpawn("npc_zs2_sculpture",Entities:FindByName(nil,"mid_1"):GetOrigin(),6,nil,LBOSS)
        local unit2 = CreateUnitByName("npc_zs2_sculpture_3", Entities:FindByName(nil,"npc_zs2_sculpture_2_spawn"):GetOrigin(), true, nil, nil, DOTA_TEAM_NEUTRALS)
        local origin2=unit2:GetOrigin()+Vector(0,0,120)
        unit2:SetForwardVector(Vector(0,0,-90)) 
        unit2:SetContextThink(DoUniqueString("SpawnerTimer_3"),function()
              if unit2:GetOrigin() ~= origin2 then 
                  unit2:SetOrigin(origin2)

              end
              return 1
        end,1)
end
function SPAWN:UnitCollect()--BOSS信息收集
	-- body 
    self.Boss[1]="npc_dota_creature_boss_pudge"
    self.Boss[2]="zhensan_guanyu"
    self.Boss[3]="zhensan_zhangliao"
end
function SPAWN:DoSpawn(unit_name,spawn_location,team,initial_target,label)
	-- body
	local unit = CreateUnitByName(unit_name, spawn_location, true, nil, nil, team)
	  FindClearSpaceForUnit(unit,unit:GetAbsOrigin(), false)
    --设置标签
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
function SPAWN:PointCollect() --出生点、路径点获取
	-- body
    local _spawner={
          "spawaner_boss",
          "spawaner_wild_1",
          "spawaner_wild_2",
          "spawaner_wild_3",
          "spawaner_wild_4",
          "spawaner_wild_5"

    }
    local _waypoint={
          
          "point_1",
          "boss_way_left_1",
          "boss_way_right_1",
          "point_left_1",
          "point_right_1"

    }
    if _spawner[1] then 
    	for _,__spwaner in pairs(_spawner) do
    		self.Spawner[__spwaner]=Entities:FindByName(nil,"point_1")
    	end
    end
    if _waypoint[1] then 
    	for _,__waypoint in pairs(_waypoint) do
    		self.WayPoint[__waypoint]=Entities:FindByName(nil,__waypoint)
    	end
    end
    
end
