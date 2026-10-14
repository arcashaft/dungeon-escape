-- =========================================================
-- MODULO: dungeon_core / permadeath
-- Gestiona la pantalla GAME OVER de Permadeath.
-- =========================================================

local S = minetest.get_translator("dungeon_core")

local M = {}


function M.setup(config)

    local dungeon_mode =
        config.dungeon_mode


    -- =====================================================
    -- CONTROL DEL FORMULARIO GAME OVER
    -- =====================================================

    minetest.register_on_player_receive_fields(
        function(
            player,
            formname,
            fields
        )

            if formname ==
                "dungeon_core:permadeath"
            then

                if fields.close then

                    minetest.request_shutdown(
                        S("Game over."),
                        false,
                        0
                    )

                    return true

                end

            end

        end
    )


    -- =====================================================
    -- PANTALLA DE MUERTE DE PERMADEATH
    -- =====================================================

    local original_show_death_screen =
        minetest.show_death_screen


    minetest.show_death_screen =
        function(player, reason)

            if dungeon_mode ~= "Permadeath" then

                -- Normal y Hardcore utilizan la pantalla
                -- de muerte habitual de Luanti.

                original_show_death_screen(
                    player,
                    reason
                )

                return

            end


            local name =
                player:get_player_name()


            local formspec =
                "formspec_version[4]"
                .. "size[8,5]"
                .. "label[3.1,0.8;"
                .. S("GAME OVER")
                .. "]"
                .. "label[1.45,1.8;"
                .. S("You died.")
                .. "]"
                .. "label[1.0,2.45;"
                .. S("The game is over.")
                .. "]"
                .. "button_exit[3,3.5;2,0.8;close;"
                .. S("Close")
                .. "]"


            minetest.show_formspec(
                name,
                "dungeon_core:permadeath",
                formspec
            )

        end

end


return M
