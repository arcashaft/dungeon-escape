-- =========================================================
-- MODULO: dungeon_core / map
-- Gestiona la carga del Dungeon desde dungeon1.zip.
-- =========================================================

local M = {}


function M.setup(config)

    local ctx = {}


    -- =====================================================
    -- CONFIGURACIÓN
    -- =====================================================

    ctx.dungeon_map_min =
        config.dungeon_map_min

    ctx.dungeon_map_file =
        config.dungeon_map_file


    -- =====================================================
    -- ESTADO DEL DUNGEON
    -- =====================================================

    ctx.dungeon_file = nil
    ctx.dungeon_zip = nil
    ctx.dungeon_manifest = nil
    ctx.dungeon_map_max = nil

    -- Mapblocks generados durante la partida actual.
    ctx.generated_mapblocks = {}


    -- =====================================================
    -- ABRIR DUNGEON1.ZIP
    -- =====================================================

    ctx.dungeon_file =
        io.open(
            ctx.dungeon_map_file,
            "rb"
        )


    if not ctx.dungeon_file then

        error(
            "[dungeon_core] Cannot open map: "
            .. ctx.dungeon_map_file
        )

    end


    -- Mantener el archivo abierto mientras utilizamos
    -- ctx.dungeon_zip.

    local zip, err =
        mtzip.unzip(
            ctx.dungeon_file
        )


    if not zip then

        ctx.dungeon_file:close()
        ctx.dungeon_file = nil

        error(
            "[dungeon_core] Cannot open dungeon1.zip: "
            .. tostring(err)
        )

    end


    ctx.dungeon_zip = zip


    -- =====================================================
    -- LEER MANIFEST.JSON
    -- =====================================================

    local manifest_data =
        ctx.dungeon_zip:get(
            "manifest.json"
        )


    if not manifest_data then

        ctx.dungeon_file:close()

        ctx.dungeon_file = nil
        ctx.dungeon_zip = nil

        error(
            "[dungeon_core] dungeon1.zip does not contains "
            .. "manifest.json"
        )

    end


    ctx.dungeon_manifest =
        minetest.parse_json(
            manifest_data
        )


    if not ctx.dungeon_manifest then

        ctx.dungeon_file:close()

        ctx.dungeon_file = nil
        ctx.dungeon_zip = nil

        error(
            "[dungeon_core] manifest.json is an invalid JSON"
        )

    end


    -- =====================================================
    -- COMPROBAR RANGE
    -- =====================================================

    if not ctx.dungeon_manifest.range
        or ctx.dungeon_manifest.range.x == nil
        or ctx.dungeon_manifest.range.y == nil
        or ctx.dungeon_manifest.range.z == nil
    then

        ctx.dungeon_file:close()

        ctx.dungeon_file = nil
        ctx.dungeon_zip = nil

        error(
            "[dungeon_core] manifest.json does not contains "
            .. "a valid 'range'"
        )

    end


    -- =====================================================
    -- LÍMITES DE LOS MAPBLOCKS
    -- =====================================================

    ctx.dungeon_map_max = {
        x = ctx.dungeon_map_min.x
            + ctx.dungeon_manifest.range.x,

        y = ctx.dungeon_map_min.y
            + ctx.dungeon_manifest.range.y,

        z = ctx.dungeon_map_min.z
            + ctx.dungeon_manifest.range.z
    }


    minetest.log(
        "action",

        "[dungeon_core] Dungeon 1 loaded. "
        .. "Mapblocks: "
        .. minetest.pos_to_string(
            ctx.dungeon_map_min
        )
        .. " -> "
        .. minetest.pos_to_string(
            ctx.dungeon_map_max
        )
    )


    -- =====================================================
    -- CONFIGURACIÓN DEL MAPGEN
    -- =====================================================

    -- Mundo vacío: Dungeon Escape utiliza exclusivamente
    -- el mapa guardado en dungeon1.zip.

    minetest.set_mapgen_setting(
        "mg_name",
        "singlenode",
        true
    )


    -- =====================================================
    -- CARGAR UN MAPBLOCK DEL ZIP
    -- =====================================================

    local function load_dungeon_mapblock(
        world_mapblock
    )

        -- =================================================
        -- REGISTRAR MAPBLOCK
        -- =================================================

        local key =
            minetest.pos_to_string(
                world_mapblock
            )


        ctx.generated_mapblocks[key] = {
            x = world_mapblock.x,
            y = world_mapblock.y,
            z = world_mapblock.z
        }


        -- =================================================
        -- COORDENADAS RELATIVAS DEL ZIP
        -- =================================================

        local relative_mapblock = {
            x = world_mapblock.x
                - ctx.dungeon_map_min.x,

            y = world_mapblock.y
                - ctx.dungeon_map_min.y,

            z = world_mapblock.z
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
        -- METADATA DEL MAPBLOCK
        -- =================================================

        local manifest_data =
            ctx.dungeon_zip:get(
                meta_name
            )


        -- Mapblock completamente vacío.

        if not manifest_data then
            return true
        end


        -- =================================================
        -- DATOS BINARIOS
        -- =================================================

        local mapblock_data =
            ctx.dungeon_zip:get(
                bin_name
            )


        if not mapblock_data then

            minetest.log(
                "error",

                "[dungeon_core] Missing "
                .. bin_name
                .. " in dungeon1.zip"
            )

            return false

        end


        -- =================================================
        -- PARSEAR MANIFEST DEL MAPBLOCK
        -- =================================================

        local manifest =
            minetest.parse_json(
                manifest_data
            )


        if not manifest then

            minetest.log(
                "error",

                "[dungeon_core] Invalid JSON in "
                .. meta_name
            )

            return false

        end


        -- =================================================
        -- LEER MAPBLOCK
        -- =================================================

        local mapblock =
            mapblock_lib.read_mapblock(
                mapblock_data
            )


        if not mapblock then

            minetest.log(
                "error",

                "[dungeon_core] Cannot read "
                .. bin_name
            )

            return false

        end


        -- =================================================
        -- DESERIALIZAR
        -- =================================================

        local ok, err =
            mapblock_lib.deserialize_mapblock(
                world_mapblock,
                mapblock,
                manifest,
                {
                    mode = "replace"
                }
            )


        if not ok then

            minetest.log(
                "error",

                "[dungeon_core] Error loading "
                .. minetest.pos_to_string(
                    world_mapblock
                )
                .. ": "
                .. tostring(err)
            )

            return false

        end

        if ctx.restore_signs_in_mapblock then
            ctx.restore_signs_in_mapblock(
                world_mapblock
            )
        end

        return true

    end


    -- =====================================================
    -- CALLBACK: GENERACIÓN DEL MAPA
    -- =====================================================

    minetest.register_on_generated(
        function(minp, maxp)

            if not ctx.dungeon_zip then
                return
            end


            local min_mapblock =
                mapblock_lib.get_mapblock(
                    minp
                )


            local max_mapblock =
                mapblock_lib.get_mapblock(
                    maxp
                )


            for x = min_mapblock.x,
                max_mapblock.x do

                for y = min_mapblock.y,
                    max_mapblock.y do

                    for z = min_mapblock.z,
                        max_mapblock.z do

                        local world_mapblock = {
                            x = x,
                            y = y,
                            z = z
                        }


                        if
                            x >= ctx.dungeon_map_min.x
                            and x <= ctx.dungeon_map_max.x

                            and y >= ctx.dungeon_map_min.y
                            and y <= ctx.dungeon_map_max.y

                            and z >= ctx.dungeon_map_min.z
                            and z <= ctx.dungeon_map_max.z
                        then

                            load_dungeon_mapblock(
                                world_mapblock
                            )

                        end

                    end

                end

            end

        end
    )


    -- =====================================================
    -- CERRAR ZIP AL APAGAR
    -- =====================================================

    minetest.register_on_shutdown(
        function()

            if ctx.dungeon_file then

                ctx.dungeon_file:close()

                ctx.dungeon_file = nil
                ctx.dungeon_zip = nil

                minetest.log(
                    "action",
                    "[dungeon_core] dungeon1.zip closed."
                )

            end

        end
    )


    return ctx

end


return M
