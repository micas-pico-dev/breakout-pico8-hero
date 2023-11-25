pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--goals
-- todo: explosions do not
--       trigger combos!

-- 6. powerups
-- 7. juicyness 
--     arrow anim
--     text blinking
--     particles
--     screenshake
-- 8. high score

function _init()
	cls()
	mode="start"
	level=""
	debug=""
	levelnum=1
	levels={}
	levels[2]="x4b"
--	levels[2]="x4b"
--	levels[1] = "hxixsxpxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbx"
	levels[1] = "////x4b/s9s"
end

function _update60()
	if mode=="game" then
		update_game()
	elseif mode=="start" then
		update_start()
	elseif mode=="gameover" then
		update_gameover()
	elseif mode=="levelover" then
		update_levelover()
	end
end

function update_start()
	if btnp(5) then
		startgame()
	end
end

function startgame()
	mode="game"
	ball_r=2
	ball_dr=0.5
	
	pad_x=52
	pad_y=120
	pad_dx=0
	pad_w=24
	pad_h=3
	pad_c=7
	
	brick_w=9
	brick_h=4
	
	levelnum = 1
	level = levels[levelnum]
	buildbricks(level)

	lives=3
	points=0
	
	sticky=true
	
	chain=1 --combo chain multiplier
	
	serveball()
end

function nextlevel()
	mode="game"
	pad_x=52
	pad_y=120
	pad_dx=0
	
	levelnum+=1
	if levelnum>#levels then
		-- we've beaten the game
		-- we need some kind of special
		-- screen here
		mode="start"
		return
	end
	level=levels[levelnum]
	buildbricks(level)

	sticky=true
	
	chain=1
	
	serveball()
end


function buildbricks(lvl)
	local i,j,last
	brick_x={}
	brick_y={}
	brick_v={}
	brick_t={}
	
	j=0
	-- b = normal brick
	-- x = empty space
	-- i = indestructable brick
	-- h = hardened brick
	-- p = sploding brick
	-- p = powerup brick
	
	for i=1,#lvl do
		j+=1
		local char=sub(lvl,i,i)
		if char=="b" 
		or char=="i" 
		or char=="h" 
		or char=="s" 
		or char=="p" then
			last=char
			addbrick(j,char)
		elseif char=="/" then
			j=(flr((j-1)/11)+1)*11
		elseif char=="x" then
			last="x"
		elseif char>="1" and char<="9" then
			--debug=char
			for o=1,char+0 do
				if last=="b" 
				or last=="i" 
				or last=="h" 
				or last=="s" 
				or last=="p" then
					addbrick(j,last)
				elseif last=="x" then
					--nothing
				end
				j+=1
			end
			j-=1
		end
	end
end

function addbrick(_i,_t)
	add(brick_x,4+((_i-1)%11)*(brick_w+2))
	add(brick_y,20+flr((_i-1)/11)*(brick_h+2))
	add(brick_v,true)
	add(brick_t,_t)
end

function levelfinished()
	if #brick_v==0 then return true end
	
	for i=1,#brick_v do
		if brick_v[i]==true and brick_t[i] != "i" then
			return false
		end
	end
	return true
end

function serveball()
	ball_x=pad_x+flr(pad_w/2)
	ball_y=pad_y-ball_r
	ball_dx=1
	ball_dy=-1
	ball_ang=1
	chain=1
	
	sticky=true
end

function setang(ang)
	ball_ang=ang
	if ang==2 then
		ball_dx=0.50*sign(ball_dx)
		ball_dy=1.30*sign(ball_dy)
	elseif ang==0 then
		ball_dx=1.30*sign(ball_dx)
		ball_dy=0.50*sign(ball_dy)
	else
		ball_dx=1*sign(ball_dx)
		ball_dy=1*sign(ball_dy)
	end
end

function sign(n)
	if n<0 then
		return -1
	elseif n>0 then
		return 1
	else 
		return 0
	end
end

function gameover()
	mode="gameover"
end

function levelover()
	mode="levelover"
end

function update_gameover()
	if btnp(5) then
		startgame()
	end
end

function update_levelover()
	if btnp(5) then
		nextlevel()
	end
end

