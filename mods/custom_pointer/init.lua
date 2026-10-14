-- =========================================================
-- MOD: custom_pointer (Luanti 5.17.0)
-- =========================================================

local player_huds = {}
local player_pointer_state = {}

-- 1. TABLA DE NODOS INTERACTIVOS (Palancas, Cofres, Puertas, Botones)
local nodos_interactivos = {
    -- Palancas y Botones (Mesecons)
    ["mesecons_walllever:wall_lever_off"] = true,
    ["mesecons_walllever:wall_lever_on"]  = true,
    ["mesecons_button:button_off"]        = true,
    ["mesecons_button:button_on"]         = true,

    -- Cofres (Default)
    ["default:chest"]              = true,
    ["default:chest_open"]         = true,

    -- Puertas (Doors y Xpanes)
    ["doors:door_wood_a"] = true,
    ["doors:door_wood_b"] = true,
    ["doors:door_steel_a"] = true,
    ["doors:door_steel_b"] = true,
    ["xpanes:door_steel_bar_a"] = true,
    ["xpanes:door_steel_bar_b"] = true,

    -- Carteles (Signs)
    ["signs:paper_poster"]         = true,
}

-- 2. FUNCIÓN DE RAYCASTING (Detecta Nodos Interactivos Y Entidades a <= 2m)
local function es_objetivo_valido(player)
    local eye_height = player:get_properties().eye_height or 1.62
    local pos1 = player:get_pos()
    pos1.y = pos1.y + eye_height
    
    local dir = player:get_look_dir()
    local reach = 2.0 -- Alcance máximo fijado en 2 metros
    local pos2 = vector.add(pos1, vector.multiply(dir, reach))

    -- minetest.raycast(pos1, pos2, objects, liquidity)
    -- Pasamos 'true' en objects para rastrear entidades/mobs
    local ray = minetest.raycast(pos1, pos2, true, false)
    
    for pointed in ray do
        -- A) Si es una ENTIDAD/OBJETO (mob, NPC, jugador, etc.)
        if pointed.type == "object" then
            local ref = pointed.ref
            -- Filtramos para que el rayo no se detecte a sí mismo
            if ref and ref ~= player then
                return true
            end

        -- B) Si es un NODO/BLOQUE
        elseif pointed.type == "node" then
            local node_name = minetest.get_node(pointed.under).name
            
            -- ¿Es un bloque interactivo de nuestra lista?
            if nodos_interactivos[node_name] then
                return true
            else
                -- Si choca con un bloque sólido no interactivo (ej: pared de piedra),
                -- detiene el rayo para no detectar objetos ocultos detrás de muros.
                local def = minetest.registered_nodes[node_name]
                if def and def.walkable ~= false then
                    return false
                end
            end
        end
    end
    return false
end

-- 3. REGISTRO Y CONFIGURACIÓN DEL JUGADOR
minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()

    player:hud_set_flags({ crosshair = false })

    local hud_id = player:hud_add({
        hud_elem_type = "image",
        position      = {x = 0.5, y = 0.5},
        scale         = {x = 1, y = 1},
        text          = "pointer.png",
        alignment     = {x = 0, y = 0},
        offset        = {x = 0, y = 0},
    })

    player_huds[name] = hud_id
    player_pointer_state[name] = "normal"

    player:hud_set_flags({
        crosshair = false,
        minimap = false,       -- Bloquea la apertura del minimapa (tecla F3)
        minimap_radar = false, -- Bloquea el radar del minimapa
    })
end)

minetest.register_on_leaveplayer(function(player)
    local name = player:get_player_name()
    player_huds[name] = nil
    player_pointer_state[name] = nil
end)

-- 4. BUCLE PRINCIPAL DE DETECCIÓN (Globalstep)
local timer = 0
minetest.register_globalstep(function(dtime)
    timer = timer + dtime
    if timer < 0.1 then return end -- 10 evaluaciones por segundo
    timer = 0

    for _, player in ipairs(minetest.get_connected_players()) do
        local name = player:get_player_name()
        local hud_id = player_huds[name]

        if hud_id then
            local interactivo = es_objetivo_valido(player)

            if interactivo and player_pointer_state[name] ~= "hover" then
                player:hud_change(hud_id, "text", "pointer_hover.png")
                player_pointer_state[name] = "hover"

            elseif not interactivo and player_pointer_state[name] ~= "normal" then
                player:hud_change(hud_id, "text", "pointer.png")
                player_pointer_state[name] = "normal"
            end
        end
    end
end)

-- 5. AJUSTE DE ALCANZE
minetest.override_item("", {
    range = 2.0,
})
