
-- global and settings

stairs = {
	mod = "redo",
	old_place = core.settings:get_bool("stairs.old_placement")
}

-- cache creative

local creative = core.settings:get_bool("creative_mode")

local function is_creative_enabled_for(name)

	if creative or core.check_player_privs(name, {creative = true}) then
		return true
	end
end

-- process textures

local function set_textures(images, worldaligntex)

	local stair_images = {}

	for i, image in ipairs(images) do

		stair_images[i] = type(image) == "string" and {name = image} or table.copy(image)

		if stair_images[i].backface_culling == nil then
			stair_images[i].backface_culling = true
		end

		if worldaligntex and stair_images[i].align_style == nil then
			stair_images[i].align_style = "world"
		end
	end

	return stair_images
end

-- new placement helper

local function stair_place(itemstack, placer, pointed_thing, stair_node)

	-- if sneak pressed then use param2 in node pointed at when placing
	if placer:is_player() and placer:get_player_control().sneak then

		local name  = placer:get_player_name()
		local pos_a = pointed_thing.above
		local node_a = core.get_node(pos_a)
		local def_a = core.registered_nodes[node_a.name]

		if def_a and def_a.buildable_to and not core.is_protected(pos_a, name) then

			local node_u = core.get_node(pointed_thing.under)

			if core.get_item_group(node_u.name, "stair") > 0
			or core.get_item_group(node_u.name, "slab") > 0 then

				core.set_node(pos_a, {name = stair_node, param2 = node_u.param2})

				if not is_creative_enabled_for(name) then
					itemstack:take_item()
				end

				return itemstack
			end
		end
	end

	core.rotate_and_place(itemstack, placer, pointed_thing,
			is_creative_enabled_for(placer:get_player_name()),
			{invert_wall = placer:get_player_control().sneak})

	return itemstack
end

-- old placement helper

local function rotate_and_place(itemstack, placer, pointed_thing)

	local p0 = pointed_thing.under
	local p1 = pointed_thing.above
	local param2 = 0

	if placer then

		local placer_pos = placer:get_pos()

		if placer_pos then

			local diff = vector.subtract(p1, placer_pos)

			param2 = core.dir_to_facedir(diff)

			-- reverse node direction when placing on side face
			if p0.y == p1.y and math.abs(diff.x) <= 0.5
			and math.abs(diff.z) <= 0.5 and diff.y < 0 then
				param2 = (param2 + 2) % 4
			end
		end

		local fpos = core.pointed_thing_to_face_pos(placer, pointed_thing).y % 1

		if p0.y - 1 == p1.y or (fpos > 0 and fpos < 0.5)
		or (fpos < -0.5 and fpos > -0.999999999) then

			param2 = param2 + 20

			if param2 == 21 then param2 = 23
			elseif param2 == 23 then param2 = 21
			end
		end
	end

	return core.item_place(itemstack, placer, pointed_thing, param2)
end

-- if recipeitem can be used as fuel then stair can too

local function set_burn(recipeitem, stair_name, v)

	local burntime = core.get_craft_result({
			method = "fuel", width = 1, items = {recipeitem} }).time

	if burntime > 0 then

		core.register_craft({
			type = "fuel",
			recipe = stair_name,
			burntime = math.floor(burntime * v)
		})
	end
end

-- Node will be called stairs:stair_<subname>

function stairs.register_stair(
		subname, recipeitem, groups, images, description, snds, wat)

	local stair_images = set_textures(images, wat)
	local new_groups = table.copy(groups)

	new_groups.stair = 1

	local def = core.registered_nodes[recipeitem] or {}

	core.register_node(":stairs:stair_" .. subname, {
		description = description,
		drawtype = "nodebox",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = def.use_texture_alpha,
		light_source = def.light_source,
		sunlight_propagates = def.sunlight_propagates,
		groups = new_groups,
		sounds = snds or def.sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5}
			}
		},

		on_place = function(itemstack, placer, pointed_thing)

			if pointed_thing.type ~= "node" then return itemstack end

			return stairs.old_place and rotate_and_place(itemstack, placer, pointed_thing)
			or stair_place(itemstack, placer, pointed_thing, "stairs:stair_" .. subname)
		end
	})

	set_burn(recipeitem, "stairs:stair_" .. subname, 0.75)

	if not recipeitem then return end -- skip craft recipes if no recipe item

	-- stair recipes
	core.register_craft({
		output = "stairs:stair_" .. subname .. " 8",
		recipe = {
			{recipeitem, "", ""},
			{recipeitem, recipeitem, ""},
			{recipeitem, recipeitem, recipeitem}
		}
	})

	core.register_craft({
		output = "stairs:stair_" .. subname .. " 8",
		recipe = {
			{"", "", recipeitem},
			{"", recipeitem, recipeitem},
			{recipeitem, recipeitem, recipeitem}
		}
	})

	-- stair to original material recipe
	core.register_craft({
		output = recipeitem .. " 3",
		recipe = {
			{"stairs:stair_" .. subname, "stairs:stair_" .. subname},
			{"stairs:stair_" .. subname, "stairs:stair_" .. subname}
		}
	})
