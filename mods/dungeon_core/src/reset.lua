-- =========================================================
-- MODULO: dungeon_core / reset
-- Gestiona el reinicio del Dungeon al morir.
-- =========================================================

local M = {}


function M.setup(ctx)

    local reset_in_progress = false


    -- =====================================================
    -- RESTAURAR UN MAPBLOCK
    -- =====================================================

    local function reset_single_mapblock(
        mapblock
    )

        -- =================================================
        -- LÍMITES DEL MAPBLOCK
        -- =================================================

        local pos1, pos2 =
            mapblock_lib.get_mapblock_bounds_from_mapblock(
                mapblock
            )


        -- =================================================
        -- 1. LIMPIAR METADATA ACTUAL
        -- =================================================

        local metadata_positions =
            minetest.find_nodes_with_meta(
                pos1,
                pos2
            )


        for _, pos in ipairs(
            metadata_positions
        ) do

            -- Detener timers que pudiera haber creado
            -- la partida.

            minetest.get_node_timer(
                pos
            ):stop()


            -- Eliminar metadata actual.

            minetest.get_meta(
                pos
            ):from_table(
                nil
            )

        end


        -- =================================================
        -- 2. VACIAR MAPBLOCK
        -- =================================================

        -- Esto elimina también las entidades no jugador,
        -- entre ellas signs_lib:text.

        mapblock_lib.clear_mapblock(
            mapblock
        )


        -- =================================================
        -- 3. COORDENADAS RELATIVAS DEL ZIP
        -- =================================================

        local relative_mapblock = {
            x = mapblock.x
                - ctx.dungeon_map_min.x,

            y = mapblock.y
                - ctx.dungeon_map_min.y,

            z = mapblock.z
                - ctx.dungeon_map_min.z
        }


        local relative_pos_string =
            minetest.pos_to_string(
                relative_mapblock
            )


        local bin_name =
            "mapblock_"
            .. relative_pos_string
            .. ".bin"


        local meta_name =
            "mapblock_"
            .. relative_pos_string
            .. ".meta.json"


        -- =================================================
        -- 4. LEER MANIFEST
        -- =================================================

        local manifest_data =
            ctx.dungeon_zip:get(
                meta_name
            )


        -- Si no existe, el original era completamente aire.

        if not manifest_data then
            return true
        end


        -- =================================================
        -- 5. LEER MAPBLOCK ORIGINAL
        -- =================================================

        local mapblock_data =
            ctx.dungeon_zip:get(
                bin_name
            )


        if not mapblock_data then

            minetest.log(
                "error",

                "[dungeon_core] Cannot restore "
                .. bin_name
            )

            return false

        end


        local manifest =
            minetest.parse_json(
                manifest_data
            )


        if not manifest then

            minetest.log(
                "error",

                "[dungeon_core] Invalid manifest: "
                .. meta_name
            )

            return false

        end


        local original_mapblock =
            mapblock_lib.read_mapblock(
                mapblock_data
            )


        if not original_mapblock then

            minetest.log(
                "error",

                "[dungeon_core] Cannot read "
                .. bin_name
            )

            return false

        end


        -- =================================================
        -- 6. RESTAURAR MAPBLOCK
        -- =================================================

        local ok, err =
            mapblock_lib.deserialize_mapblock(
                mapblock,
                original_mapblock,
                manifest,
                {
                    mode = "replace"
                }
            )


        if not ok then

            minetest.log(
                "error",

                "[dungeon_core] Error restoring "
                .. minetest.pos_to_string(
                    mapblock
                )
                .. ": "
                .. tostring(err)
            )

            return false

        end


        return true

    end


    -- =====================================================
    -- RESET POR LOTES
    -- =====================================================

    local function reset_mapblocks_batch(
        mapblocks,
        index
    )

        -- =================================================
        -- FIN DEL RESET DE MAPBLOCKS
        -- =================================================

        if index > #mapblocks then

            reset_in_progress = false


            minetest.log(
                "action",
                "[dungeon_core] Mapblocks restored."
            )


            -- Regenerar los carteles después de terminar
            -- TODO el reset.

            minetest.after(
                0.2,
                ctx.restore_all_signs
            )


            return

        end


        -- =================================================
        -- TAMAÑO DEL LOTE
        -- =================================================

        local batch_size = 25


        local last_index =
            math.min(
                index + batch_size - 1,
                #mapblocks
            )


        -- =================================================
        -- PROCESAR LOTE
        -- =================================================

        for i = index,
            last_index do

            reset_single_mapblock(
                mapblocks[i]
            )

        end


        -- =================================================
        -- SIGUIENTE LOTE
        -- =================================================

        minetest.after(
            0,
            reset_mapblocks_batch,
            mapblocks,
            last_index + 1
        )

    end


    -- =====================================================
    -- MUERTE DEL JUGADOR
    -- =====================================================

    minetest.register_on_dieplayer(
        function(player, reason)

            local player_name =
                player:get_player_name()


            -- =================================================
            -- PERDER EL INVENTARIO AL MORIR
            -- =================================================

            local inventory =
                player:get_inventory()

            for listname, _ in pairs(
                inventory:get_lists()
            ) do

                inventory:set_list(
                    listname,
                    {}
                )

            end


            if reset_in_progress then

                minetest.log(
                    "warning",

                    "[dungeon_core] There is already a reset "
                    .. "of the Dungeon in progress."
                )

                return

            end


            reset_in_progress = true


            minetest.log(
                "action",

                "[dungeon_core] "
                .. player_name
                .. " has died."
            )


            -- =================================================
            -- COPIAR LISTA DE MAPBLOCKS
            -- =================================================

            local mapblocks = {}


            for _, mapblock in pairs(
                ctx.generated_mapblocks
            ) do

                table.insert(
                    mapblocks,
                    {
                        x = mapblock.x,
                        y = mapblock.y,
                        z = mapblock.z
                    }
                )

            end


            minetest.log(
                "action",

                "[dungeon_core] Restoring "
                .. #mapblocks
                .. " mapblocks..."
            )


            -- =================================================
            -- NADA QUE RESTAURAR
            -- =================================================

            if #mapblocks == 0 then

                reset_in_progress = false

                return

            end


            -- =================================================
            -- COMENZAR RESET
            -- =================================================

            reset_mapblocks_batch(
                mapblocks,
                1
            )

        end
    )


    return ctx

end


return M
