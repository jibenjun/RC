--[[
      ==Ninja_War:addon_game_mode.lua==
      *********2015.09.18*********
      ***********AMHC.Jackie_龍*************
      ============================
        Authors:
        Jackie_龍
        ...
      ============================
]]


---------------------------------------------------------------------------
-- Required .lua files
---------------------------------------------------------------------------
--require( "events" )
require( "items/items" )
--require( "utility_functions" )
require( "core/spawner")
require( "core/barebones")
require( "util/popup")
require( "util/global_function")
require( "util/timers")
require( "util/utility_functions")
require( "util/util")
---------------------------------------------------------------------------
-- Precache
---------------------------------------------------------------------------
local function PrecacheSound(sound, context )
    PrecacheResource( "soundfile", sound, context)
end

local function PrecacheParticle(particle, context )
    PrecacheResource( "particle",  particle, context)
end

local function PrecacheModel(model, context )
    PrecacheResource( "model", model, context )
end


function Precache( context )
--	--Cache the gold bags
--		PrecacheItemByNameSync( "item_bag_of_gold", context )
--		PrecacheResource( "particle", "particles/items2_fx/veil_of_discord.vpcf", context )	
--
--		PrecacheItemByNameSync( "item_treasure_chest", context )
--		PrecacheModel( "item_treasure_chest", context )
--
--	--Cache the creature models
--		PrecacheUnitByNameSync( "npc_dota_creature_basic_zombie", context )
--    PrecacheModel( "npc_dota_creature_basic_zombie", context )
--
--    PrecacheUnitByNameSync( "npc_dota_creature_berserk_zombie", context )
--    PrecacheModel( "npc_dota_creature_berserk_zombie", context )
--
--    PrecacheUnitByNameSync( "npc_dota_treasure_courier", context )
--    PrecacheModel( "npc_dota_treasure_courier", context )
--
--    --Cache new particles
--   	PrecacheResource( "particle", "particles/econ/events/nexon_hero_compendium_2014/teleport_end_nexon_hero_cp_2014.vpcf", context )
--   	PrecacheResource( "particle", "particles/leader/leader_overhead.vpcf", context )
--   	PrecacheResource( "particle", "particles/last_hit/last_hit.vpcf", context )
--   	PrecacheResource( "particle", "particles/units/heroes/hero_zuus/zeus_taunt_coin.vpcf", context )
--   	PrecacheResource( "particle", "particles/addons_gameplay/player_deferred_light.vpcf", context )
--   	PrecacheResource( "particle", "particles/items_fx/black_king_bar_avatar.vpcf", context )
--   	PrecacheResource( "particle", "particles/treasure_courier_death.vpcf", context )

    -- 从KV文件统一载入小怪模型
    local unit_kv = LoadKeyValues("scripts/npc/npc_units_custom.txt")
    if unit_kv then
        for unit_name,keys in pairs(unit_kv) do
            print("[PRECACHE]   precacheing resource for unit: "..unit_name)
            if type(keys) == "table" then
                if keys.Model then
                    print("[PRECACHE]   precacheing model: "..keys.Model)
                    PrecacheModel(keys.Model, context )
                end
            end
        end
    end
	-- 从KV文件统一载入物品模型
    local item_kv = LoadKeyValues("scripts/npc/npc_items_custom.txt")
    if item_kv then
        for item_name,keys in pairs(item_kv) do
            print("[PRECACHE]   precacheing resource for item: "..item_name)
            if type(keys) == "table" then
                if keys.Model then
                    print("[PRECACHE]   precacheing model: "..keys.Model)
                    PrecacheModel(keys.Model, context )
                end
            end
        end
    end
end


function Activate()
	-- 游戏模式初始化
	GameRules.GameMode = GameMode()
	GameRules.GameMode:InitGameMode()
  GameRules.GameMode:CaptureGameMode()
end

