-- =========================================================
-- MODULO: dungeon_core / restrictions
-- Gestiona las restricciones de nodos del Dungeon Escape.
-- =========================================================


local M = {}


-- =========================================================
-- CONFIGURAR RESTRICCIONES
-- =========================================================

function M.setup(config)

    local nodos_irrompibles =
        config.nodos_irrompibles


    -- =====================================================
    -- HACER NODOS IRROMPIBLES CON LA MANO
    -- =====================================================

    minetest.register_on_mods_loaded(
        function()

            for _, nodename in ipairs(
                nodos_irrompibles
            ) do

                local def =
                    minetest.registered_nodes[
                        nodename
                    ]


                if def then

                    local groups =
                        table.copy(
                            def.groups or {}
                        )


                    -- Dureza equivalente a piedra.
                    groups.cracky = 3


                    -- Evita que pueda romperse
                    -- fácilmente con la mano.
                    groups.oddly_breakable_by_hand =
                        nil

                    groups.dig_immediate =
                        nil


                    minetest.override_item(
                        nodename,
                        {
                            groups = groups
                        }
                    )

                else

                    minetest.log(
                        "warning",
                        "[dungeon_core] Node does not found: "
                        .. nodename
                    )

                end

            end

        end
    )


    -- =====================================================
    -- BLOQUEAR LA COLOCACIÓN DE NODOS
    -- =====================================================

    minetest.register_on_mods_loaded(
        function()

            for nodename, _ in pairs(
                minetest.registered_nodes
            ) do

                minetest.override_item(
                    nodename,
                    {
                        on_place = function(
                            itemstack,
                            placer,
                            pointed_thing
                        )

                            -- No permitir colocar nodos.
                            return itemstack

                        end
                    }
                )

            end

        end
    )

end


return M
