-- =========================================================
-- MOD: dungeon_checkpoint
-- Gestiona los checkpoints de Dungeon Escape.
--
-- /setspawn:
--   Checkpoint de sala.
--   Solo funciona en modo Normal.
--
-- /forcespawn:
--   Spawn forzado.
--   Funciona en Normal y Hardcore.
--
-- En Permadeath ambos comandos se ignoran.
-- =========================================================

local S = minetest.get_translator("dungeon_checkpoint")

-- =========================================================
-- MODO DE JUEGO
-- =========================================================

local dungeon_mode =
    minetest.settings:get("dungeon_mode")
    or "Normal"


if dungeon_mode ~= "Normal"
    and dungeon_mode ~= "Hardcore"
    and dungeon_mode ~= "Permadeath"
then
    dungeon_mode = "Normal"
end


-- =========================================================
-- FUNCIÓN PARA PARSEAR LOS PARÁMETROS
-- =========================================================

local function get_target_and_pos(name, param)

    local args =
        string.split(param, " ")

    local target_name =
        name

    local pos = nil


    -- -----------------------------------------------------
    -- /comando <jugador>
    -- -----------------------------------------------------

    if #args == 1
        and args[1] ~= ""
    then

        target_name =
            args[1]


    -- -----------------------------------------------------
    -- /comando <x> <y> <z>
    -- -----------------------------------------------------

    elseif #args == 3 then

        local x =
            tonumber(args[1])

        local y =
            tonumber(args[2])

        local z =
            tonumber(args[3])


        if x and y and z then

            pos = {
                x = x,
                y = y,
                z = z
            }

        end


    -- -----------------------------------------------------
    -- /comando <jugador> <x> <y> <z>
    -- -----------------------------------------------------

    elseif #args >= 4 then

        target_name =
            args[1]

        local x =
            tonumber(args[2])

        local y =
            tonumber(args[3])

        local z =
            tonumber(args[4])


        if x and y and z then

            pos = {
                x = x,
                y = y,
                z = z
            }

        end

    end


    local player =
        minetest.get_player_by_name(
            target_name
        )


    if not player and not pos then

        return nil, nil,
            S("Player not found or invalid coordinates.")

    end


    -- -----------------------------------------------------
    -- Si no hay coordenadas, usar posición actual.
    -- -----------------------------------------------------

    if not pos and player then

        pos =
            player:get_pos()

    end


    if not pos then

        return nil, nil,
            S("The position could not be determined.")

    end


    pos =
        vector.round(pos)


    return player, pos, nil

end


-- =========================================================
-- /SETSPAWN
--
-- Solo tiene efecto en NORMAL.
--
-- En Hardcore y Permadeath:
-- el comando existe, pero se ignora.
-- =========================================================

minetest.register_chatcommand(
    "setspawn",
    {
        params = "[] [  ]",

        description =
            S("Set the room's checkpoint."),

        privs = {
            interact = true,
            dungeon_privs = true
        },

        func = function(name, param)

            -- -------------------------------------------------
            -- Hardcore / Permadeath:
            -- se ejecuta, pero no hace nada.
            -- -------------------------------------------------

            if dungeon_mode ~= "Normal" then
                return true
            end


            local player, pos, err =
                get_target_and_pos(
                    name,
                    param
                )


            if err then
                return false, err
            end


            -- -------------------------------------------------
            -- Guardar checkpoint de sala.
            -- -------------------------------------------------

            if player then

                player:get_meta():set_string(
                    "checkpoint_spawn",
                    minetest.pos_to_string(pos)
                )


                -- Compatibilidad con el sistema anterior.
                player:get_meta():set_string(
                    "beds_spawn",
                    minetest.pos_to_string(pos)
                )

            end


            return true,
                S("Checkpoint activated for ")
                .. (player
                    and player:get_player_name()
                    or name)
                .. S(" at ")
                .. minetest.pos_to_string(pos)

        end
    }
)


-- =========================================================
-- /FORCESPAWN
--
-- Funciona en NORMAL y HARDCORE.
--
-- En Permadeath:
-- el comando existe, pero se ignora.
-- =========================================================

minetest.register_chatcommand(
    "forcespawn",
    {
        params = "[] [  ]",

        description =
            S("Set a forced spawn."),

        privs = {
            interact = true,
            dungeon_privs = true
        },

        func = function(name, param)

            -- -------------------------------------------------
            -- Permadeath:
            -- se ejecuta, pero no hace nada.
            -- -------------------------------------------------

            if dungeon_mode == "Permadeath" then
                return true
            end


            local player, pos, err =
                get_target_and_pos(
                    name,
                    param
                )


            if err then
                return false, err
            end


            -- -------------------------------------------------
            -- Guardar spawn forzado.
            -- -------------------------------------------------

            if player then

                player:get_meta():set_string(
                    "forcespawn_spawn",
                    minetest.pos_to_string(pos)
                )


                -- Un forcespawn elimina el checkpoint
                -- de sala anterior.
                --
                -- Así este punto pasa a ser realmente
                -- el nuevo spawn forzado.
                player:get_meta():set_string(
                    "checkpoint_spawn",
                    ""
                )


                player:get_meta():set_string(
                    "beds_spawn",
                    minetest.pos_to_string(pos)
                )

            end


            return true,
                S("Forced spawn set for ")
                .. (player
                    and player:get_player_name()
                    or name)
                .. S(" at ")
                .. minetest.pos_to_string(pos)

        end
    }
)
