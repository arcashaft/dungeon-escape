-- =========================================================
-- MOD: dungeon_core
-- =========================================================


-- =========================================================
-- CARGAR CONFIGURACIÓN
-- =========================================================

local modpath =
    minetest.get_modpath("dungeon_core")

local config =
    dofile(modpath .. "/src/config.lua")    

local dungeon_mode =
    config.dungeon_mode

local nodos_irrompibles =
    config.nodos_irrompibles


-- =========================================================
-- CARGA DE ARCHIVOS
-- =========================================================


local map =
    dofile(modpath .. "/src/map.lua")

local dungeon =
    map.setup(config)

local commands =
    dofile(modpath .. "/src/commands.lua")

commands.setup({
    dungeon_mode = dungeon_mode
})

-- local books =
--     dofile(modpath .. "/src/books.lua")

local restrictions =
    dofile(modpath .. "/src/restrictions.lua")

restrictions.setup({
    nodos_irrompibles = nodos_irrompibles
})

local combat =
    dofile(modpath .. "/src/combat.lua")

combat.setup(config)

local permadeath =
    dofile(modpath .. "/src/permadeath.lua")

permadeath.setup(config)

local player =
    dofile(modpath .. "/src/player.lua")

player.setup(config)

local signs =
    dofile(modpath .. "/src/signs.lua")

signs.setup(dungeon)

local reset =
    dofile(modpath .. "/src/reset.lua")

reset.setup(dungeon)
