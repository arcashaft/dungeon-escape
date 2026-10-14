-- =========================================================
-- MODULO: dungeon_core / player
-- Gestiona el comportamiento del jugador.
-- =========================================================

local M = {}


function M.setup(config)

    local spawn_pos =
        config.spawn_pos

    local dungeon_mode =
        config.dungeon_mode


    -- =====================================================
    -- HUD DE VIDA SEGÚN EL MODO
    -- =====================================================

    local hud_hp_max = 20

    if dungeon_mode == "Hardcore"
        or dungeon_mode == "Permadeath"
    then
        hud_hp_max = 2
    end


    minetest.register_on_mods_loaded(
        function()

            minetest.hud_replace_builtin(
                "health",
                {
                    type = "statbar",

                    position = {
                        x = 0.5,
                        y = 1
                    },

                    text = "heart.png",

                    text2 = "heart_gone.png",

                    number = hud_hp_max,

                    item = hud_hp_max,

                    direction = 0,

                    size = {
                        x = 24,
                        y = 24
                    },

                    offset = {
                        x = (-(hud_hp_max / 2) * 24) - 25,
                        y = -(48 + 24 + 16)
                    }
                }
            )

        end
    )


    -- =====================================================
    -- NUEVO JUGADOR
    -- =====================================================

    minetest.register_on_newplayer(
        function(player)

            player:set_pos(
                spawn_pos
            )

        end
    )


    -- =====================================================
    -- RESPAWN SEGÚN EL MODO DE JUEGO
    -- =====================================================

    minetest.register_on_respawnplayer(
        function(player)

            -- =================================================
            -- PERMADEATH
            -- =================================================

            if dungeon_mode == "Permadeath" then

                -- No se permite reaparecer.
                return true

            end


            -- =================================================
            -- HARDCORE
            -- =================================================
            --
            -- Solo utiliza forcespawn.
            -- =================================================

            if dungeon_mode == "Hardcore" then

                local force_str =
                    player:get_meta():get_string(
                        "forcespawn_spawn"
                    )


                if force_str
                    and force_str ~= ""
                then

                    local force_pos =
                        minetest.string_to_pos(
                            force_str
                        )


                    if force_pos then

                        player:set_pos(
                            force_pos
                        )


                        player:set_hp(2)


                        return true

                    end

                end


                -- Si aún no existe forcespawn,
                -- utilizar el spawn inicial del Dungeon.

                player:set_pos(
                    spawn_pos
                )

                player:set_hp(2)

                return true

            end


            -- =================================================
            -- NORMAL
            -- =================================================
            --
            -- Primero checkpoint de sala.
            -- Si no existe, forcespawn.
            -- Si tampoco existe, spawn inicial.
            -- =================================================

            local checkpoint_str =
                player:get_meta():get_string(
                    "checkpoint_spawn"
                )


            if checkpoint_str
                and checkpoint_str ~= ""
            then

                local checkpoint_pos =
                    minetest.string_to_pos(
                        checkpoint_str
                    )


                if checkpoint_pos then

                    player:set_pos(
                        checkpoint_pos
                    )


                    player:set_hp(20)


                    return true

                end

            end


            -- -------------------------------------------------
            -- Sin checkpoint de sala:
            -- utilizar forcespawn.
            -- -------------------------------------------------

            local force_str =
                player:get_meta():get_string(
                    "forcespawn_spawn"
                )


            if force_str
                and force_str ~= ""
            then

                local force_pos =
                    minetest.string_to_pos(
                        force_str
                    )


                if force_pos then

                    player:set_pos(
                        force_pos
                    )


                    player:set_hp(20)


                    return true

                end

            end


            -- -------------------------------------------------
            -- Sin ningún spawn guardado.
            -- -------------------------------------------------

            player:set_pos(
                spawn_pos
            )


            player:set_hp(20)


            return true

        end
    )


    -- =====================================================
    -- AL ENTRAR AL JUEGO
    -- =====================================================

    minetest.register_on_joinplayer(
        function(player)

            local name =
                player:get_player_name()


            -- =================================================
            -- PRIVILEGIOS
            -- =================================================

            local privs =
                minetest.get_player_privs(
                    name
                )


            privs.protection_bypass = nil
            privs.immortal = nil


            -- Privilegio fast activado.

            privs.fast = true


            minetest.set_player_privs(
                name,
                privs
            )


            -- =================================================
            -- INVENTARIO DEL JUGADOR
            -- =================================================

            -- Desactiva el inventario propio del jugador,
            -- pero NO bloquea cofres ni otros inventarios.

            player:set_inventory_formspec(
                ""
            )


            -- Reforzarlo en el siguiente ciclo por si otro mod
            -- lo cambia durante on_joinplayer.

            minetest.after(
                0,
                function()

                    local p =
                        minetest.get_player_by_name(
                            name
                        )


                    if p then

                        p:set_inventory_formspec(
                            ""
                        )

                    end

                end
            )


            -- =================================================
            -- VIDA
            -- =================================================

            local max_hp = 20


            if dungeon_mode == "Hardcore"
                or dungeon_mode == "Permadeath"
            then

                max_hp = 2

            end


            player:set_properties({
                hp_max = max_hp
            })


            player:set_hp(max_hp)


            -- Reaplicar hp_max después de entrar para asegurar
            -- que el HUD de vida utiliza el máximo correcto.

            minetest.after(
                0.1,
                function()

                    local p =
                        minetest.get_player_by_name(
                            name
                        )


                    if not p then
                        return
                    end


                    p:set_properties({
                        hp_max = max_hp
                    })


                    p:set_hp(max_hp)

                end
            )


            player:set_armor_groups({
                fleshy = 100
            })


            -- =================================================
            -- DAÑO POR CAÍDA
            -- =================================================

            local armor =
                player:get_armor_groups()


            armor.fall_damage_add_percent =
                -80


            player:set_armor_groups(
                armor
            )


            -- =================================================
            -- HUD
            -- =================================================

            player:hud_set_flags({
                healthbar = true,
                breathbar = true
            })

        end
    )

end


return M
