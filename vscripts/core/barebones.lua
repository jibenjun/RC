print ('[BAREBONES]   barebones.lua' )--核心类代码

ENABLE_HERO_RESPAWN = true              -- 设置是否使用默认英雄复活规则
UNIVERSAL_SHOP_MODE = false             -- 为真时，所有物品当处于任意商店范围内时都能购买到，包括秘密商店物品
ALLOW_SAME_HERO_SELECTION = true        -- 允许选择重复英雄

HERO_SELECTION_TIME = 30.0              -- 设置选择英雄的时间
PRE_GAME_TIME = 10.0                    -- 设置选择英雄与开始游戏之间的时间？
POST_GAME_TIME = 60.0                   -- 设置在结束游戏后服务器与玩家断线前的时间
TREE_REGROW_TIME = 60.0                 -- 设置树重新生长的时间（秒）

GOLD_PER_TICK = 100                     -- 设置每个时间间隔获得的金币
GOLD_TICK_TIME = 5                      -- 设置获得金币的时间周期

RECOMMENDED_BUILDS_DISABLED = false     -- 是否禁止显示商店中的推荐购买物品
CAMERA_DISTANCE_OVERRIDE = 1134.0        -- 设置默认的镜头距离。Dota默认为1134

MINIMAP_ICON_SIZE = 1                   -- 设置小地图英雄图标尺寸
MINIMAP_CREEP_ICON_SIZE = 1             -- 在小地图上缩放中立生物图标
MINIMAP_RUNE_ICON_SIZE = 1              -- 缩放小地图神符图标

RUNE_SPAWN_TIME = 120                    -- 设置神符刷新时间
CUSTOM_BUYBACK_COST_ENABLED = true      -- 开启该选项来允许自定义买活花费
CUSTOM_BUYBACK_COOLDOWN_ENABLED = true  -- 开启该选项来允许自定义买活冷却时间
BUYBACK_ENABLED = false                 -- 完全允许/禁止买活

DISABLE_FOG_OF_WAR_ENTIRELY = false      -- 开关战争迷雾
--USE_STANDARD_DOTA_BOT_THINKING = false  -- 允许/禁止机器人思考，需要与Dota PvP高度相似的三路线地图、商店等
USE_STANDARD_HERO_GOLD_BOUNTY = true    -- 英雄将使用基础NPC规则来决定赏金，而不是DOTA指定规则

USE_CUSTOM_TOP_BAR_VALUES = true        -- 是否覆盖顶端的队伍数值
TOP_BAR_VISIBLE = true                  -- 开关顶端的队伍数值
SHOW_KILLS_ON_TOPBAR = true             -- 设置顶端的队伍数值Should we display kills only on the top bar? (No denies, suicides, kills by neutrals)  Requires USE_CUSTOM_TOP_BAR_VALUES

ENABLE_TOWER_BACKDOOR_PROTECTION = false-- 开关偷塔保护
REMOVE_ILLUSIONS_ON_DEATH = false       -- 使幻象死亡时立即消失，而不是延迟数秒
DISABLE_GOLD_SOUNDS = false             -- 是否禁止获取金钱时的声音提示

END_GAME_ON_KILLS = true                -- 应该一定数量的杀死后游戏结束
KILLS_TO_END_GAME_FOR_TEAM = 50         -- 杀戮的最大人头数

USE_CUSTOM_HERO_LEVELS = true           -- 开关自定义英雄英雄经验表，该表必须提前被定义
MAX_LEVEL = 50                          -- 英雄最大等级
USE_CUSTOM_XP_VALUES = true             -- 允许英雄提供指定数目的经验值（必须先设置）

-- 每级所需要的经验
XP_PER_LEVEL_TABLE = {}
for i=1,MAX_LEVEL do
  XP_PER_LEVEL_TABLE[i] = i * 100
end

-- 从模板生成
if GameMode == nil then
    print ( '[BAREBONES]   creating barebones game mode' )
    GameMode = class({})
end


--[[
  This function should be used to set up Async precache calls at the beginning of the game.  The Precache() function 
  in addon_game_mode.lua used to and may still sometimes have issues with client's appropriately precaching stuff.
  If this occurs it causes the client to never precache things configured in that block.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).
]]
function GameMode:PostLoadPrecache()
  print("[BAREBONES]   Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
  --PrecacheUnitByNameAsync("npc_precache_everything", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitGameMode() but needs to be done before everyone loads in.
]]
function GameMode:OnFirstPlayerLoaded()
  print("[BAREBONES]   First Player has loaded")
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function GameMode:OnAllPlayersLoaded()
  print("[BAREBONES]   All Players have loaded into the game")
