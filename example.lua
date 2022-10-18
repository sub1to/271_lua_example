local parachuter_thread = 0
local para_test_thread = function(feat)
	local model = 0xc79f6928
	local parachute = 0xfbab5776
	
	streaming.request_model(model)
	
	while not streaming.has_model_loaded(model) do
		system.yield(0)
	end
	
	local pos = player.get_player_coords(player.player_id())
	local offset = v3()
	offset.z = 100
	local cunt = ped.create_ped(5, model, pos + offset, 0, true, false)
	
	entity.set_entity_as_mission_entity(cunt, true, false)
	weapon.give_delayed_weapon_to_ped(cunt, parachute, 1, 0)
	system.yield(0)
	ai.task_parachute_to_target(cunt, pos)
	
	streaming.set_model_as_no_longer_needed(model)
end

local g_checkpoints = {}

-- Any				create_checkpoint(Any type, v3 thisPos, v3 nextPos, float radius, int red, int green, int blue, int alpha, int reserved)
local add_checkpoint = function(t, pos1, pos2, radius, r, g, b, a, x)
	local checkpoint_id	= graphics.create_checkpoint(t, pos1, pos2, radius, r, g, b, a, x)
	local blip_id		= ui.add_blip_for_coord(pos1)
	
	ui.set_blip_sprite(blip_id, 8)
	ui.set_blip_colour(blip_id, 0x00FF00FF)
	ui.set_blip_route(blip_id, true)
	ui.set_blip_route_color(blip_id, 0x00FF00FF)
	
	g_checkpoints[checkpoint_id] =  {checkpoint = checkpoint_id, blip = blip_id}
	
	return checkpoint_id
end

local remove_checkpoint = function(id)
	if g_checkpoints[id] == nil then
		return false
	end
	
	local	obj	= g_checkpoints[id];

	graphics.delete_checkpoint(obj.checkpoint)
	ui.remove_blip(obj.blip)
	
	g_checkpoints[id]	= nil
	
	return true
end

local cleanup_checkpoints = function()
	if(next(g_checkpoints) ~= nil) then
		menu.notify("Cleaning up leftover checkpoints", "Cleanup")
		for k,v in pairs(g_checkpoints) do
			remove_checkpoint(k)
		end
	end
end

local checkpoint_test = function(feat)
	local player_id = player.player_id()
	local player_ped = player.get_player_ped(player_id)
	local pos = player.get_player_coords(player_id)
	local rot = entity.get_entity_rotation(player_ped)
	local dir = rot
	
	dir:transformRotToDir()
	dir = dir * 4
	pos = pos + dir
	
	local b, z = gameplay.get_ground_z(pos)
	
	if b then
		pos.z = z
	end
	
	local checkpoint_id = add_checkpoint(47, pos, v3(), 1, 255, 0, 0, 255, 0)
	
	graphics.set_checkpoint_cylinder_height(checkpoint_id, 1, 2, 100)
	
	menu.create_thread(function(context)
		while true do
			local pos = v2() + player.get_player_coords(player.player_id())
			if pos:magnitude(v2() + context.pos) < 1 then
				menu.notify("deleting checkpoint", "")
				remove_checkpoint(context.checkpoint_id)
				break
			end
			
			system.yield(0)
		end
	end, { pos = pos, checkpoint_id = checkpoint_id })
end

local checkpoint_test_2 = function(feat)
	local player_id = player.player_id()
	local player_ped = player.get_player_ped(player_id)
	local pos = player.get_player_coords(player_id)
	local rot = entity.get_entity_rotation(player_ped)
	local dir = rot
	
	dir:transformRotToDir()
	dir = dir * 4
	pos = pos + dir
	
	local b, z = gameplay.get_ground_z(pos)
	
	if b then
		pos.z = z
	end
	
	local checkpoint_id = add_checkpoint(47, pos, v3(), 1, 255, 0, 0, 255, 0)

	graphics.set_checkpoint_cylinder_height(checkpoint_id, 1, 2, 100)
	
	while true do
		local player_pos = v2() + player.get_player_coords(player.player_id())
		if player_pos:magnitude(v2() + pos) < 1 then
			menu.notify("deleting checkpoint", "")
			remove_checkpoint(checkpoint_id)
			break
		end
		
		system.yield(0)
	end
end

