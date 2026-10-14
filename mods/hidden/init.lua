hidden = {}

function hidden.register_all(material, precursor, name, tile_n)
   hidden.register_ladder(material, precursor, name, tile_n)
   hidden.register_trap(material, precursor, name, tile_n)
end

function hidden.register_ladder(material, precursor, name, tile_n)

   local node_def = minetest.registered_nodes[precursor]

   if node_def then
      minetest.register_node("hidden:" .. material .. "_ladder", {
        climbable = true,
        description = name .. " Hidden Ladder",
        drawtype = "glasslike",
        groups = {cracky = 2},
        is_ground_content = false,
        walkable = false,

        inventory_image = node_def.tiles[tile_n] .. "^hidden_ladder_frame.png",
        tiles = {node_def.tiles[tile_n]},

        paramtype = node_def.paramtype,
        sounds = node_def.sounds,
        sunlight_propagates = node_def.sunlight_propagates,
      })
   end

   minetest.register_craft({
         output = "hidden:" .. material .. "_ladder" .. " 1",
         recipe = {
            {"", "", ""},
            {"default:obsidian_glass", "default:mese_crystal_fragment", precursor},
            {"", "", ""}
         }
   })
end

function hidden.register_trap(material, precursor, name, tile_n)

   local node_def = minetest.registered_nodes[precursor]

   if node_def then
      minetest.register_node("hidden:" .. material .. "_trap", {
        climbable = false,
        description = name .. " Hidden Trap",
        drawtype = "glasslike",
        groups = {cracky = 2},
        is_ground_content = false,
        walkable = false,

        inventory_image = node_def.tiles[tile_n] .. "^hidden_trap_frame.png",
        tiles = {node_def.tiles[tile_n]},

        paramtype = node_def.paramtype,
        sounds = node_def.sounds,
        sunlight_propagates = node_def.sunlight_propagates,
      })
   end

   minetest.register_craft({
         output = "hidden:" .. material .. "_trap" .. " 1",
         recipe = {
            {"", "", ""},
            {"default:glass", "default:mese_crystal_fragment", precursor},
            {"", "", ""}
         }
   })
end

hidden.register_all("obsidian", "default:obsidian", "Obsidian", 1)
hidden.register_all("stone", "default:stone", "Stone", 1)
hidden.register_all("desert_stonebrick", "default:desert_stonebrick", "Desert Stone Brick", 1)
hidden.register_all("stonebrick", "default:stonebrick", "Stone Brick", 1)
hidden.register_all("tree", "default:tree", "Tree", 3)
hidden.register_all("dirt", "default:dirt", "Dirt", 1)
hidden.register_all("desert_stone", "default:desert_stone", "Desert Stone", 1)
hidden.register_all("brick", "default:brick", "Brick", 1)
hidden.register_all("wood", "default:wood", "Wood", 1)
hidden.register_all("cobblestone", "default:cobble", "Cobblestone", 1)
hidden.register_all("glass", "default:glass", "Glass", 1)
hidden.register_all("bookshelf", "default:bookshelf", "Bookshelf", 6)
