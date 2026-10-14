minetest.register_on_mods_loaded(function()
    for nombre_nodo, _ in pairs(minetest.registered_nodes) do
        if nombre_nodo:sub(1, 12) == "carpet:wool_" then
            minetest.override_item(nombre_nodo, {
                walkable = false,
            })
        end
    end
end)