local weapon_impact_test = function(feat)
	local s, p;
	
	s,p = ped.get_ped_last_weapon_impact(player.get_player_ped(player.player_id()));
	
	if s then
		menu.notify(string.format("%f %f %f", p.x, p.y, p.z), "weapon impact")
	end
	
	if feat.on then
		return HANDLER_CONTINUE
	end
end

local marker_test = function(feat)
	local offset = v3(0, 0, 2)
	while feat.on do
		graphics.draw_marker(0, player.get_player_coords(player.player_id()) + offset, v3(), v3(), v3(1), 255, 0, 0, 255, true, true, 0, true, nil, nil, false)
		system.wait(0)
	end
end

local no_hud = function(feat)
	
	ui.hide_hud_and_radar_this_frame()
	
	if feat.on then
		return HANDLER_CONTINUE
	end
end

local io_test = function(feat)
	--local path = utils.get_appdata_path("PopstarDevs\\2Take1Menu", "iotest.txt")
	local path = "test\\iotest.txt"
	--local path = "test/iotest.txt"
	--local path = "D:/iotest.txt";

	local f = io.open(path, "w")
	
	if f == nil then
		menu.notify("Failed to open file", "IO Test")
		return
	end
	
	f:write("123 123 123\n")
	f:close()
	menu.notify("Success", "IO Test")
	
end

local int_val_test = function(feat)
	menu.notify(string.format("val: %d\nmin: %d\nmax: %d", feat.value, feat.min, feat.max), "Integer Value Test")
end

local float_val_test = function(feat)
	menu.notify(string.format("val: %f\nmin: %f\nmax: %f\nmod: %f", feat.value, feat.min, feat.max, feat.mod), "Float Value Test")
end

local slider_test = function(feat)
	menu.notify(string.format("val: %f\nmin: %f\nmax: %f\nmod: %f", feat.value, feat.min, feat.max, feat.mod), "Slider Test")
end

local str_val_test = function(feat)
	local tab = feat.str_data
	menu.notify(string.format("val: %d\nmin: %d\nmax: %d\nstr: %s", feat.value, feat.min, feat.max, tab[feat.value + 1]), "String Value Test")
	
	feat.str_data = {"first", "second"}
end

local plr_str_val_test = function(feat, p)
	local tab = feat.str_data
	menu.notify(string.format("val: %d\nmin: %d\nmax: %d\nstr: %s", feat.value, feat.min, feat.max, tab[feat.value + 1]), "String Value Test")
end

local vec_test = function(feat)
	local vec1 = v3()
	local vec2 = v3()

	vec1.x = 2
	vec1.y = 1
	vec1.z = 1

	vec2.x = 1
	vec2.y = 1
	vec2.z = 1

	local vec3 = vec1 + vec2
	local vec4 = v2() + vec3
	local vec5 = vec1 + 5.0

	menu.notify(tostring(vec1), "vec1")
	menu.notify(tostring(vec2), "vec2")
	menu.notify(tostring(vec3), "vec3")
	menu.notify(tostring(vec4), "vec4")
	menu.notify(tostring(vec5), "vec5")
	menu.notify(string.format("%f", vec3:magnitude(vec2)), "vec3:magnitude(vec2)")
end

local notify_test = function(feat)
	--#### void			notify(string message, string|nil title, uint32_t|nil seconds, uint32_t|nil color)
	menu.notify("message")
	menu.notify("message + title", "title")
	menu.notify("message + title + 2 seconds", "title", 2)
	menu.notify("message + title + 2 seconds + green", "title", 2, 0xFF00)
	menu.notify("message + nil + 2 seconds + green", nil, 2, 0xFF00)
	menu.notify("message + nil + nil + green", nil, nil, 0xFF00)
	menu.notify("message + nil + nil + nil", nil, nil, nil)
end

local head_blend_test = function(feat)
	--#### [...]|nil			get_ped_head_blend_data(Ped ped)
	
	local blend = ped.get_ped_head_blend_data(player.get_player_ped(player.player_id()))
	
	if blend == nil then
		print("blend is nil")
		return HANDLER_POP
	end
	
	print(string.format(
		"%i %i %i %i %i %i %f %f %f",
		blend.shape_first,
		blend.shape_second,
		blend.shape_third,
		blend.skin_first,
		blend.skin_second,
		blend.skin_third,
		blend.mix_shape,
		blend.mix_skin,
		blend.mix_third
	))
end

local is_mp_model = function(h)
	-- 0x9c9effd8 (-1667301416) => mp_f_freemode_01
	-- 0x705e61f2 (1885233650)  => mp_m_freemode_01
	return h == 0x9c9effd8 or h == 0x705e61f2
