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
	graphics.draw_marker(0, player.get_player_coords(player.player_id()) + offset, v3(), v3(), v3(1), 255, 0, 0, 255, true, true, 0, true, nil, nil, false)
	if feat.on then
		return HANDLER_CONTINUE
	end
end

local no_hud = function(feat)
	
	ui.hide_hud_and_radar_this_frame()
	
	if feat.on then
		return HANDLER_CONTINUE
	end
end

local io_test = function(feat)
	local path = utils.get_appdata_path("PopstarDevs\\2Take1Menu", "iotest.txt")
	
	--local f = io.open("D:\\iotest.txt", "w")
	local f = io.open(path, "w")
	
	if f == nil then
		menu.notify("Failed to open file", "IO Test")
		return
	end
	
	f:write("test123\n")
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
	menu.notify(string.format("val: %d\nmin: %d\nmax: %d", feat.value, feat.min, feat.max), "String Value Test")
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
	
	f = menu.add_player_feature("PlayerFeat action_value_str", "action_value_str", 0, nil)
	f:set_str_data({"one", "two"})
	
	f = menu.add_player_feature("PlayerFeat action_value_i", "action_value_i", 0, nil)
	
	f.max = 10
	f.value = 5
	
	menu.add_feature("Error", "action", 0, function(feat) ("Lol").Fuck() end)
	menu.add_feature("Vector Test", "action", 0, vec_test)
	menu.add_feature("Notify Test", "action", 0, notify_test)
	menu.add_feature("Head Blend", "action", 0, head_blend_test)
end

main()
warn("test 123", "asdf")