function update_game()
	local buttpress=false
	local nextx,nexty,brickhit
	if btn(0) then
		--left
		pad_dx=-2.5
		buttpress=true
		--pad_x-=5
		if sticky then
			ball_dx=-1
		end
	end
	if btn(1) then
		--right
		pad_dx=2.5
		buttpress=true
		--pad_x+=5
		if sticky then
			ball_dx=1
		end
	end
	
	if sticky and btnp(5) then
		sticky=false
	end
	
	if not(buttpress) then
		pad_dx=pad_dx/1.3
	end
	pad_x+=pad_dx
	pad_x=mid(0,pad_x,127-pad_w)

	if sticky then
		ball_x=pad_x+flr(pad_w/2)
		ball_y=pad_y-ball_r-1
	else
		nextx = ball_x+ball_dx
		nexty = ball_y+ball_dy
		
		if nextx > 124 or nextx < 3 then
			nextx=mid(0,nextx,127)
			ball_dx = -ball_dx
			sfx(0)
		end
		if nexty < 10 then
			nexty=mid(0,nexty,127)
			ball_dy = -ball_dy
			sfx(0)
		end
	
		-- check if ball hit pad
		if ball_box(nextx,nexty,pad_x,pad_y,pad_w,pad_h) then
			-- deal with collision
			-- find out in which direction to deflect
			if deflx_ball_box(ball_x,ball_y,ball_dx,ball_dy,pad_x,pad_y,pad_w,pad_h) then
				--ball hit paddle on the side
				ball_dx = -ball_dx
				if ball_x < pad_x+pad_w/2 then
					nextx=pad_x-ball_r
				else
					nextx=pad_x+pad_w+ball_r
				end
			else
				--ball hit paddle on the top/bottom
				ball_dy = -ball_dy
				if ball_y > pad_y then
					--bottom
					nexty=pad_y+pad_h+ball_r	
				else
					--top
					nexty=pad_y-ball_r
					if abs(pad_dx)>2 then
						--change angle
						if sign(pad_dx)==sign(ball_dx) then
							--flatten angle
							setang(mid(0,ball_ang-1,2))
						else
							--raise angle
							if ball_ang==2 then
								ball_dx=-ball_dx
							else
								setang(mid(0,ball_ang+1,2))											
							end
						end
					end 
				end
			end
			sfx(1)
			chain=1
		end
		
		brickhit=false
		for i=1,#brick_x do
			-- check if ball hit brick
			if brick_v[i] and ball_box(nextx,nexty,brick_x[i],brick_y[i],brick_w,brick_h) then
				-- deal with collision
				-- find out in which direction to deflect
				if not(brickhit) then
					if deflx_ball_box(ball_x,ball_y,ball_dx,ball_dy,brick_x[i],brick_y[i],brick_w,brick_h) then
						ball_dx = -ball_dx
					else
						ball_dy = -ball_dy
					end
				end
				brickhit=true
				hitbrick(i,true)
				
			end
		end
		
		ball_x=nextx
		ball_y=nexty
		checkexplosions()
		if nexty > 127 then
			sfx(2)
			lives-=1
			if lives<0 then
				gameover()
			else
				serveball()
			end
		end
	end
	
	if levelfinished() then
		_draw()
		levelover()
	end
end

function hitbrick(_i,_combo)
	if brick_t[_i]=="b" then
		sfx(2+chain)
		brick_v[_i]=false
		if _combo then
			points+=10*chain
			chain+=1
			chain=mid(1,chain,7)
		end
	elseif brick_t[_i]=="i" then
		sfx(10)
	elseif brick_t[_i]=="h" then
		sfx(10)
		brick_t[_i]="b"
	elseif brick_t[_i]=="p" then
		sfx(2+chain)
		brick_v[_i]=false
		if _combo then
			points+=10*chain
			chain+=1
			chain=mid(1,chain,7)
		end
		-- todo: trigger powerup
	elseif brick_t[_i]=="s" then
		sfx(2+chain)
		brick_t[_i]="zz"
		if _combo then
			points+=10*chain
			chain+=1
			chain=mid(1,chain,7)
		end
	end
end

function checkexplosions()
	for i=1,#brick_x do
		if brick_t[i] == "zz" then
			brick_t[i] = "z"
		end
	end
	for i=1,#brick_x do
		if brick_t[i] == "z" then
			explodebrick(i)
		end
	end
	for i=1,#brick_x do
		if brick_t[i] == "zz" then
			brick_t[i] = "z"
		end
	end
end

function explodebrick(_i)
	brick_v[_i]=false
	for j=1,#brick_x do
		if j!=_i 
		and brick_v[j] 
		and abs(brick_x[j] - brick_x[_i]) <= (brick_w+2)
		and abs(brick_y[j] - brick_y[_i]) <= (brick_h+2)
		then
			hitbrick(j)
		end
	end
end

