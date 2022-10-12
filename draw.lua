local PI = 3.1415926535897932

local function main()

	--#### `void				draw_rect_ext(v2 pos1, v2 pos2, v2 pos3, v2 pos4, uint32_t color1, uint32_t color2, uint32_t color3, uint32_t color4)`
	--#### `void				draw_circle(v2 pos, float radius, uint32_t color, float|nil radians, float|nil phase_offset, int|nil sample_rate)`
	--#### `void				draw_circle_outline(v2 pos, float radius, uint32_t color, float|nil radians, float|nil phase_offset, int|nil sample_rate)`

	menu.add_feature("Draw Test", "toggle", 0, function(feat)
		while feat.on do
			scriptdraw.draw_circle(v2(-.45, -.2), .2, 0xAA00FF00)
			scriptdraw.draw_circle_outline(v2(-.45, .2), .2, 0xAA00FF00)
			
			scriptdraw.draw_circle(v2(-.15, -.2), .2, 0xAA00FF00, PI, PI * .25)
			scriptdraw.draw_circle_outline(v2(-.15, .2), .2, 0xAA00FF00, PI, PI * .25)
			
			scriptdraw.draw_circle(v2(.15, -.2), .2, 0xAA00FF00, PI * .5)
			scriptdraw.draw_circle_outline(v2(.15, .2), .2, 0xAA00FF00, PI * .5)
			
			scriptdraw.draw_circle_outline(v2(.45, .4), .2, 0xAA00FF00, PI * .5, 0)
			scriptdraw.draw_circle_outline(v2(.45, 0), .2, 0xAA00FF00, PI, PI * .5)
			scriptdraw.draw_circle_outline(v2(.45, -.4), .2, 0xAA00FF00, PI * .5, PI * 1.5)
			
			scriptdraw.draw_rect_ext(
				v2(-.12, .4),	--bottom left
				v2(-.1, .5),	--top left
				v2(.1, .5),		--top right
				v2(.12, .4),	--bottom right
				0xAA0000FF,
				0xAA00FF00,
				0xAAFF0000,
				0xAAFFFFFF
			)
			
			-- bezier curve
			local h = scriptdraw.size_pixel_to_rel_y(5)
			local s = v2(-.2, -.7)
			local e = v2(0, -.5)
			local m = v2(s.x + (e.x - s.x) * 2.0, s.y)
			local r = 64
			
			scriptdraw.draw_curved_line(s, e, m, 0xAA00FF00, r);
			
			scriptdraw.draw_line(s, m, 1, 0x880000FF);
			scriptdraw.draw_line(e, m, 1, 0x880000FF);
			
			scriptdraw.draw_circle(s, h, 0x880000FF);
			scriptdraw.draw_circle(e, h, 0x880000FF);
			scriptdraw.draw_circle(m, h, 0x880000FF);
			
			
			system.wait(0)
		end
	end).on=true

end

main()