end

local steal_face = function(feat, p)
	local playerPed
	local myPed
	local blend
	local overlay = {}

	playerPed	= player.get_player_ped(p)
	myPed		= player.get_player_ped(player.player_id())
	
	if not is_mp_model(entity.get_entity_model_hash(playerPed)) or not is_mp_model(entity.get_entity_model_hash(myPed)) then
		menu.notify("Wrong model")
		return
	end
	
	blend		= ped.get_ped_head_blend_data(playerPed)
	
	if blend == nil then
		menu.notify("No face :(")
		return
	end
	
	ped.set_ped_head_blend_data(
		myPed,
		blend.shape_first,
		blend.shape_second,
		blend.shape_third,
		blend.skin_first,
		blend.skin_second,
		blend.skin_third,
		blend.mix_shape,
		blend.mix_skin,
		blend.mix_third
	)
	
	ped.set_ped_eye_color(myPed, ped.get_ped_eye_color(playerPed))
	ped.set_ped_hair_colors(myPed, ped.get_ped_hair_color(playerPed), ped.get_ped_hair_highlight_color(playerPed))
	
	for i=0,19,1 do
		ped.set_ped_face_feature(
			myPed,
			i,
			ped.get_ped_face_feature(playerPed, i)
		)
	end
	
	for i=0,12,1 do
		ped.set_ped_head_overlay(
			myPed,
			i,
			ped.get_ped_head_overlay_value(playerPed, i) or 0,
			ped.get_ped_head_overlay_opacity(playerPed, i) or 0
		)
		ped.set_ped_head_overlay_color(
			myPed,
			i,
			ped.get_ped_head_overlay_color_type(playerPed, i) or 0,
			ped.get_ped_head_overlay_color(playerPed, i) or 0,
			ped.get_ped_head_overlay_highlight_color(playerPed, i) or 0
		)
	end
	
	menu.notify("enjoy the new face")
end

local tuner_unlocks_raw = function(feat)
	--[[
		else if (iParam0 >= 31707 && iParam0 < 32283)
		{
			iVar26 = STATS::_GET_NGSTAT_BOOL_HASH((iParam0 - 31707), 0, 1, iParam2, "_TUNERPSTAT_BOOL");
			iVar1 = ((iParam0 - 31707) - STATS::_STAT_GET_PACKED_BOOL_MASK((iParam0 - 31707)) * 64);
			iVar0 = STATS::STAT_SET_BOOL_MASKED(iVar26, bParam1, iVar1, iParam3);
		}
	--]]
	
	local h0 = gameplay.get_hash_key("MP0_TUNERPSTAT_BOOL0")
	local h1 = gameplay.get_hash_key("MP0_TUNERPSTAT_BOOL1")
	local h2 = gameplay.get_hash_key("MP0_TUNERPSTAT_BOOL2")
	
	for i=0,63,1 do
		stats.stat_set_masked_bool(h0, true, i, 1, true)
		stats.stat_set_masked_bool(h1, true, i, 1, true)
		stats.stat_set_masked_bool(h2, true, i, 1, true)
	end
	
	menu.notify("Tuner bools unlocked")
end

local tuner_unlocks = function(feat)
	local	hash
	local	mask
	
	for i=0,576,1 do -- 32283 - 31707 = 576
		hash, mask = stats.stat_get_bool_hash_and_mask("_TUNERPSTAT_BOOL", i, 0)
		stats.stat_set_masked_bool(hash, true, mask, 1, true)
	end
	
	menu.notify("Tuner bools unlocked")
	
	--[[
		else if (iParam0 >= 7681 && iParam0 < 9361)
		{
			fVar0 = STATS::_GET_NGSTAT_INT_HASH((iParam0 - 7681), 0, 1, iParam2, "_BIKEPSTAT_INT");
			iVar1 = ((iParam0 - 7681) - STATS::_STAT_GET_PACKED_INT_MASK((iParam0 - 7681)) * 8) * 8;
		}
		
		hash, mask = stats.stat_get_int_hash_and_mask("_BIKEPSTAT_INT", 1, 0)
		hash, mask = stats.stat_get_int_hash_and_mask("_BIKEPSTAT_INT", 65, 0)
		hash, mask = stats.stat_get_int_hash_and_mask("_BIKEPSTAT_INT", 123, 0)
		hash, mask = stats.stat_get_int_hash_and_mask("_BIKEPSTAT_INT", 321, 0)
		hash, mask = stats.stat_get_int_hash_and_mask("_BIKEPSTAT_INT", 512, 0)
		hash, mask = stats.stat_get_int_hash_and_mask("_BIKEPSTAT_INT", 666, 0)
	--]]
	