end

--[[
    初始化英雄
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function GameMode:OnHeroInGame(hero)
  --print("[BAREBONES]   Hero spawned in game for first time -- " .. hero:GetUnitName())

  --[[ Multiteam configuration, currently unfinished

  local team = "team1"
  local playerID = hero:GetPlayerID()
  if playerID > 3 then
    team = "team2"
  end
  print("setting " .. playerID .. " to team: " .. team)
  MultiTeam:SetPlayerTeam(playerID, team)]]

  -- 开始黄金500不可靠的黄金
  hero:SetGold(500, false)

  -- 创建一个物品给予英雄
  --local item = CreateItem("item_multiteam_action", hero, hero)
  --hero:AddItem(item)

  --[[ 
    --通过索引找到技能名字然后将他删除，最后为他赋予新的技能
  local abil = hero:GetAbilityByIndex(1)
  hero:RemoveAbility(abil:GetAbilityName())
  hero:AddAbility("example_ability")
  ]]

  for i=1,24 do
    hero:HeroLevelUp(false)--不播放升级效果
  end
end

--[[
  游戏开始
]]
function GameMode:OnGameInProgress()
  print("[BAREBONES]   The game has officially begun")

  Timers:CreateTimer(30, -- 这个计时器30比赛秒后开始
  function()
    print("This function is called 30 seconds after the game begins, and every 30 seconds thereafter")
    return 30.0 -- 重新运行这个定时器每30秒
  end)
end




-- 当玩家离开的时候
function GameMode:OnDisconnect(keys)
  print('[BAREBONES]   Player Disconnected ' .. tostring(keys.userid))
  PrintTable(keys)

  local name = keys.name
  local networkid = keys.networkid
  local reason = keys.reason
  local userid = keys.userid

end
-- 整个游戏状态发生了变化
function GameMode:OnGameRulesStateChange(keys)
  print("[BAREBONES]   GameRules State Changed")
  PrintTable(keys)

  local newState = GameRules:State_Get()
  if newState == DOTA_GAMERULES_STATE_WAIT_FOR_PLAYERS_TO_LOAD then--玩家等待载入
    self.bSeenWaitForPlayers = true
  elseif newState == DOTA_GAMERULES_STATE_INIT then--游戏规则初始化
    Timers:RemoveTimer("alljointimer")
  elseif newState == DOTA_GAMERULES_STATE_HERO_SELECTION then--英雄选择
    local et = 6
    if self.bSeenWaitForPlayers then
      et = .01
    end
    Timers:CreateTimer("alljointimer", {
      useGameTime = true,
      endTime = et,
      callback = function()
        if PlayerResource:HaveAllPlayersJoined() then--所有玩家是否加入
          GameMode:PostLoadPrecache()
          GameMode:OnAllPlayersLoaded()
          return 
        end
        return 1
      end
      })
  elseif newState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then--进行中的游戏
    GameMode:OnGameInProgress()
  end
end

-- 创建英雄
function GameMode:OnNPCSpawned(keys)
  --print("[BAREBONES]   NPC Spawned")
  --PrintTable(keys)
  local npc = EntIndexToHScript(keys.entindex)--把一个实体的整数索引转化为表达该实体脚本实例的HScript

  if npc:IsRealHero() and npc.bFirstSpawned == nil then
    npc.bFirstSpawned = true
    GameMode:OnHeroInGame(npc)
  end
end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
--党实体受到伤害
function GameMode:OnEntityHurt(keys)
  --print("[BAREBONES]   Entity Hurt")
  --PrintTable(keys)
  local entCause = EntIndexToHScript(keys.entindex_attacker)--把一个实体的整数索引转化为表达该实体脚本实例的HScript
  local entVictim = EntIndexToHScript(keys.entindex_killed)--把一个实体的整数索引转化为表达该实体脚本实例的HScript
end

-- An item was picked up off the ground
--一个项目是离地面
function GameMode:OnItemPickedUp(keys)
  print ( '[BAREBONES]   OnItemPurchased' )
  PrintTable(keys)

  local heroEntity = EntIndexToHScript(keys.HeroEntityIndex)
  local itemEntity = EntIndexToHScript(keys.ItemEntityIndex)
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local itemname = keys.itemname
end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
--玩家重连的时候
function GameMode:OnPlayerReconnect(keys)
  print ( '[BAREBONES]   OnPlayerReconnect' )
  PrintTable(keys) 
end

-- An item was purchased by a player
--某个物品被玩家购买的时候
function GameMode:OnItemPurchased( keys )
  print ( '[BAREBONES]   OnItemPurchased' )
  PrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
  
end

-- An ability was used by a player
--某个技能被玩家使用的时候
function GameMode:OnAbilityUsed(keys)
  print('[BAREBONES]   AbilityUsed')
  PrintTable(keys)

  local player = EntIndexToHScript(keys.PlayerID)
  local abilityname = keys.abilityname
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
--某个玩家使用某个技能的时候
function GameMode:OnNonPlayerUsedAbility(keys)
  print('[BAREBONES]   OnNonPlayerUsedAbility')
  PrintTable(keys)

  local abilityname=  keys.abilityname
end

-- A player changed their name
--一个玩家改变了他们的名字
function GameMode:OnPlayerChangedName(keys)
  print('[BAREBONES]   OnPlayerChangedName')
  PrintTable(keys)

  local newName = keys.newname
  local oldName = keys.oldName
end

-- A player leveled up an ability
--当玩家升级某个技能的时候
function GameMode:OnPlayerLearnedAbility( keys)
  print ('[BAREBONES]   OnPlayerLearnedAbility')
  PrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local abilityname = keys.abilityname
end

-- A channelled ability finished by either completing or being interrupted
--当一个技能使用完成或者被打断的时候
function GameMode:OnAbilityChannelFinished(keys)
  print ('[BAREBONES]   OnAbilityChannelFinished')
  PrintTable(keys)

  local abilityname = keys.abilityname
  local interrupted = keys.interrupted == 1
end

-- A player leveled up
--当玩家升级的时候
function GameMode:OnPlayerLevelUp(keys)
  print ('[BAREBONES]   OnPlayerLevelUp')
  PrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local level = keys.level
end

-- A player last hit a creep, a tower, or a hero
--当玩家接近生物、塔、或者英雄的时候
function GameMode:OnLastHit(keys)
  print ('[BAREBONES]   OnLastHit')
  PrintTable(keys)

  local isFirstBlood = keys.FirstBlood == 1
  local isHeroKill = keys.HeroKill == 1
  local isTowerKill = keys.TowerKill == 1
  local player = PlayerResource:GetPlayer(keys.PlayerID)
end

-- A tree was cut down by tango, quelling blade, etc
--当玩家砍掉某棵树的时候
function GameMode:OnTreeCut(keys)
  print ('[BAREBONES]   OnTreeCut')
  PrintTable(keys)

  local treeX = keys.tree_x
  local treeY = keys.tree_y
end

-- A rune was activated by a player
--当玩家激活了某个符文的时候
function GameMode:OnRuneActivated (keys)
  print ('[BAREBONES]   OnRuneActivated')
  PrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local rune = keys.rune

  --[[ Rune Can be one of the following types
  DOTA_RUNE_DOUBLEDAMAGE
  DOTA_RUNE_HASTE
  DOTA_RUNE_HAUNTED
  DOTA_RUNE_ILLUSION
  DOTA_RUNE_INVISIBILITY
  DOTA_RUNE_MYSTERY
  DOTA_RUNE_RAPIER
  DOTA_RUNE_REGENERATION
  DOTA_RUNE_SPOOKY
  DOTA_RUNE_TURBO
  ]]
end

-- A player took damage from a tower
--当玩家摧毁塔的时候
function GameMode:OnPlayerTakeTowerDamage(keys)
  print ('[BAREBONES]   OnPlayerTakeTowerDamage')
  PrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local damage = keys.damage
end

--当玩家选择完一个英雄之后
-- A player picked a hero
function GameMode:OnPlayerPickHero(keys)
  print ('[BAREBONES]   OnPlayerPickHero')
  PrintTable(keys)

  local heroClass = keys.hero
  local heroEntity = EntIndexToHScript(keys.heroindex)
  local player = EntIndexToHScript(keys.player)
end

--当杀死一个或者多个玩家的时候
-- A player killed another player in a multi-team context
function GameMode:OnTeamKillCredit(keys)
  print ('[BAREBONES]   OnTeamKillCredit')
  PrintTable(keys)

  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
  local numKills = keys.herokills
  local killerTeamNumber = keys.teamnumber
end

--当一个实体死亡的时候
-- An entity died
function GameMode:OnEntityKilled( keys )
  print( '[BAREBONES]   OnEntityKilled Called' )
  PrintTable( keys )
  --被杀的单位
  -- The Unit that was Killed
  local killedUnit = EntIndexToHScript( keys.entindex_killed )
  --杀死的实体
  -- The Killing entity
  local killerEntity = nil

  if keys.entindex_attacker ~= nil then
    killerEntity = EntIndexToHScript( keys.entindex_attacker )
  end

  if killedUnit:IsRealHero() then 
    print ("KILLEDKILLER: " .. killedUnit:GetName() .. " -- " .. killerEntity:GetName())
    if killedUnit:GetTeam() == DOTA_TEAM_BADGUYS and killerEntity:GetTeam() == DOTA_TEAM_GOODGUYS then
      self.nRadiantKills = self.nRadiantKills + 1
      if END_GAME_ON_KILLS and self.nRadiantKills >= KILLS_TO_END_GAME_FOR_TEAM then
        GameRules:SetSafeToLeave( true )
        GameRules:SetGameWinner( DOTA_TEAM_GOODGUYS )
      end
    elseif killedUnit:GetTeam() == DOTA_TEAM_GOODGUYS and killerEntity:GetTeam() == DOTA_TEAM_BADGUYS then
      self.nDireKills = self.nDireKills + 1
      if END_GAME_ON_KILLS and self.nDireKills >= KILLS_TO_END_GAME_FOR_TEAM then
        GameRules:SetSafeToLeave( true )
        GameRules:SetGameWinner( DOTA_TEAM_BADGUYS )
      end
    end

    if SHOW_KILLS_ON_TOPBAR then
      GameRules:GetGameModeEntity():SetTopBarTeamValue ( DOTA_TEAM_BADGUYS, self.nDireKills )--设置顶端的队伍数值
      GameRules:GetGameModeEntity():SetTopBarTeamValue ( DOTA_TEAM_GOODGUYS, self.nRadiantKills )--设置顶端的队伍数值
    end
  end

  -- Put code here to handle when an entity gets killed
end


--该函数初始化游戏模式,最早加载到游戏
-- This function initializes the game mode and is called before anyone loads into the game
--它可以用来pre-initialize以后需要任何值/表
-- It can be used to pre-initialize any values/tables that will be needed later
function GameMode:InitGameMode()
  GameMode = self
  print( "[BAREBONES]  RC is loaded." )
  print('[BAREBONES]   Starting to load Barebones gamemode...')
  
  self.m_TeamColors = {}
  self.m_TeamColors[DOTA_TEAM_GOODGUYS] = { 61, 210, 150 }  --    Teal
  self.m_TeamColors[DOTA_TEAM_BADGUYS]  = { 243, 201, 9 }   --    Yellow
  self.m_TeamColors[DOTA_TEAM_CUSTOM_1] = { 197, 77, 168 }  --      Pink
  
  for team = 0, (DOTA_TEAM_COUNT-1) do
    color = self.m_TeamColors[ team ]
    if color then
      SetTeamCustomHealthbarColor( team, color[1], color[2], color[3] )
      print( team.." RC is loaded." )
    end
  end
  
  self.m_VictoryMessages = {}
  self.m_VictoryMessages[DOTA_TEAM_GOODGUYS] = "#VictoryMessage_GoodGuys"
  self.m_VictoryMessages[DOTA_TEAM_BADGUYS]  = "#VictoryMessage_BadGuys"
  self.m_VictoryMessages[DOTA_TEAM_CUSTOM_1] = "#VictoryMessage_Custom1"
  
  self:GatherAndRegisterValidTeams()
  -- 设置规则
  GameRules:SetHeroRespawnEnabled( ENABLE_HERO_RESPAWN )
  GameRules:SetUseUniversalShopMode( UNIVERSAL_SHOP_MODE )
  GameRules:SetSameHeroSelectionEnabled( ALLOW_SAME_HERO_SELECTION )
  GameRules:SetHeroSelectionTime( HERO_SELECTION_TIME )
  GameRules:SetPreGameTime( PRE_GAME_TIME)
  GameRules:SetPostGameTime( POST_GAME_TIME )
  GameRules:SetTreeRegrowTime( TREE_REGROW_TIME )
  GameRules:SetUseCustomHeroXPValues ( USE_CUSTOM_XP_VALUES )
  GameRules:SetGoldPerTick(GOLD_PER_TICK)
  GameRules:SetGoldTickTime(GOLD_TICK_TIME)
  GameRules:SetRuneSpawnTime(RUNE_SPAWN_TIME)
  GameRules:SetUseBaseGoldBountyOnHeroes(USE_STANDARD_HERO_GOLD_BOUNTY)
  GameRules:SetHeroMinimapIconScale( MINIMAP_ICON_SIZE )
  GameRules:SetCreepMinimapIconScale( MINIMAP_CREEP_ICON_SIZE )
  GameRules:SetRuneMinimapIconScale( MINIMAP_RUNE_ICON_SIZE )
  print('[BAREBONES]   GameRules set')

  InitLogFile( "log/barebones.txt","")--创建日志文档

  -- 事件监听
  -- All of these events can potentially be fired by the game, though only the uncommented ones have had
  -- Functions supplied for them.  If you are interested in the other events, you can uncomment the
  -- ListenToGameEvent line and add a function to handle the event
  --实现简单的监听事件
  ListenToGameEvent('player_connect_full', Dynamic_Wrap(GameMode, 'OnConnectFull'), self)
  --[[ListenToGameEvent('dota_player_gained_level', Dynamic_Wrap(GameMode, 'OnPlayerLevelUp'), self)
  ListenToGameEvent('dota_ability_channel_finished', Dynamic_Wrap(GameMode, 'OnAbilityChannelFinished'), self)
  ListenToGameEvent('dota_player_learned_ability', Dynamic_Wrap(GameMode, 'OnPlayerLearnedAbility'), self)
  ListenToGameEvent('entity_killed', Dynamic_Wrap(GameMode, 'OnEntityKilled'), self)  
  ListenToGameEvent('player_disconnect', Dynamic_Wrap(GameMode, 'OnDisconnect'), self)
  ListenToGameEvent('dota_item_purchased', Dynamic_Wrap(GameMode, 'OnItemPurchased'), self)
  ListenToGameEvent('dota_item_picked_up', Dynamic_Wrap(GameMode, 'OnItemPickedUp'), self)
  ListenToGameEvent('last_hit', Dynamic_Wrap(GameMode, 'OnLastHit'), self)
  ListenToGameEvent('dota_non_player_used_ability', Dynamic_Wrap(GameMode, 'OnNonPlayerUsedAbility'), self)
  ListenToGameEvent('player_changename', Dynamic_Wrap(GameMode, 'OnPlayerChangedName'), self)
  ListenToGameEvent('dota_rune_activated_server', Dynamic_Wrap(GameMode, 'OnRuneActivated'), self)
  ListenToGameEvent('dota_player_take_tower_damage', Dynamic_Wrap(GameMode, 'OnPlayerTakeTowerDamage'), self)
  ListenToGameEvent('tree_cut', Dynamic_Wrap(GameMode, 'OnTreeCut'), self)
  ListenToGameEvent('entity_hurt', Dynamic_Wrap(GameMode, 'OnEntityHurt'), self)
  ListenToGameEvent('player_connect', Dynamic_Wrap(GameMode, 'PlayerConnect'), self)
  ListenToGameEvent('dota_player_used_ability', Dynamic_Wrap(GameMode, 'OnAbilityUsed'), self)

  
  ListenToGameEvent('dota_player_pick_hero', Dynamic_Wrap(GameMode, 'OnPlayerPickHero'), self)
  ListenToGameEvent('dota_team_kill_credit', Dynamic_Wrap(GameMode, 'OnTeamKillCredit'), self)
  ListenToGameEvent("player_reconnected", Dynamic_Wrap(GameMode, 'OnPlayerReconnect'), self)]]
  --ListenToGameEvent('player_spawn', Dynamic_Wrap(GameMode, 'OnPlayerSpawn'), self)
  --ListenToGameEvent('dota_unit_event', Dynamic_Wrap(GameMode, 'OnDotaUnitEvent'), self)
  --ListenToGameEvent('nommed_tree', Dynamic_Wrap(GameMode, 'OnPlayerAteTree'), self)
  --ListenToGameEvent('player_completed_game', Dynamic_Wrap(GameMode, 'OnPlayerCompletedGame'), self)
  --ListenToGameEvent('dota_match_done', Dynamic_Wrap(GameMode, 'OnDotaMatchDone'), self)
  --ListenToGameEvent('dota_combatlog', Dynamic_Wrap(GameMode, 'OnCombatLogEvent'), self)
  --ListenToGameEvent('dota_player_killed', Dynamic_Wrap(GameMode, 'OnPlayerKilled'), self)
  --ListenToGameEvent('player_team', Dynamic_Wrap(GameMode, 'OnPlayerTeam'), self)
  ListenToGameEvent('game_rules_state_change', Dynamic_Wrap(GameMode, 'OnGameRulesStateChange'), self)
  ListenToGameEvent('npc_spawned', Dynamic_Wrap(GameMode, 'OnNPCSpawned'), self)


  --控制点命令
  -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
  Convars:RegisterCommand( "command_example", Dynamic_Wrap(GameMode, 'ExampleConsoleCommand'), "A console command example", 0 )
  
  -- Fill server with fake clients
  -- Fake clients don't use the default bot AI for buying items or moving down lanes and are sometimes necessary for debugging
  Convars:RegisterCommand('fake', function()
    --检查服务器是否在运行
    -- Check if the server ran it
    if not Convars:GetCommandClient() then
      --创建玩家
      -- Create fake Players
      SendToServerConsole('dota_create_fake_clients')
        
      Timers:CreateTimer('assign_fakes', {
        useGameTime = false,
        endTime = Time(),
        callback = function(barebones, args)
          local userID = 20
          for i=0, 9 do
            userID = userID + 1
            --检查是否这个玩家是否是假的
            -- Check if this player is a fake one
            if PlayerResource:IsFakeClient(i) then
              --获取实例
              -- Grab player instance
              local ply = PlayerResource:GetPlayer(i)
              --确定所获取的玩家
              -- Make sure we actually found a player instance
              if ply then
                CreateHeroForPlayer('npc_dota_hero_axe', ply)
                self:OnConnectFull({
                  userid = userID,
                  index = ply:entindex()-1
                })

                ply:GetAssignedHero():SetControllableByPlayer(0, true)--以玩家ID设置该单位的控制权。
              end
            end
          end
        end})
    end
  end, 'Connects and assigns fake Players.', 0)

  --[[
  测试命令行
  This block is only used for testing events handling in the event that Valve adds more in the future
  Convars:RegisterCommand('events_test', function()
      GameMode:StartEventTest()
    end, "events test", 0)]]

  -- Change random seed
  local timeTxt = string.gsub(string.gsub(GetSystemTime(), ':', ''), '0','')
  math.randomseed(tonumber(timeTxt))

  -- Initialized tables for tracking state
  self.vUserIds = {}
  self.vSteamIds = {}
  self.vBots = {}
  self.vBroadcasters = {}

  self.vPlayers = {}
  self.vRadiant = {}
  self.vDire = {}

  self.nRadiantKills = 0
  self.nDireKills = 0

  self.bSeenWaitForPlayers = false

  print('[BAREBONES]   Done loading Barebones gamemode!\n\n')--加载完成核心代码
end

mode = nil

-- 作为第一个播放器加载和调用这个函数设置GameMode参数
-- This function is called as the first player loads and sets up the GameMode parameters
function GameMode:CaptureGameMode()
  if mode == nil then
    -- Set GameMode parameters
    --设置参数
    mode = GameRules:GetGameModeEntity()        
    mode:SetRecommendedItemsDisabled( RECOMMENDED_BUILDS_DISABLED )
    mode:SetCameraDistanceOverride( CAMERA_DISTANCE_OVERRIDE )
    mode:SetCustomBuybackCostEnabled( CUSTOM_BUYBACK_COST_ENABLED )
    mode:SetCustomBuybackCooldownEnabled( CUSTOM_BUYBACK_COOLDOWN_ENABLED )
    mode:SetBuybackEnabled( BUYBACK_ENABLED )
    mode:SetTopBarTeamValuesOverride ( USE_CUSTOM_TOP_BAR_VALUES )
    mode:SetTopBarTeamValuesVisible( TOP_BAR_VISIBLE )
    mode:SetUseCustomHeroLevels ( USE_CUSTOM_HERO_LEVELS )
    mode:SetCustomHeroMaxLevel ( MAX_LEVEL )
    mode:SetCustomXPRequiredToReachNextLevel( XP_PER_LEVEL_TABLE )

    --mode:SetBotThinkingEnabled( USE_STANDARD_DOTA_BOT_THINKING )
    mode:SetTowerBackdoorProtectionEnabled( ENABLE_TOWER_BACKDOOR_PROTECTION )

    mode:SetFogOfWarDisabled(DISABLE_FOG_OF_WAR_ENTIRELY)
    mode:SetGoldSoundDisabled( DISABLE_GOLD_SOUNDS )
    mode:SetRemoveIllusionsOnDeath( REMOVE_ILLUSIONS_ON_DEATH )

    -- This is important for cosmetic switching
    --发送控制台命令
    SendToServerConsole("dota_combine_models 0")
    SendToConsole("dota_combine_models 0")

    GameRules:GetGameModeEntity():SetThink( "OnThink", self, 1 ) 
    SPAWN:Init()
  end 
end

-- Multiteam support is unfinished currently
--支持多团队
--[[function GameMode:SetupMultiTeams()
  MultiTeam:start()
  MultiTeam:CreateTeam("team1")
  MultiTeam:CreateTeam("team2")
end]]

-- This function is called 1 to 2 times as the player connects initially but before they 
-- have completely connected
function GameMode:PlayerConnect(keys)
  print('[BAREBONES]   PlayerConnect')
  PrintTable(keys)
  
  if keys.bot == 1 then
    -- This user is a Bot, so add it to the bots table
    self.vBots[keys.userid] = 1
  end
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
--玩家全部点击准备之后
function GameMode:OnConnectFull(keys)
  print ('[BAREBONES]   OnConnectFull')
  PrintTable(keys)
  GameMode:CaptureGameMode()
  
  local entIndex = keys.index+1
  --玩家加入用户的实体
  -- The Player entity of the joining user
  local ply = EntIndexToHScript(entIndex)
  --加入玩家的玩家ID
  -- The Player ID of the joining player
  local playerID = ply:GetPlayerID()
  --用该用户的用户ID表更新
  -- Update the user ID table with this user
  self.vUserIds[keys.userid] = ply
  --  更新Steam IDID表
  -- Update the Steam ID table
  self.vSteamIds[PlayerResource:GetSteamAccountID(playerID)] = ply
  
  -- If the player is a broadcaster flag it in the Broadcasters table
  if PlayerResource:IsBroadcaster(playerID) then
    self.vBroadcasters[keys.userid] = 1
    return
  end
end

--收集队伍信息
function GameMode:GatherAndRegisterValidTeams()
--  print( "GatherValidTeams:" )
  local foundTeams = {}
  for _, playerStart in pairs( Entities:FindAllByClassname( "info_player_start_dota" ) ) do
    foundTeams[  playerStart:GetTeam() ] = true
  end

  local numTeams = TableCount(foundTeams)
  print( "GatherValidTeams - Found spawns for a total of " .. numTeams .. " teams" )
  
  local foundTeamsList = {}
  for t, _ in pairs( foundTeams ) do
    table.insert( foundTeamsList, t )
  end

  if numTeams == 0 then
    print( "GatherValidTeams - NO team spawns detected, defaulting to GOOD/BAD" )
    table.insert( foundTeamsList, DOTA_TEAM_GOODGUYS )
    table.insert( foundTeamsList, DOTA_TEAM_BADGUYS )
    table.insert( foundTeamsList, DOTA_Custom1 )
    numTeams = 3
  end

  local maxPlayersPerValidTeam = 3

  self.m_GatheredShuffledTeams = ShuffledList( foundTeamsList )

  print( "Final shuffled team list:" )
  for _, team in pairs( self.m_GatheredShuffledTeams ) do
    print( " - " .. team .. " ( " .. GetTeamName( team ) .. " )" )
  end

  print( "Setting up teams:" )
  for team = 0, (DOTA_TEAM_COUNT-1) do
    local maxPlayers = 0
    if ( nil ~= TableFindKey( foundTeamsList, team ) ) then
      maxPlayers = maxPlayersPerValidTeam
    end
    print( " - " .. team .. " ( " .. GetTeamName( team ) .. " ) -> max players = " .. tostring(maxPlayers) )
    GameRules:SetCustomGameTeamMaxPlayers( team, maxPlayers )
  end
end


function GameMode:OnThink()
  for nPlayerID = 0, (DOTA_MAX_TEAM_PLAYERS-1) do
    self:UpdatePlayerColor( nPlayerID )
  end
  
  self:UpdateScoreboard()
  -- Stop thinking if game is paused
  if GameRules:IsGamePaused() == true then
        return 1
    end

  if self.countdownEnabled == true then
    CountdownTimer()
    if nCOUNTDOWNTIMER == 30 then
      CustomGameEventManager:Send_ServerToAllClients( "timer_alert", {} )
    end
    if nCOUNTDOWNTIMER <= 0 then
      --Check to see if there's a tie
      if self.isGameTied == false then
        GameRules:SetCustomVictoryMessage( self.m_VictoryMessages[self.leadingTeam] )
        GameMode:EndGame( self.leadingTeam )
        self.countdownEnabled = false
      else
        self.TEAM_KILLS_TO_WIN = self.leadingTeamScore + 1
        local broadcast_killcount = 
        {
          killcount = self.TEAM_KILLS_TO_WIN
        }
        CustomGameEventManager:Send_ServerToAllClients( "overtime_alert", broadcast_killcount )
      end
        end
  end
  
  if GameRules:State_Get() == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
    --Spawn Gold Bags
    --GameMode:ThinkGoldDrop()
    --GameMode:ThinkSpecialItemDrop()
  end

  return 1
end

function GameMode:UpdatePlayerColor( nPlayerID )
  if not PlayerResource:HasSelectedHero( nPlayerID ) then
    return
  end

  local hero = PlayerResource:GetSelectedHeroEntity( nPlayerID )
  if hero == nil then
    return
  end

  local teamID = PlayerResource:GetTeam( nPlayerID )
  local color = self:ColorForTeam( teamID )
  PlayerResource:SetCustomPlayerColor( nPlayerID, color[1], color[2], color[3] )
end

--------------------------------------------------------------------------------
-- 监听游戏开始开始之后中间刷兵
--------------------------------------------------------------------------------
function GameMode:OnGameRulesStateChange( keys )
    print("OnGameRulesStateChange")
    --获取游戏进度
    local newState = GameRules:State_Get()
    if newState == DOTA_GAMERULES_STATE_PRE_GAME then

    end
 
    --游戏开始
    if newState==DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
        SPAWN:SpawnStart()
    end
end

---------------------------------------------------------------------------
-- Simple scoreboard using debug text
---------------------------------------------------------------------------
function GameMode:UpdateScoreboard()
  local sortedTeams = {}
  for _, team in pairs( self.m_GatheredShuffledTeams ) do
    table.insert( sortedTeams, { teamID = team, teamScore = GetTeamHeroKills( team ) } )
  end

  -- reverse-sort by score
  table.sort( sortedTeams, function(a,b) return ( a.teamScore > b.teamScore ) end )

  for _, t in pairs( sortedTeams ) do
    local clr = self:ColorForTeam( t.teamID )

    -- Scaleform UI Scoreboard
    local score = 
    {
      team_id = t.teamID,
      team_score = t.teamScore
    }
    FireGameEvent( "score_board", score )
  end
  -- Leader effects (moved from OnTeamKillCredit)
  local leader = sortedTeams[1].teamID
  --print("Leader = " .. leader)
  self.leadingTeam = leader
  self.runnerupTeam = sortedTeams[2].teamID
  self.leadingTeamScore = sortedTeams[1].teamScore
  self.runnerupTeamScore = sortedTeams[2].teamScore
  if sortedTeams[1].teamScore == sortedTeams[2].teamScore then
    self.isGameTied = true
  else
    self.isGameTied = false
  end
  local allHeroes = HeroList:GetAllHeroes()
  for _,entity in pairs( allHeroes) do
    if entity:GetTeamNumber() == leader and sortedTeams[1].teamScore ~= sortedTeams[2].teamScore then
      if entity:IsAlive() == true then
        -- Attaching a particle to the leading team heroes
        local existingParticle = entity:Attribute_GetIntValue( "particleID", -1 )
            if existingParticle == -1 then
              local particleLeader = ParticleManager:CreateParticle( "particles/leader/leader_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, entity )
          ParticleManager:SetParticleControlEnt( particleLeader, PATTACH_OVERHEAD_FOLLOW, entity, PATTACH_OVERHEAD_FOLLOW, "follow_overhead", entity:GetAbsOrigin(), true )
          entity:Attribute_SetIntValue( "particleID", particleLeader )
        end
      else
        local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
        if particleLeader ~= -1 then
          ParticleManager:DestroyParticle( particleLeader, true )
          entity:DeleteAttribute( "particleID" )
        end
      end
    else
      local particleLeader = entity:Attribute_GetIntValue( "particleID", -1 )
      if particleLeader ~= -1 then
        ParticleManager:DestroyParticle( particleLeader, true )
        entity:DeleteAttribute( "particleID" )
      end
    end
  end
end

---------------------------------------------------------------------------
-- Get the color associated with a given teamID
---------------------------------------------------------------------------
function GameMode:ColorForTeam( teamID )
  local color = self.m_TeamColors[ teamID ]
  if color == nil then
    color = { 255, 255, 255 } -- default to white
  end
  return color
end

-- This is an example console command
--控制台命令
function GameMode:ExampleConsoleCommand()
  print( '******* Example Console Command ***************' )
  local cmdPlayer = Convars:GetCommandClient()--返回输入该控制台指令的玩家
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      --执行命令
      -- Do something here for the player who called this command
      PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)-- 将玩家的英雄替换成指定的英雄、金钱和经验值
    end
  end

  print( '*********************************************' )
end

--require('eventtest')
--GameMode:StartEventTest()