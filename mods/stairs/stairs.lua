
-- Translation support

local S = core.get_translator("stairs")

-- Local functions so we can apply translations

local function my_register_stair_and_slab(subname, recipeitem, groups, images,
		desc_stair, desc_slab, sounds, worldaligntex)

	stairs.register_stair(subname, recipeitem, groups, images, S(desc_stair),
		sounds, worldaligntex)

	stairs.register_stair_inner(subname, recipeitem, groups, images, "",
		sounds, worldaligntex, S("Inner " .. desc_stair))

	stairs.register_stair_outer(subname, recipeitem, groups, images, "",
		sounds, worldaligntex, S("Outer " .. desc_stair))

	stairs.register_slab(subname, recipeitem, groups, images, S(desc_slab),
		sounds, worldaligntex)
end

local function my_register_all(subname, recipeitem, groups, images, desc,
		sounds, worldaligntex)

	my_register_stair_and_slab(subname, recipeitem, groups, images, desc .. " Stair",
		desc .. " Slab", sounds, worldaligntex)

	stairs.register_slope(subname, recipeitem, groups, images, S(desc .. " Slope"),
		sounds, worldaligntex)

	stairs.register_slope_inner(subname, recipeitem, groups, images,
		S("Inner " .. desc .. " Slope"), sounds, worldaligntex)

	stairs.register_slope_outer(subname, recipeitem, groups, images,
		S("Outer " .. desc .. " Slope"), sounds, worldaligntex)
end

--= Default Minetest