function _draw()
	if mode=="game" then
		draw_game()
	elseif mode=="start" then
		draw_start()
	elseif mode=="gameover" then
		draw_gameover()
	elseif mode=="levelover" then
		draw_levelover()
	end
end

function draw_start()
	cls()
	print("pico hero breakout",30,40,7)
	print("press ❎ to start",32,80,11)
end

function draw_gameover()
	rectfill(0,60,128,75,0)
	print("game over",46,62,7)
	print("press ❎ to restart",27,68,6)
end

function draw_levelover()
	rectfill(0,60,128,75,0)
	print("stage clear!",46,62,7)
	print("press ❎ to continue",27,68,6)
end

function draw_game()
	local i
	
	cls(1)
	circfill(ball_x,ball_y,ball_r, 10)
	if sticky then
		-- serve preview
		line(ball_x+ball_dx*4,ball_y+ball_dy*4,ball_x+ball_dx*6,ball_y+ball_dy*6,10)
		
	end
	
	rectfill(pad_x,pad_y,pad_x+pad_w,pad_y+pad_h,pad_c)
	
	-- draw bricks
	local brickcol
	for i=1,#brick_x do
		if brick_v[i] then
			if brick_t[i] == "b" then
				brickcol=14
			elseif brick_t[i] == "i" then
				brickcol=6
			elseif brick_t[i] == "h" then
				brickcol=15
			elseif brick_t[i] == "s" then
				brickcol=9
			elseif brick_t[i] == "p" then
				brickcol=12
			elseif brick_t[i] == "z" or brick_t[i] == "zz" then
				brickcol=8
			end
			rectfill(brick_x[i],brick_y[i],brick_x[i]+brick_w,brick_y[i]+brick_h,brickcol)
		end
	end
	
	rectfill(0,0,128,6,0)
	if debug!="" then
		print(debug,1,1,7)
	else
		print("lives:"..lives,1,1,7)
		print("score:"..points,40,1,7)	
		print("chain:"..chain.."x",100,1,7)
	end
end

function ball_box(bx,by,box_x,box_y,box_w,box_h)
	-- checks a collision of the ball with a rectangle
	if by-ball_r>box_y+box_h then return false end
	if by+ball_r<box_y then return false end
	if bx-ball_r>box_x+box_w then return false end
	if bx+ball_r<box_x then return false end
	return true	
end

function deflx_ball_box(bx,by,bdx,bdy,tx,ty,tw,th)
	local slp=bdy/bdx
	local cx,cy
	
	if bdx==0 then
		return false
	elseif bdy==0 then
		return true
	
	elseif slp > 0 and bdx > 0 then
	
		cx=tx-bx
		cy=ty-by
		return cx > 0 and cy/cx < slp
	
	elseif slp < 0 and bdx > 0 then
	
		cx=tx-bx
		cy=ty+th-by
		return cx > 0 and cy/cx >= slp
	
	elseif slp > 0 and bdx < 0 then
	
		cx=tx+tw-bx
		cy=ty+th-by
		return cx < 0 and cy/cx <= slp

	else

		cx=tx+tw-bx
		cy=ty-by
		return cx < 0 and cy/cx >= slp
	end
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
01010000243602436024350243302432024310000000000000000000000000000000000000000000000000000a30000000000000d300000000000000000000000000000000000000000000000000000000000000
00050000204501e4501b4501845015450124500f4500c450094500645003450014500040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400
000200002c3603036030350303303430003300003000030000300003000030000300003000030000300003000a30000300003000d300003000030000300003000030000300003000030000300003000030000300
000200002d3603236032350323303530003300003000030000300003000030000300003000030000300003000a30000300003000d300003000030000300003000030000300003000030000300003000030000300
000200002e3603336033350333303630003300003000030000300003000030000300003000030000300003000a30000300003000d300003000030000300003000030000300003000030000300003000030000300
00020000303603536035350353303830003300003000030000300003000030000300003000030000300003000a30000300003000d300003000030000300003000030000300003000030000300003000030000300
00020000313603636036350363303a30003300003000030000300003000030000300003000030000300003000a30000300003000d300003000030000300003000030000300003000030000300003000030000300
00020000333603836038350383303b30003300003000030000300003000030000300003000030000300003000a30000300003000d300003000030000300003000030000300003000030000300003000030000300
00020000353603a3603a3503a3303e30003300003000030000300003000030000300003000030000300003000a30000300003000d300003000030000300003000030000300003000030000300003000030000300
00020000394603546035450354303440003400004000040000400004000040000400004000040000400004000a40000400004000d400004000040000400004000040000400004000040000400004000040000400
