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
			
			system.wait(0)
		end
	end).on=true

end

main()