-- =========================================================
-- MODULO: dungeon_core / combat
-- Gestiona el daño de los monstruos.
-- =========================================================

local M = {}


function M.setup(config)

    local monster_damage_multiplier =
        config.monster_damage_multiplier


    minetest.register_on_player_hpchange(
        function(player, hp_change, reason)

            -- Solo modificamos daño.
            if hp_change >= 0 then
                return hp_change
            end


            -- Solo golpes producidos por entidades.
            if not reason
                or reason.type ~= "punch"
                or not reason.object
            then
                return hp_change
            end


            -- Los golpes de otros jugadores no cuentan
            -- como daño de monstruo.
            if reason.object:is_player() then
                return hp_change
            end


            local damage =
                math.abs(hp_change)
                * monster_damage_multiplier


            damage =
                math.floor(damage + 0.5)


            return -damage

        end,
        true
    )

end


return M