end

local timecycle_test = function(feat)
	local weather	= gameplay.get_hash_key("EXTRASUNNY")
	
	for region=0,1 do
		for frame=0,12 do
			timecycle.set_timecycle_keyframe_var(weather, region, frame, "sky_sun_col_r", 1.0);
			timecycle.set_timecycle_keyframe_var(weather, region, frame, "sky_sun_col_g", 0.0);
			timecycle.set_timecycle_keyframe_var(weather, region, frame, "sky_sun_col_b", 0.0);

			timecycle.set_timecycle_keyframe_var(weather, region, frame, "sky_sun_disc_col_r", 1.0);
			timecycle.set_timecycle_keyframe_var(weather, region, frame, "sky_sun_disc_col_g", 0.0);
			timecycle.set_timecycle_keyframe_var(weather, region, frame, "sky_sun_disc_col_b", 0.0);

			timecycle.set_timecycle_keyframe_var(weather, region, frame, "sky_sun_disc_size", 20.0);
		end
	end
end

local slider_mod = function(s, e, steps)
	return (e - s) / steps;
end

local function main()
	local f
	
	-- You could do the same thing directly in the feature handler, but this demonstrates how a task can run in it's own (cooperative) thread
	menu.add_feature("parachute yield", "action", 0, function(feat)
		if parachuter_thread ~= 0 then
			if menu.has_thread_finished(parachuter_thread) then
				menu.notify("Parachuter has been spawned", "")
				parachuter_thread = 0
				return HANDLER_POP
			end
		else
			parachuter_thread = menu.create_thread(para_test_thread, feat)
		end
		
		return HANDLER_CONTINUE
	end)
	
	-- Two different ways of handling the same thing
	menu.add_feature("checkpoint", "action", 0, checkpoint_test)
	menu.add_feature("checkpoint 2", "action", 0, checkpoint_test_2)
	-- Onexit cleanup.. Without cleanup existing checkpoints might get "stuck"
	event.add_event_listener("exit", function()
		cleanup_checkpoints()
	end);
	
	
	-- Just some more examples
	menu.add_feature("weapon impact test", "toggle", 0, weapon_impact_test)
	menu.add_feature("marker", "toggle", 0, marker_test)
	menu.add_feature("Hide HUD", "toggle", 0, no_hud)
	menu.add_feature("IO Test", "action", 0, io_test)
	
	-- feat value examples
	f = menu.add_feature("action_value_i test", "action_value_i", 0, int_val_test)
	f.min = 1
	f.max = 10
	f.value = 5
	
	f = menu.add_feature("action_value_f test", "action_value_f", 0, float_val_test)
	f.min = 1.1
	f.max = 10.3
	f.mod = 0.2
	f.value = 2.2
	
	f = menu.add_feature("action_slider test", "action_slider", 0, slider_test)
	f.min = 1.1
	f.max = 10.3
	f.mod = slider_mod(1.1, 10.3, 10)
	f.value = 1.1
	
	f = menu.add_feature("action_value_str test", "action_value_str", 0, str_val_test)
	f.set_str_data(f, {"one", "two"})
	
	f = menu.add_player_feature("PlayerFeat action_value_str", "action_value_str", 0, plr_str_val_test)
	f.str_data = {"one", "two"}
	
	f = menu.add_player_feature("PlayerFeat action_value_i", "action_value_i", 0, nil)
	
	f.max = 10
	f.value = 5
	
	local fuckingerror = function(feat) ("Lol").Fuck() end
	local fuck = function() fuckingerror() end
	local fu = function() fuck() end
	menu.add_feature("Error", "action", 0, fu)
	menu.add_feature("Vector Test", "action", 0, vec_test)
	menu.add_feature("Notify Test", "action", 0, notify_test)
	menu.add_feature("Head Blend", "action", 0, head_blend_test)
	
	menu.add_player_feature("steal face", "action", 0, steal_face)
	
	menu.add_feature("Tuner Unlocks Raw", "action", 0, tuner_unlocks_raw)
	menu.add_feature("Tuner Unlocks", "action", 0, tuner_unlocks)
	
	menu.add_feature("Timecycle Test", "action", 0, timecycle_test)
end

main()
warn("test 123", "asdf")