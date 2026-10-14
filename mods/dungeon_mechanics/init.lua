local timer = 0

local dungeon_mode =
    minetest.settings:get("dungeon_mode")
    or "Normal"

minetest.register_globalstep(function(dtime)
    timer = timer + dtime

    if timer < 4 then
        return
    end

    timer = 0

    for _, player in ipairs(minetest.get_connected_players()) do
        if dungeon_mode == "Hardcore" or dungeon_mode == "Permadeath" then
            return
        end

        local hp = player:get_hp()

        if hp > 0 and hp < 20 then
            player:set_hp(math.min(hp + 1, 20))
        end
    end
end)
