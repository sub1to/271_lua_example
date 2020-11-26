parachuter_thread = 0
para_test_thread = function(feat)
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

g_checkpoints = {}

-- Any				create_checkpoint(Any type, v3 thisPos, v3 nextPos, float radius, int red, int green, int blue, int alpha, int reserved)
add_checkpoint = function(t, pos1, pos2, radius, r, g, b, a, x)
	local checkpoint_id = graphics.create_checkpoint(t, pos1, pos2, radius, r, g, b, a, x)
	
	table.insert(g_checkpoints, checkpoint_id)
	
	return checkpoint_id
end

remove_checkpoint = function(id)
	graphics.delete_checkpoint(id)
	for k,v in pairs(g_checkpoints) do
		if(v == checkpoint_id) then
			g_checkpoints[k] = nil
		end
	end
end

cleanup_checkpoints = function()
	if(next(g_checkpoints) ~= nil) then
		ui.notify_above_map("Cleaning up leftover checkpoints", "Cleanup", 140)
		for k,v in pairs(g_checkpoints) do
			graphics.delete_checkpoint(v)
			g_checkpoints[k] = nil
		end
	end
end

checkpoint_test = function(feat)
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
				ui.notify_above_map("deleting checkpoint", "", 140)
				remove_checkpoint(context.checkpoint_id)
				break
			end
			
			system.yield(0)
		end
	end, { pos = pos, checkpoint_id = checkpoint_id })
end

checkpoint_test_2 = function(feat)
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
			ui.notify_above_map("deleting checkpoint", "", 140)
			remove_checkpoint(checkpoint_id)
			break
		end
		
		system.yield(0)
	end
end

weapon_impact_test = function(feat)
	local s, p;
	
	s,p = ped.get_ped_last_weapon_impact(player.get_player_ped(player.player_id()));
	
	if s then
		ui.notify_above_map(string.format("%f %f %f", p.x, p.y, p.z), "weapon impact", 140)
	end
	
	if feat.on then
		return HANDLER_CONTINUE
	end
end

marker_test = function(feat)
	local offset = v3(0, 0, 2)
	graphics.draw_marker(0, player.get_player_coords(player.player_id()) + offset, v3(), v3(), v3(1), 255, 0, 0, 255, true, true, 0, true, nil, nil, false)
	if feat.on then
		return HANDLER_CONTINUE
	end
end

no_hud = function(feat)
	
	ui.hide_hud_and_radar_this_frame()
	
	if feat.on then
		return HANDLER_CONTINUE
	end
end

function main()
	
	-- You could do the same thing directly in the feature handler, but this demonstrates how a task can run in it's own (cooperative) thread
	menu.add_feature("parachute yield", "action", 0, function(feat)
		if parachuter_thread ~= 0 then
			if menu.has_thread_finished(parachuter_thread) then
				ui.notify_above_map("Parachuter has been spawned", "", 140)
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
end

main()