-- =========================================================
-- MOD: chat_blocker (Filtro de mensajes de sistema y mods)
-- =========================================================

-- 1. Guardamos una copia de las funciones originales del motor de Luanti
local original_chat_send_player = minetest.chat_send_player
local original_chat_send_all = minetest.chat_send_all

-- 2. Interceptamos los mensajes privados/dirigidos a un jugador
minetest.chat_send_player = function(name, message)
    
    -- Filtramos palabras clave que suelta WorldEdit o tus scripts
    -- (Puedes añadir más usando "or message:find('otra palabra')")
    if message:find("WorldEdit") or message:find("bloques colocados") or message:find("fixlight") then
        -- Al hacer 'return' sin llamar a la original, el mensaje se descarta y NUNCA aparece en el chat
        return
    end
    
    -- Si el mensaje es normal, dejamos que continúe hacia la pantalla del jugador
    return original_chat_send_player(name, message)
end

-- 3. Interceptamos los mensajes globales (para todos los jugadores)
minetest.chat_send_all = function(message)
    if message:find("WorldEdit") or message:find("bloques colocados") then
        return -- Bloqueado
    end
    return original_chat_send_all(message)
end