end

-- Node will be called stairs:slab_<subname>

function stairs.register_slab(
		subname, recipeitem, groups, images, description, snds, wat)

	local slab_images = set_textures(images, wat)
	local new_groups = table.copy(groups)

	new_groups.slab = 1

	local def = core.registered_nodes[recipeitem] or {}

	core.register_node(":stairs:slab_" .. subname, {
		description = description,
		drawtype = "nodebox",
		tiles = slab_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = def.use_texture_alpha,
		light_source = def.light_source,
		sunlight_propagates = def.sunlight_propagates,
		groups = new_groups,
		sounds = snds or def.sounds,
		node_box = {
			type = "fixed",
			fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5}
		},

		on_place = function(itemstack, placer, pointed_thing)

			if pointed_thing.type ~= "node" then return itemstack end

			return stairs.old_place and rotate_and_place(itemstack, placer, pointed_thing)
			or stair_place(itemstack, placer, pointed_thing, "stairs:slab_" .. subname)
		end
	})

	set_burn(recipeitem, "stairs:slab_" .. subname, 0.5)

	if not recipeitem then return end -- skip craft recipes if no recipe item

	-- slab recipe
	core.register_craft({
		output = "stairs:slab_" .. subname .. " 6",
		recipe = {
			{recipeitem, recipeitem, recipeitem}
		}
	})

	-- slab to original material recipe
	core.register_craft({
		output = recipeitem,
		recipe = {
			{"stairs:slab_" .. subname},
			{"stairs:slab_" .. subname}
		}
	})
end

-- Node will be called stairs:stair_outer_<subname>

function stairs.register_stair_outer(
		subname, recipeitem, groups, images, description, snds, wat, fdesc)

	local stair_images = set_textures(images, wat)
	local new_groups = table.copy(groups)

	new_groups.stair = 1

	local def = core.registered_nodes[recipeitem] or {}

	core.register_node(":stairs:stair_outer_" .. subname, {
		description = fdesc or "Outer " .. description,
		drawtype = "nodebox",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = def.use_texture_alpha,
		light_source = def.light_source,
		sunlight_propagates = def.sunlight_propagates,
		groups = new_groups,
		sounds = snds or def.sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0, 0.5, 0.5}
			},
		},

		on_place = function(itemstack, placer, pointed_thing)

			if pointed_thing.type ~= "node" then return itemstack end

			return stairs.old_place and rotate_and_place(itemstack, placer, pointed_thing)
			or stair_place(itemstack, placer, pointed_thing, "stairs:stair_outer_" .. subname)
		end
	})

	-- add alias for old stairs redo name
	core.register_alias("stairs:corner_" .. subname, "stairs:stair_outer_" .. subname)

	set_burn(recipeitem, "stairs:stair_outer_" .. subname, 0.625)

	if not recipeitem then return end -- skip craft recipes if no recipe item

	-- corner stair recipe
	core.register_craft({
		output = "stairs:stair_outer_" .. subname .. " 6",
		recipe = {
			{"", "", ""},
			{"", recipeitem, ""},
			{recipeitem, recipeitem, recipeitem}
		},
	})

	-- corner stair to original material recipe
	core.register_craft({
		output = recipeitem .. " 2",
		recipe = {
			{"stairs:stair_outer_" .. subname, "stairs:stair_outer_" .. subname},
			{"stairs:stair_outer_" .. subname, "stairs:stair_outer_" .. subname}
		}
	})
end

-- Node will be called stairs:stair_inner_<subname>

