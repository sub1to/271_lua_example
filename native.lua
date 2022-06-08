
if not menu.is_trusted_mode_enabled() then
	menu.notify("trusted mode not enabled", "2Take1LuaExample", 10, 0xFF0000FF)
	return
end

menu.add_feature("native test", "action", 0, function(f)
	-- 0xE8D65CA700C9A693 GET_VEHICLE_MOD_COLOR_1
	local paint = native.ByteBuffer8()
	local color = native.ByteBuffer8()
	local pearl = native.ByteBuffer8()
	native.call(0xE8D65CA700C9A693, player.get_player_vehicle(0), paint, color, pearl);
	menu.notify(string.format("veh colors: %i %i %i", paint:__tointeger(), color:__tointeger(), pearl:__tointeger()))

	-- 0x7B5280EBA9840C72 _GET_LABEL_TEXT
	local translation = native.call(0x7B5280EBA9840C72, "IE_WARE_1")
	menu.notify(string.format("_GET_LABEL_TEST(\"IE_WARE_1\"):\n\"%s\"\n\"%s\"", translation:__tostring(), translation:__tostring(true)))

	-- 0xA0FD21BED61E5C4C NETWORK_HANDLE_FROM_MEMBER_ID
	-- 0xC82630132081BB6F NETWORK_MEMBER_ID_FROM_GAMER_HANDLE
	local nh = native.ByteBuffer128()
	native.call(0xA0FD21BED61E5C4C, "47349957", nh, 13)
	local memberid = native.call(0xC82630132081BB6F, nh)
	assert(memberid:__tostring(true) == "47349957")
	
	local bb1 = native.ByteBuffer8(12345)
	local bb2 = native.ByteBuffer32(12345, 67890, 69.69, 420)
	local bb3 = native.ByteBuffer32()
	bb3:fill(1, 2, 3, 4)
	bb3:set(1, 3)
	bb3:set(2, 2)

	assert(bb1:__tointeger(0) == 12345, "bb1[0] mismatch")
	
	assert(bb2:__tointeger(0) == 12345, "bb2[0] mismatch")
	assert(bb2:__tointeger(1) == 67890, "bb2[1] mismatch")
	-- 69.690002 because of double to float, then float to double conversion
	assert(math.floor(bb2:__tonumber(2) * 100) / 100  == 69.69, "bb2[2] mismatch")
	assert(bb2:__tointeger(3) == 420, "bb2[3] mismatch")
	
	assert(bb3:__tointeger(0) == 1, "bb3[0] mismatch")
	assert(bb3:__tointeger(1) == 3, "bb3[1] mismatch")
	assert(bb3:__tointeger(2) == 2, "bb3[2] mismatch")
	assert(bb3:__tointeger(3) == 4, "bb3[3] mismatch")
	
	menu.notify("all tests done")

end)

menu.add_feature("native test - out of range set", "action", 0, function(f)
	local bb = native.ByteBuffer8()
	bb:set(1, 0)
end)

menu.add_feature("native test - out of range construct", "action", 0, function(f)
	native.ByteBuffer32(1, 2, 3, 4, 5)
end)

menu.add_feature("native test - out of range fill", "action", 0, function(f)
	local bb = native.ByteBuffer16()
	bb:fill(1, 2, 3)
end)

menu.add_feature("native tp test", "action", 0, function(f)
	-- 0x43A66C31C68491C0 GET_PLAYER_PED
	-- 0x3FEF770D40960D5A GET_ENTITY_COORDS
	-- 0x239A3351AC1DA385 SET_ENTITY_COORDS_NO_OFFSET
	local playerPed 	= native.call(0x43A66C31C68491C0, 0):__tointeger()
	local playerCoord	= native.call(0x3FEF770D40960D5A, playerPed):__tov3()

	native.call(0x239A3351AC1DA385, playerPed, 25.0, 536.6, 176.0, false, false, false)
	system.wait(1000)
	native.call(0x239A3351AC1DA385, playerPed, playerCoord, false, false, false)
end)

menu.add_feature("native stats test", "action", 0, function(f)
	-- 0x8B0FACEFC36C824B STAT_GET_DATE
	local out = native.ByteBuffer64()
	
	native.call(0x8B0FACEFC36C824B, gameplay.get_hash_key("MPPLY_STARTED_MP"), out, 7, -1)
	
	menu.notify(string.format("year: %i\nmonth: %i\nday: %i\nhour: %i\nminute: %i\nsecond: %i\nmillisecond: %i",
		out:__tointeger(0),
		out:__tointeger(1),
		out:__tointeger(2),
		out:__tointeger(3),
		out:__tointeger(4),
		out:__tointeger(5),
		out:__tointeger(6),
		out:__tointeger(7)
	))
	
end)
