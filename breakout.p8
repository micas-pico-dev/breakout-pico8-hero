pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
function _init()
	cls()
	ball_x=1
	ball_y=33
	ball_dx=2
	ball_dy=2
	ball_r=2
	ball_dr=0.5
	
	pad_x=52
	pad_y=120
	pad_dx=0
	pad_w=24
	pad_h=3
	pad_c=7
end

function _update()
	local buttpress=false
	if btn(0) then
		--left
		pad_dx=-5
		buttpress=true
		--pad_x-=5
	end
	if btn(1) then
		--right
		pad_dx=5
		buttpress=true
		--pad_x+=5
	end
	if not(buttpress) then
		pad_dx=pad_dx/1.7
	end
	pad_x+=pad_dx

	ball_x+=ball_dx
	ball_y+=ball_dy
	
	if ball_x > 127 or ball_x < 0 then
		ball_dx = -ball_dx
		sfx(0)
	end
	if ball_y > 127 or ball_y < 0 then
		ball_dy = -ball_dy
		sfx(0)
	end
	
	pad_c=7
	-- check if ball hit pad
	if ball_box(pad_x,pad_y,pad_w,pad_h) then
		-- deal with collision
		pad_c=8
		ball_dy = -ball_dy
	end
	
end

function _draw()
	rectfill(0,0,127,127,1)
	circfill(ball_x,ball_y,ball_r, 10)
	rectfill(pad_x,pad_y,pad_x+pad_w,pad_y+pad_h,pad_c)
end

function ball_box(box_x,box_y,box_w,box_h)
	-- checks a collision of the ball with a rectangle
	if ball_y-ball_r>box_y+box_h then
		return false
	end
	if ball_y+ball_r<box_y then
		return false
	end
	if ball_x-ball_r>box_x+box_w then
		return false
	end
	if ball_x+ball_r<box_x then
		return false
	end
	return true	
end
__gfx__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00077000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00700700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
00010000183601836018350183301832018310000000000000000000000000000000000000000000000000000a30000000000000d300000000000000000000000000000000000000000000000000000000000000