function stairs.register_stair_inner(
		subname, recipeitem, groups, images, description, snds, wat, fdesc)

	local stair_images = set_textures(images, wat)
	local new_groups = table.copy(groups)

	new_groups.stair = 1

	local def = core.registered_nodes[recipeitem] or {}

	core.register_node(":stairs:stair_inner_" .. subname, {
		description = fdesc or "Inner " .. description,
		drawtype = "nodebox",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = def.use_texture_alpha,
		light_source = def.light_source,
		sunlight_propagates = def.sunlight_propagates,
		groups = new_groups,
		sounds = snds or def.sounds,
		node_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
				{-0.5, 0, -0.5, 0, 0.5, 0}
			}
		},

		on_place = function(itemstack, placer, pointed_thing)

			if pointed_thing.type ~= "node" then return itemstack end

			return stairs.old_place and rotate_and_place(itemstack, placer, pointed_thing)
			or stair_place(itemstack, placer, pointed_thing, "stairs:stair_inner_" .. subname)
		end,
	})

	-- add alias for old stairs redo name
	core.register_alias("stairs:invcorner_" .. subname, "stairs:stair_inner_" .. subname)

	set_burn(recipeitem, "stairs:stair_inner_" .. subname, 0.875)

	if not recipeitem then return end -- skip craft recipes if no recipe item

	-- inside corner stair recipe
	core.register_craft({
		output = "stairs:stair_inner_" .. subname .. " 9",
		recipe = {
			{recipeitem, recipeitem, ""},
			{recipeitem, recipeitem, recipeitem},
			{recipeitem, recipeitem, recipeitem},
		}
	})

	-- inside corner stair to original material recipe
	core.register_craft({
		output = recipeitem .. " 3",
		recipe = {
			{"stairs:stair_inner_" .. subname, "stairs:stair_inner_" .. subname},
			{"stairs:stair_inner_" .. subname, "stairs:stair_inner_" .. subname}
		}
	})
end

-- Node will be called stairs:slope_<subname>

function stairs.register_slope(
		subname, recipeitem, groups, images, description, snds, wat)

	local stair_images = set_textures(images, wat)
	local new_groups = table.copy(groups)

	new_groups.stair = 1

	local def = core.registered_nodes[recipeitem] or {}

	core.register_node(":stairs:slope_" .. subname, {
		description = description,
		drawtype = "mesh",
		mesh = "stairs_slope.obj",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = def.use_texture_alpha,
		light_source = def.light_source,
		sunlight_propagates = def.sunlight_propagates,
		groups = new_groups,
		sounds = snds or def.sounds,
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
			},
		},
		collision_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5}
			},
		},

		on_place = function(itemstack, placer, pointed_thing)

			if pointed_thing.type ~= "node" then return itemstack end

			return stairs.old_place and rotate_and_place(itemstack, placer, pointed_thing)
			or stair_place(itemstack, placer, pointed_thing, "stairs:slope_" .. subname)
		end
	})

	set_burn(recipeitem, "stairs:slope_" .. subname, 0.5)

	if not recipeitem then return end -- skip craft recipes if no recipe item

	-- slope recipe
	core.register_craft({
		output = "stairs:slope_" .. subname .. " 6",
		recipe = {
			{recipeitem, "", ""},
			{recipeitem, recipeitem, ""}
		}
	})

	-- slope to original material recipe
	core.register_craft({
		output = recipeitem,
		recipe = {
			{"stairs:slope_" .. subname, "stairs:slope_" .. subname}
		}
	})
end

-- Node will be called stairs:slope_inner_<subname>

function stairs.register_slope_inner(
		subname, recipeitem, groups, images, description, snds, wat)

	local stair_images = set_textures(images, wat)
	local new_groups = table.copy(groups)

	new_groups.stair = 1

	local def = core.registered_nodes[recipeitem] or {}

	core.register_node(":stairs:slope_inner_" .. subname, {
		description = description,
		drawtype = "mesh",
		mesh = "stairs_slope_inner.obj",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = def.use_texture_alpha,
		light_source = def.light_source,
		sunlight_propagates = def.sunlight_propagates,
		groups = new_groups,
		sounds = snds or def.sounds,
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
				{-0.5, 0, -0.5, 0, 0.5, 0}
			}
		},
		collision_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0.5, 0.5, 0.5},
				{-0.5, 0, -0.5, 0, 0.5, 0}
			}
		},

		on_place = function(itemstack, placer, pointed_thing)

			if pointed_thing.type ~= "node" then return itemstack end

			return stairs.old_place and rotate_and_place(itemstack, placer, pointed_thing)
			or stair_place(itemstack, placer, pointed_thing, "stairs:slope_inner_" .. subname)
		end
	})

	set_burn(recipeitem, "stairs:slope_inner_" .. subname, 0.5)

	if not recipeitem then return end -- skip craft recipes if no recipe item

	-- slope recipe
	core.register_craft({
		output = "stairs:slope_inner_" .. subname .. " 6",
		recipe = {
			{"", recipeitem, recipeitem},
			{recipeitem, recipeitem, recipeitem}
		}
	})

	-- slope to original material recipe
	core.register_craft({
		output = recipeitem,
		recipe = {
			{"stairs:slope_inner_" .. subname, "stairs:slope_inner_" .. subname}
		}
	})
