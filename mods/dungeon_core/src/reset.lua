-- =========================================================
-- MÓDULO: dungeon_core / reset
-- Al morir el jugador, restaura únicamente los dos cofres originales.
-- El resto de la mazmorra permanece sin cambios.
-- =========================================================

local M = {}

function M.setup(ctx)

    local reset_in_progress = false

    -- Cofres originales almacenados en dungeon1.zip. 
    -- metadata_file y metadata_key identifican la entrada de metadatos original exacta, lo que incluye el inventario original y los metadatos de los objetos.
    local chests_to_restore = {
        {
            pos = {x = 109, y = 201, z = 134},
            metadata_file = "mapblock_(12,25,23).meta.json",
            metadata_key = "(13,9,6)",
        },
        {
            pos = {x = 0, y = -76, z = -52},
            metadata_file = "mapblock_(6,8,11).meta.json",
            metadata_key = "(0,4,12)",
        },
        {
            pos = {x = 145, y = 201, z = 101},
            metadata_file = "mapblock_(15,25,21).meta.json",
            metadata_key = "(1,9,5)",
        },
    }

    local function read_original_chest_metadata(chest)
        if chest.original_metadata then
            return chest.original_metadata
        end

        if not ctx.dungeon_zip then
            minetest.log(
                "error",
                "[dungeon_core] Cannot restore chest: dungeon ZIP is unavailable."
            )
            return nil
        end

        local raw_data = ctx.dungeon_zip:get(chest.metadata_file)
        if not raw_data then
            minetest.log(
                "error",
                "[dungeon_core] Missing chest metadata file: "
                .. chest.metadata_file
            )
            return nil
        end

        local file_data = minetest.parse_json(raw_data)
        local metadata_entry = file_data
            and file_data.metadata
            and file_data.metadata.meta
            and file_data.metadata.meta[chest.metadata_key]

        if not metadata_entry then
            minetest.log(
                "error",
                "[dungeon_core] Original chest metadata not found at local position "
                .. chest.metadata_key
                .. " in "
                .. chest.metadata_file
            )
            return nil
        end

        chest.original_metadata = metadata_entry
        return metadata_entry
    end

    local function restore_chest(chest, callback)
        -- Asegúrate de que el bloque de mapa esté cargado antes de acceder al nodo.
        minetest.emerge_area(
            chest.pos,
            chest.pos,
            function(blockpos, action, calls_remaining)
                if calls_remaining ~= 0 then
                    return
                end

                local success = false

                if action == minetest.EMERGE_CANCELLED
                    or action == minetest.EMERGE_ERRORED
                then
                    minetest.log(
                        "warning",
                        "[dungeon_core] Could not load the mapblock for chest at "
                        .. minetest.pos_to_string(chest.pos)
                    )
                else
                    local node = minetest.get_node_or_nil(chest.pos)

                    if not node or node.name == "ignore" then
                        minetest.log(
                            "warning",
                            "[dungeon_core] Chest position is not loaded: "
                            .. minetest.pos_to_string(chest.pos)
                        )
                    elseif node.name ~= "default:chest" then
                        minetest.log(
                            "warning",
                            "[dungeon_core] Expected default:chest at "
                            .. minetest.pos_to_string(chest.pos)
                            .. ", found "
                            .. node.name
                        )
                    else
                        local original_metadata =
                            read_original_chest_metadata(chest)

                        if original_metadata then
                            minetest.get_meta(chest.pos):from_table(
                                original_metadata
                            )
                            success = true

                            minetest.log(
                                "action",
                                "[dungeon_core] Restored chest at "
                                .. minetest.pos_to_string(chest.pos)
                            )
                        end
                    end
                end

                callback(success)
            end
        )
    end

    minetest.register_on_dieplayer(
        function(player, reason)
            local player_name = player:get_player_name()

            -- Mantener el comportamiento actual del juego: el inventario del jugador se vacía al morir.
            local inventory = player:get_inventory()
            for listname, _ in pairs(inventory:get_lists()) do
                inventory:set_list(listname, {})
            end

            if reset_in_progress then
                minetest.log(
                    "warning",
                    "[dungeon_core] Chest reset is already in progress."
                )
                return
            end

            reset_in_progress = true

            minetest.log(
                "action",
                "[dungeon_core] " .. player_name .. " has died."
            )
            minetest.log(
                "action",
                "[dungeon_core] Restoring the designated chests; leaving the rest of the dungeon unchanged."
            )

            local remaining = #chests_to_restore
            local restored_count = 0

            local function on_chest_finished(success)
                if success then
                    restored_count = restored_count + 1
                end

                remaining = remaining - 1

                if remaining <= 0 then
                    reset_in_progress = false
                    minetest.log(
                        "action",
                        "[dungeon_core] Chest reset complete: restored "
                        .. restored_count
                        .. " of "
                        .. #chests_to_restore
                        .. " chests."
                    )
                end
            end

            for _, chest in ipairs(chests_to_restore) do
                restore_chest(chest, on_chest_finished)
            end
        end
    )

    return ctx
end

return M
