-- =========================================================
-- CONFIGURACIÓN DE dungeon_core
-- =========================================================

local config = {}

config.spawn_pos = {
    x = 103,
    y = 203,
    z = 147
}

config.dungeon_mode =
    minetest.settings:get("dungeon_mode")
    or "Normal"

if config.dungeon_mode ~= "Normal"
    and config.dungeon_mode ~= "Hardcore"
    and config.dungeon_mode ~= "Permadeath"
then
    config.dungeon_mode = "Normal"
end

config.monster_damage_multiplier = 1

if config.dungeon_mode == "Hardcore" then
    config.monster_damage_multiplier = 1.5
elseif config.dungeon_mode == "Permadeath" then
    config.monster_damage_multiplier = 2
end

config.dungeon_map_min = {
    x = -6,
    y = -13,
    z = -15
}

config.nodos_irrompibles = {
    "default:ladder_wood",
    "ethereal:stone_ladder",
    "paintings_lib:4x4_read_2",
    "paintings_lib:1x2_cat",
    "paintings_lib:1x1_minds_eye",
    "default:chest",
    "default:bookshelf",
    "default:pine_wood",
    "default:acacia_wood",
    "default:aspen_wood",
    "moreblocks:stair_pine_wood",
    "xpanes:pane_flat",
    "doors:door_wood_a",
    "doors:door_wood_b",
    "carpet:wool_dark_grey",
    "signs:paper_poster",
}

config.modpath =
    minetest.get_modpath("dungeon_core")

config.dungeon_map_file =
    config.modpath .. "/map/dungeon1.zip"

return config