end

-- Node will be called stairs:slope_outer_<subname>

function stairs.register_slope_outer(
		subname, recipeitem, groups, images, description, snds, wat)

	local stair_images = set_textures(images, wat)
	local new_groups = table.copy(groups)

	new_groups.stair = 1

	local def = core.registered_nodes[recipeitem] or {}

	core.register_node(":stairs:slope_outer_" .. subname, {
		description = description,
		drawtype = "mesh",
		mesh = "stairs_slope_outer.obj",
		tiles = stair_images,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		use_texture_alpha = def.use_texture_alpha,
		light_source = def.light_source,
		sunlight_propagates = def.sunlight_propagates,
		groups = new_groups,
		sounds = snds or def.sounds,
		selection_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0, 0.5, 0.5}
			},
		},
		collision_box = {
			type = "fixed",
			fixed = {
				{-0.5, -0.5, -0.5, 0.5, 0, 0.5},
				{-0.5, 0, 0, 0, 0.5, 0.5}
			},
		},

		on_place = function(itemstack, placer, pointed_thing)

			if pointed_thing.type ~= "node" then return itemstack end

			return stairs.old_place and rotate_and_place(itemstack, placer, pointed_thing)
			or stair_place(itemstack, placer, pointed_thing, "stairs:slope_outer_" .. subname)
		end
	})

	set_burn(recipeitem, "stairs:slope_outer_" .. subname, 0.5)

	if not recipeitem then return end -- skip craft recipes if no recipe item

	-- slope recipe
	core.register_craft({
		output = "stairs:slope_outer_" .. subname .. " 6",
		recipe = {
			{"", "", recipeitem},
			{"", recipeitem, recipeitem}
		}
	})

	-- slope to original material recipe
	core.register_craft({
		output = recipeitem,
		recipe = {
			{"stairs:slope_outer_" .. subname, "stairs:slope_outer_" .. subname}
		}
	})
end

-- Nodes will be called stairs:{stair,slab}_<subname>

function stairs.register_stair_and_slab(
		subname, recipeitem, groups, images, desc_stair, desc_slab, sounds, wat)

	stairs.register_stair(
			subname, recipeitem, groups, images, desc_stair, sounds, wat)

	stairs.register_stair_inner(
			subname, recipeitem, groups, images, desc_stair, sounds, wat)

	stairs.register_stair_outer(
			subname, recipeitem, groups, images, desc_stair, sounds, wat)

	stairs.register_slab(
			subname, recipeitem, groups, images, desc_slab, sounds, wat)
end

-- Nodes will be called stairs:{stair,slab,slope}_<subname>

function stairs.register_all(
		subname, recipeitem, groups, images, desc, snds, wat)

	stairs.register_stair(
			subname, recipeitem, groups, images, desc .. " Stair", snds, wat)

	stairs.register_slab(
			subname, recipeitem, groups, images, desc .. " Slab", snds, wat)

	stairs.register_stair_inner(
			subname, recipeitem, groups, images, desc .. " Stair", snds, wat)

	stairs.register_stair_outer(
			subname, recipeitem, groups, images, desc .. " Stair", snds, wat)

	stairs.register_slope(
			subname, recipeitem, groups, images, desc .. " Slope", snds, wat)

	stairs.register_slope_inner(
			subname, recipeitem, groups, images, desc .. " Slope", snds, wat)

	stairs.register_slope_outer(
			subname, recipeitem, groups, images, desc .. " Slope", snds, wat)
end

-- compatibility function for previous stairs:invcorner_<subname>

function stairs.register_invcorner(subname, recipeitem, groups, images, desc, snds, wat)

	stairs.register_stair_inner(
			subname, recipeitem, groups, images, desc .. " Stair", snds, wat)
end

-- compatibility function for previous stairs:corner_<subname>

function stairs.register_corner(subname, recipeitem, groups, images, desc, snds, wat)

	stairs.register_stair_outer(
			subname, recipeitem, groups, images, desc .. " Stair", snds, wat)
end

-- Register stairs after mods loaded

core.register_on_mods_loaded(function()
	dofile(core.get_modpath("stairs") .. "/stairs.lua")
end)

print ("[MOD] Stairs Redo loaded")
