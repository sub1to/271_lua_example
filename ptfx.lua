--[[
#### Ptfx				start_ptfx_looped_on_entity(string name, Entity e, v3 offset, v3 rot, float scale)
#### bool				start_ptfx_non_looped_on_entity(string name, Entity e, v3 offset, v3 rot, float scale)
#### Ptfx				start_networked_ptfx_looped_on_entity(string name, Entity e, v3 offset, v3 rot, float scale)
#### bool				start_networked_ptfx_non_looped_on_entity(string name, Entity e, v3 offset, v3 rot, float scale)

#### Ptfx				start_ptfx_looped_at_coord(string name, v3 pos, v3 rot, float scale, bool xAxis, bool yAxis, bool zAxis, bool a8)
#### bool				start_ptfx_non_looped_at_coord(string name, v3 pos, v3 rot, float scale, bool xAxis, bool yAxis, bool zAxis)
#### bool				start_networked_ptfx_non_looped_at_coord(string name, v3 pos, v3 rot, float scale, bool xAxis, bool yAxis, bool zAxis)
#### Ptfx				start_networked_ptfx_looped_at_coord(string name, v3 pos, v3 rot, float scale, bool xAxis, bool yAxis, bool zAxis)
--]]

local ptfx_asset = "scr_rcbarry1"
local ptfx_name = "scr_alien_teleport"

menu.add_feature("start_ptfx_looped_on_entity", "toggle", 0, function(feat)
	local ptfx
	
	graphics.request_named_ptfx_asset(ptfx_asset)
	
	while not graphics.has_named_ptfx_asset_loaded(ptfx_asset) do
		system.yield(0)
	end
	
	graphics.set_next_ptfx_asset(ptfx_asset)
	ptfx = graphics.start_ptfx_looped_on_entity(ptfx_name, player.get_player_ped(player.player_id()), v3(), v3(), 1)
	
	while feat.on do
		system.yield(0)
	end
	
	graphics.remove_particle_fx(ptfx, false)
	graphics.remove_named_ptfx_asset(ptfx_asset)
	ui.notify_above_map("done", "start_ptfx_looped_on_entity", 140)
end)

menu.add_feature("start_ptfx_non_looped_on_entity", "action", 0, function(feat)
	local ptfx
	
	graphics.request_named_ptfx_asset(ptfx_asset)
	
	while not graphics.has_named_ptfx_asset_loaded(ptfx_asset) do
		system.yield(0)
	end
	
	graphics.set_next_ptfx_asset(ptfx_asset)
	graphics.start_ptfx_non_looped_on_entity(ptfx_name, player.get_player_ped(player.player_id()), v3(), v3(), 1)
	graphics.remove_named_ptfx_asset(ptfx_asset)
	ui.notify_above_map("done", "start_ptfx_non_looped_on_entity", 140)
end)


menu.add_feature("start_networked_ptfx_looped_on_entity", "toggle", 0, function(feat)
	local ptfx
	
	graphics.request_named_ptfx_asset(ptfx_asset)
	
	while not graphics.has_named_ptfx_asset_loaded(ptfx_asset) do
		system.yield(0)
	end
	
	graphics.set_next_ptfx_asset(ptfx_asset)
	ptfx = graphics.start_networked_ptfx_looped_on_entity(ptfx_name, player.get_player_ped(player.player_id()), v3(), v3(), 1)
	
	while feat.on do
		system.yield(0)
	end
	
	graphics.remove_particle_fx(ptfx, false)
	graphics.remove_ptfx_from_entity(player.get_player_ped(player.player_id()))
	graphics.remove_named_ptfx_asset(ptfx_asset)
	ui.notify_above_map("done", "start_networked_ptfx_looped_on_entity", 140)
end)

menu.add_feature("start_networked_ptfx_non_looped_on_entity", "action", 0, function(feat)
	local ptfx
	
	graphics.request_named_ptfx_asset(ptfx_asset)
	
	while not graphics.has_named_ptfx_asset_loaded(ptfx_asset) do
		system.yield(0)
	end
	
	graphics.set_next_ptfx_asset(ptfx_asset)
	graphics.start_networked_ptfx_non_looped_on_entity(ptfx_name, player.get_player_ped(player.player_id()), v3(), v3(), 1)
	graphics.remove_named_ptfx_asset(ptfx_asset)
	ui.notify_above_map("done", "start_networked_ptfx_non_looped_on_entity", 140)
end)







menu.add_feature("start_ptfx_looped_at_coord", "toggle", 0, function(feat)
	local ptfx
	
	graphics.request_named_ptfx_asset(ptfx_asset)
	
	while not graphics.has_named_ptfx_asset_loaded(ptfx_asset) do
		system.yield(0)
	end
	
	graphics.set_next_ptfx_asset(ptfx_asset)
	ptfx = graphics.start_ptfx_looped_at_coord(ptfx_name, entity.get_entity_coords(player.get_player_ped(player.player_id())), v3(), 1, false, false, false)
	
	while feat.on do
		system.yield(0)
	end
	
	graphics.remove_particle_fx(ptfx, false)
	graphics.remove_named_ptfx_asset(ptfx_asset)
	ui.notify_above_map("done", "start_ptfx_looped_at_coord", 140)
end)

menu.add_feature("start_ptfx_non_looped_at_coord", "action", 0, function(feat)
	local ptfx
	
	graphics.request_named_ptfx_asset(ptfx_asset)
	
	while not graphics.has_named_ptfx_asset_loaded(ptfx_asset) do
		system.yield(0)
	end
	
	graphics.set_next_ptfx_asset(ptfx_asset)
	graphics.start_ptfx_non_looped_at_coord(ptfx_name, entity.get_entity_coords(player.get_player_ped(player.player_id())), v3(), 1, false, false, false)
	graphics.remove_named_ptfx_asset(ptfx_asset)
	ui.notify_above_map("done", "start_ptfx_non_looped_at_coord", 140)
end)


menu.add_feature("start_networked_ptfx_looped_at_coord", "toggle", 0, function(feat)
	local ptfx
	
	graphics.request_named_ptfx_asset(ptfx_asset)
	
	while not graphics.has_named_ptfx_asset_loaded(ptfx_asset) do
		system.yield(0)
	end
	
	graphics.set_next_ptfx_asset(ptfx_asset)
	ptfx = graphics.start_networked_ptfx_looped_at_coord(ptfx_name, entity.get_entity_coords(player.get_player_ped(player.player_id())), v3(), 1, false, false, false)
	
	while feat.on do
		system.yield(0)
	end
	
	graphics.remove_particle_fx(ptfx, false)
	graphics.remove_named_ptfx_asset(ptfx_asset)
	ui.notify_above_map("done", "start_networked_ptfx_looped_at_coord", 140)
end)

menu.add_feature("start_networked_ptfx_non_looped_at_coord", "action", 0, function(feat)
	local ptfx
	
	graphics.request_named_ptfx_asset(ptfx_asset)
	
	while not graphics.has_named_ptfx_asset_loaded(ptfx_asset) do
		system.yield(0)
	end
	
	graphics.set_next_ptfx_asset(ptfx_asset)
	graphics.start_networked_ptfx_non_looped_at_coord(ptfx_name, entity.get_entity_coords(player.get_player_ped(player.player_id())), v3(), 1, false, false, false)
	graphics.remove_named_ptfx_asset(ptfx_asset)
	ui.notify_above_map("done", "start_networked_ptfx_non_looped_at_coord", 140)
end)