if core.get_modpath("default") then

	-- Wood

	my_register_all("wood", "default:wood",
		{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		{"default_wood.png"},
		"Wooden",
		nil, true)

	my_register_all("junglewood", "default:junglewood",
		{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		{"default_junglewood.png"},
		"Jungle Wood",
		nil, true)

	my_register_all("pine_wood", "default:pinewood",
		{choppy = 3, oddly_breakable_by_hand = 2, flammable = 3},
		{"default_pine_wood.png"},
		"Pine Wood",
		nil, true)

	-- Register aliases for new pine node names
	core.register_alias("stairs:stair_pinewood", "stairs:stair_pine_wood")
	core.register_alias("stairs:slab_pinewood", "stairs:slab_pine_wood")

	my_register_all("acacia_wood", "default:acacia_wood",
		{choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
		{"default_acacia_wood.png"},
		"Acacia Wood",
		nil, true)

	my_register_all("aspen_wood", "default:aspen_wood",
		{choppy = 3, oddly_breakable_by_hand = 2, flammable = 3},
		{"default_aspen_wood.png"},
		"Aspen Wood",
		nil, true)

	-- Stone

	my_register_all("stone", "default:stone",
		{cracky = 3},
		{"default_stone.png"},
		"Stone",
		nil, true)

	my_register_all("stonebrick", "default:stonebrick",
		{cracky = 2},
		{"default_stone_brick.png"},
		"Stone Brick",
		nil, true)

	my_register_all("stone_block", "default:stone_block",
		{cracky = 2},
		{"default_stone_block.png"},
		"Stone Block",
		nil, true)

	my_register_all("cobble", "default:cobble",
		{cracky = 3},
		{"default_cobble.png"},
		"Cobble",
		nil, true)

	my_register_all("mossycobble", "default:mossycobble",
		{cracky = 3},
		{"default_mossycobble.png"},
		"Mossy Cobble",
		nil, true)

	my_register_all("desert_stone", "default:desert_stone",
		{cracky = 3},
		{"default_desert_stone.png"},
		"Desert Stone",
		nil, true)

	my_register_all("desert_stonebrick", "default:desert_stonebrick",
		{cracky = 2},
		{"default_desert_stone_brick.png"},
		"Desert Stone Brick",
		nil, false)

	my_register_all("desert_stone_block", "default:desert_stone_block",
		{cracky = 2},
		{"default_desert_stone_block.png"},
		"Desert Stone Block",
		nil, true)

	my_register_all("desert_cobble", "default:desert_cobble",
		{cracky = 3},
		{"default_desert_cobble.png"},
		"Desert Cobble",
		nil, true)

	-- Sandstone

	my_register_all("sandstone", "default:sandstone",
		{crumbly = 1, cracky = 3},
		{"default_sandstone.png"},
		"Sandstone",
		nil, true)

	my_register_all("sandstonebrick", "default:sandstonebrick",
		{cracky = 2},
		{"default_sandstone_brick.png"},
		"Sandstone Brick",
		nil, false)

	my_register_all("sandstone_block", "default:sandstone_block",
		{cracky = 2},
		{"default_sandstone_block.png"},
		"Sandstone Block",
		nil, true)

	my_register_all("desert_sandstone", "default:desert_sandstone",
		{crumbly = 1, cracky = 3},
		{"default_desert_sandstone.png"},
		"Desert Sandstone",
		nil, true)

	my_register_all("desert_sandstone_brick", "default:desert_sandstone_brick",
		{cracky = 2},
		{"default_desert_sandstone_brick.png"},
		"Desert Sandstone Brick",
		nil, false)

	my_register_all("desert_sandstone_block", "default:desert_sandstone_block",
		{cracky = 2},
		{"default_desert_sandstone_block.png"},
		"Desert Sandstone Block",
		nil, true)

	my_register_all("silver_sandstone", "default:silver_sandstone",
		{crumbly = 1, cracky = 3},
		{"default_silver_sandstone.png"},
		"Silver Sandstone",
		nil, true)

	my_register_all("silver_sandstone_brick", "default:silver_sandstone_brick",
		{cracky = 2},
		{"default_silver_sandstone_brick.png"},
		"Silver Sandstone Brick",
		nil, false)

	my_register_all("silver_sandstone_block", "default:silver_sandstone_block",
		{cracky = 2},
		{"default_silver_sandstone_block.png"},
		"Silver Sandstone Block",
		nil, true)

	-- Obsidian

	my_register_all("obsidian", "default:obsidian",
		{cracky = 1, level = 2},
		{"default_obsidian.png"},
		"Obsidian",
		nil, true)

	my_register_all("obsidianbrick", "default:obsidianbrick",
		{cracky = 1, level = 2},
		{"default_obsidian_brick.png"},
		"Obsidian Brick",
		nil, false)

	my_register_all("obsidian_block", "default:obsidian_block",
		{cracky = 1, level = 2},
		{"default_obsidian_block.png"},
		"Obsidian Block",
		nil, true)

	-- Cloud (with overrides)

	stairs.register_stair("cloud", "default:cloud",
		{unbreakable = 1, not_in_creative_inventory = 1},
		{"default_cloud.png"},
		S("Cloud Stair"),
		nil)

	core.override_item("stairs:stair_cloud", {
		on_blast = function() end,
		on_drop = function(itemstack, dropper, pos) end,
		drop = {},
	})

	stairs.register_slab("cloud", "default:cloud",
		{unbreakable = 1, not_in_creative_inventory = 1},
		{"default_cloud.png"},
		S("Cloud Slab"),
		nil)

	core.override_item("stairs:slab_cloud", {
		on_blast = function() end,
		on_drop = function(itemstack, dropper, pos) end,
		drop = {},
	})

	-- Ores

	my_register_all("coal", "default:coalblock",
		{cracky = 3},
		{"default_coal_block.png"},
		"Coal",
		nil, true)

	my_register_all("steelblock", "default:steelblock",
		{cracky = 1, level = 2},
		{"default_steel_block.png"},
		"Steel",
		nil, true)

	my_register_all("copperblock", "default:copperblock",
		{cracky = 1, level = 2},
		{"default_copper_block.png"},
		"Copper",
		nil, true)

	my_register_all("bronzeblock", "default:bronzeblock",
		{cracky = 1, level = 2},
		{"default_bronze_block.png"},
		"Bronze",
		nil, true)

	my_register_all("tinblock", "default:tinblock",
		{cracky = 1, level = 2},
		{"default_tin_block.png"},
		"Tin",
		nil, true)

	my_register_all("mese", "default:mese",
		{cracky = 1, level = 2},
		{"default_mese_block.png"},
		"Mese",
		nil)

	my_register_all("goldblock", "default:goldblock",
		{cracky = 1},
		{"default_gold_block.png"},
		"Gold",
		nil)

	my_register_all("diamondblock", "default:diamondblock",
		{cracky = 1, level = 3},
		{"default_diamond_block.png"},
		"Diamond",
		nil)

	-- Setting to show glass stair sides
	local gsides = core.settings:get_bool("stairs.glass_sides") ~= false

	-- Old glass stairs
--	my_register_all("glass", "default:glass",
--		{cracky = 3, oddly_breakable_by_hand = 3},
--		{"default_glass.png"},
--		"Glass",
--		stairs.glass)

	-- Glass (stairs registered seperately to use special texture)

	local face_tex = "default_glass.png"
	local side_tex = gsides and "stairs_glass_quarter.png" or face_tex

	stairs.register_stair(
		"glass",
		"default:glass",
		{cracky = 3, oddly_breakable_by_hand = 3},
		{side_tex, face_tex, side_tex, side_tex, face_tex, side_tex},
		S("Glass Stair"),
		nil,
		false)

	stairs.register_slab(
		"glass",
		"default:glass",
		{cracky = 3, oddly_breakable_by_hand = 3},
		{face_tex, face_tex, side_tex},
		S("Glass Slab"),
		nil,
		false)

	stairs.register_stair_inner(
		"glass",
		"default:glass",
		{cracky = 3, oddly_breakable_by_hand = 3},
		{side_tex, face_tex, side_tex, face_tex, face_tex, side_tex},
		"",
		nil,
		false,
		S("Inner Glass Stair"))

	stairs.register_stair_outer(
		"glass",
		"default:glass",
		{cracky = 3, oddly_breakable_by_hand = 3},
		{side_tex, face_tex, side_tex, side_tex, side_tex, side_tex},
		"",
		nil,
		false,
		S("Outer Glass Stair"))

	stairs.register_slope(
		"glass",
		"default:glass",
		{cracky = 3, oddly_breakable_by_hand = 3},
		{face_tex},
		S("Glass Slope"),
		nil)

	stairs.register_slope_inner(
		"glass",
		"default:glass",
		{cracky = 3, oddly_breakable_by_hand = 3},
		{face_tex},
		S("Glass Inner Slope"),
		nil)

	stairs.register_slope_outer(
		"glass",
		"default:glass",
		{cracky = 3, oddly_breakable_by_hand = 3},
		{face_tex},
		S("Glass Outer Slope"),
		nil)

	-- Old obsidian glass stairs
--	my_register_all("obsidian_glass", "default:obsidian_glass",
--		{cracky = 2},
--		{"default_obsidian_glass.png"},
--		"Obsidian Glass",
--		stairs.glass)

	-- Obsidian Glass (stairs registered seperately to use special texture)

	face_tex = "default_obsidian_glass.png"
	side_tex = gsides and "stairs_obsidian_glass_quarter.png" or face_tex

	stairs.register_stair(
		"obsidian_glass",
		"default:obsidian_glass",
		{cracky = 2},
		{side_tex, face_tex, side_tex, side_tex, face_tex, side_tex},
		S("Obsidian Glass Stair"),
		nil,
		false)

	stairs.register_slab(
		"obsidian_glass",
		"default:obsidian_glass",
		{cracky = 2},
		{face_tex, face_tex, side_tex},
		S("Obsidian Glass Slab"),
		nil,
		false)

	stairs.register_stair_inner(
		"obsidian_glass",
		"default:obsidian_glass",
		{cracky = 2},
		{side_tex, face_tex, side_tex, face_tex, face_tex, side_tex},
		"",
		nil,
		false,
		S("Inner Obsidian Glass Stair"))

	stairs.register_stair_outer(
		"obsidian_glass",
		"default:obsidian_glass",
		{cracky = 2},
		{side_tex, face_tex, side_tex, side_tex, side_tex, side_tex},
		"",
		nil,
		false,
		S("Outer Obsidian Glass Stair"))

	stairs.register_slope(
		"obsidian_glass",
		"default:obsidian_glass",
		{cracky = 2},
		{face_tex},
		S("Obsidian Glass Slope"),
		nil)

	stairs.register_slope_inner(
		"obsidian_glass",
		"default:obsidian_glass",
		{cracky = 2},
		{face_tex},
		S("Obsidian Glass Inner Slope"),
		nil)

	stairs.register_slope_outer(
		"obsidian_glass",
		"default:obsidian_glass",
		{cracky = 2},
		{face_tex},
		S("Obsidian Glass Outer Slope"),
		nil)

	-- Brick, Snow and Ice

	my_register_all("brick", "default:brick",
		{cracky = 3},
		{"default_brick.png"},
		"Brick",
		nil, false)

	my_register_all("snowblock", "default:snowblock",
		{crumbly = 3, cools_lava = 1, snowy = 1},
		{"default_snow.png"},
		"Snow Block",
		nil, true)

	my_register_all("ice", "default:ice",
		{cracky = 3, cools_lava = 1, slippery = 3},
		{"default_ice.png"},
		"Ice",
		nil, true)
end

-- More Ores mod

if core.get_modpath("moreores") then

	my_register_all("silver_block", "moreores:silver_block",
		{cracky = 1, level = 2},
		{"moreores_silver_block.png"},
		"Silver",
		nil, true)

	my_register_all("mithril_block", "moreores:mithril_block",
		{cracky = 1, level = 2},
		{"moreores_mithril_block.png"},
		"Mithril",
		nil, true)
end

-- Mobs mod

if core.get_modpath("mobs_animal") then

	my_register_all("cheeseblock", "mobs:cheeseblock",
		{crumbly = 3, flammable = 2},
		{"mobs_cheeseblock.png"},
		"Cheese Block",
		nil, true)

	my_register_all("honey_block", "mobs:honey_block",
		{crumbly = 3, flammable = 2},
		{"mobs_honey_block.png"},
		"Honey Block",
		nil, true)
end

-- Homedecor mod

if core.get_modpath("homedecor_roofing") then

	my_register_all("shingles_asphalt", "homedecor:shingles_asphalt",
		{snappy = 3},
		{"homedecor_shingles_asphalt.png"},
		"Asphalt Shingle",
		nil, true)

	my_register_all("shingles_terracotta", "homedecor:shingles_terracotta",
		{snappy = 3},
		{"homedecor_shingles_terracotta.png"},
		"Terracotta Shingle",
		nil, true)

	my_register_all("shingles_wood", "homedecor:shingles_wood",
		{snappy = 3},
		{"homedecor_shingles_wood.png"},
		"Wooden Shingle",
		nil, true)
end

-- Castle mod

if core.get_modpath("castle_masonry") then

	my_register_all("dungeon_stone", "castle:dungeon_stone",
		{cracky = 2},
		{"castle_dungeon_stone.png"},
		"Dungeon",
		nil)

	my_register_all("stonewall", "castle:stonewall",
		{cracky = 2},
		{"castle_stonewall.png"},
		"Castle Wall",
		nil, true)
end

-- Wool mod

if core.get_modpath("wool") then

	local colours = {
		{"black", "Black"},
		{"blue", "Blue"},
		{"brown", "Brown"},
		{"cyan", "Cyan"},
		{"dark_green", "Dark Green"},
		{"dark_grey", "Dark Grey"},
		{"green", "Green"},
		{"grey", "Grey"},
		{"magenta", "Magenta"},
		{"orange", "Orange"},
		{"pink", "Pink"},
		{"red", "Red"},
		{"violet", "Violet"},
		{"white", "White"},
		{"yellow", "Yellow"}
	}

	for i = 1, #colours, 1 do

		my_register_all("wool_" .. colours[i][1], "wool:" .. colours[i][1],
			{snappy = 2, choppy = 2, oddly_breakable_by_hand = 3, flammable = 3},
			{"wool_" .. colours[i][1] .. ".png"},
			colours[i][2] .. " Wool",
			nil) -- nil to use node's own sounds
	end
end
