-- =========================================================
-- MOD: dungeon_core - COMANDOS
-- =========================================================

local S = minetest.get_translator("dungeon_core")

local commands = {}

function commands.setup(ctx)

    local dungeon_mode = ctx.dungeon_mode

    -- =========================================================
    -- PRIVILEGIO DEL DUNGEON
    -- =========================================================

    minetest.register_privilege(
        "dungeon_privs",
        {
            description = S("Allows the use of Dungeon Escape commands."),
            give_to_singleplayer = false,
            give_to_admin = false
        }
    )

    -- =========================================================
    -- COMANDO PARA SANAR AL 100 %
    -- =========================================================

    minetest.register_chatcommand(
        "heal",
        {
            description = S("Restores full health according to the game mode."),

            privs = {
                dungeon_privs = true
            },

            func = function(name, param)

                local player =
                    minetest.get_player_by_name(name)

                if not player then
                    return false, S("Player not found.")
                end

                local max_hp = 20

                if dungeon_mode == "Hardcore"
                    or dungeon_mode == "Permadeath"
                then
                    max_hp = 2
                end

                player:set_hp(max_hp)

                return true
            end
        }
    )

    -- =========================================================
    -- IMPEDIR QUE EL JUGADOR SE DÉ PRIVILEGIOS A SÍ MISMO
    -- =========================================================

    minetest.register_on_chatcommand(
        function(name, command, param)

            -- /grantme siempre queda bloqueado para el jugador.
            if command == "grantme" then

                minetest.chat_send_player(
                    name,
                    S("You cannot grant yourself privileges during the game.")
                )

                return true
            end

            -- /grant nombre privilegio
            -- Bloquear únicamente si el destinatario es el propio jugador.
            if command == "grant" then

                local target_name =
                    param:match("^([^ ]+)")

                if target_name
                    and target_name == name
                then

                    minetest.chat_send_player(
                        name,
                        S("You cannot grant yourself privileges during the game.")
                    )

                    return true
                end

            end

        end
    )

end

return commands
