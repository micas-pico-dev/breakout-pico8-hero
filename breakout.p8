pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
--goals
-- 6. powerups
--    - multiball

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
	levels[1]="b9b/p9p"
--	levels[2]="x4b"
--	levels[1] = "hxixsxpxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbxbx"
	--levels[1] = "////x4b/s9s"
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
	
	pad_wo=24 --original pad width
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
	bricks={}
	
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

function resetpills()
	pill={}
end

function addbrick(_i,_t)
	local _b
	_b={}
	_b.x=4+((_i-1)%11)*(brick_w+2)
	_b.y=20+flr((_i-1)/11)*(brick_h+2)
	_b.v=true
	_b.t=_t
	add(bricks,_b)

end

function levelfinished()
	if #bricks==0 then return true end
	
	for i=1,#bricks do
		if bricks[i].v==true and bricks[i].t != "i" then
			return false
		end
	end
	return true
end

function serveball()
	ball={}
	ball[1] = newball()
	
	ball[1].x=pad_x+flr(pad_w/2)
	ball[1].y=pad_y-ball_r
	ball[1].dx=1
	ball[1].dy=-1
	ball[1].ang=1
	
	pointsmult=1
	chain=1
	resetpills()
	
	sticky=true
	sticky_x=flr(pad_w/2)
	
	powerup=0
	powerup_t=0
end

function newball()
	local b
	b={}
	b.x=0
	b.y=0
	b.dx=0
	b.dy=0
	b.ang=1
	return b
end

function setang(bl,ang)
	bl.ang=ang
	if ang==2 then
		bl.dx=0.50*sign(bl.dx)
		bl.dy=1.30*sign(bl.dy)
	elseif ang==0 then
		bl.dx=1.30*sign(bl.dx)
		bl.dy=0.50*sign(bl.dy)
	else
		bl.dx=1*sign(bl.dx)
		bl.dy=1*sign(bl.dy)
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
	
	-- check if pad is bigger
	
	if powerup==4 then
		pad_w=flr(pad_wo*1.5)
	elseif	powerup==5 then
	-- check if pad should shrink
		pad_w=flr(pad_wo/2)
		pointsmult=2
	else
		pad_w=pad_wo
		pointsmult=1
	end
	
	if btn(0) then
		--left
		pad_dx=-2.5
		buttpress=true
		--pad_x-=5
		if sticky then
			ball[1].dx=-1
		end
	end
	if btn(1) then
		--right
		pad_dx=2.5
		buttpress=true
		--pad_x+=5
		if sticky then
			ball[1].dx=1
		end
	end
	
	if sticky and btnp(5) then
		sticky=false
		ball[1].x=mid(3,ball[1].x,124)
	end
	
	if not(buttpress) then
		pad_dx=pad_dx/1.3
	end
	pad_x+=pad_dx
	pad_x=mid(0,pad_x,127-pad_w)

	-- big ball loop
	for bi=#ball,1,-1 do
		updateball(bi)
	end
	
	-- check collision for pills
	for i=#pill,1,-1 do
	
		pill[i].y+=0.7
		if pill[i].y > 128 then
			--remove pill
			del(pill,pill[i])
		elseif box_box(pill[i].x,pill[i].y,8,6,pad_x,pad_y,pad_w,pad_h) then
			powerupget(pill[i].t)
			--remove pill
			del(pill,pill[i])
			sfx(11)
		end
	end
	
	checkexplosions()
		
	if levelfinished() then
		_draw()
		levelover()
	end
	
	if powerup!=0 then
		powerup_t-=1
		if powerup_t<=0 then
			powerup=0
		end
	end
end

function updateball(bi)
	if sticky then
		--	ball_x=pad_x+flr(pad_w/2)
		ball[1].x=pad_x + sticky_x
		ball[1].y=pad_y-ball_r-1
	else
		-- regular ball physics
		local myball=ball[bi]
		if powerup==1 then
			nextx = myball.x+(myball.dx/2)
			nexty = myball.y+(myball.dy/2)
		else
			nextx = myball.x+myball.dx
			nexty = myball.y+myball.dy
		end
		
		-- check if ball hit wall
		if nextx > 124 or nextx < 3 then
			nextx=mid(0,nextx,127)
			myball.dx = -myball.dx
			sfx(0)
		end
		if nexty < 10 then
			nexty=mid(0,nexty,127)
			myball.dy = -myball.dy
			sfx(0)
		end
	
		-- check if ball hit pad
		if ball_box(nextx,nexty,pad_x,pad_y,pad_w,pad_h) then
			-- deal with collision
			-- find out in which direction to deflect
			if deflx_ball_box(myball.x,myball.y,myball.dx,myball.dy,pad_x,pad_y,pad_w,pad_h) then
				--ball hit paddle on the side
				myball.dx = -myball.dx
				if myball.x < pad_x+pad_w/2 then
					nextx=pad_x-ball_r
				else
					nextx=pad_x+pad_w+ball_r
				end
			else
				--ball hit paddle on the top/bottom
				myball.dy = -myball.dy
				if myball.y > pad_y then
					--bottom
					nexty=pad_y+pad_h+ball_r	
				else
					--top
					nexty=pad_y-ball_r
					if abs(pad_dx)>2 then
						--change angle
						if sign(pad_dx)==sign(myball.dx) then
							--flatten angle
							setang(myball,mid(0,myball.ang-1,2))
						else
							--raise angle
							if myball.ang==2 then
								myball.dx=-myball.dx
							else
								setang(myball,mid(0,myball.ang+1,2))											
							end
						end
					end 
				end
			end
			
			sfx(1)
			chain=1
			
			--catch powerup
			if powerup==3 and myball.dy<0 then
				sticky=true
				sticky_x=myball.x-pad_x
			end
		end
		
		brickhit=false
		for i=1,#bricks do
			-- check if ball hit brick
			if bricks[i].v and ball_box(nextx,nexty,bricks[i].x,bricks[i].y,brick_w,brick_h) then
				-- deal with collision
				-- find out in which direction to deflect
				if not(brickhit) then
					if powerup==6 and bricks[i].t=="i" 
					or powerup!=6 then
						if deflx_ball_box(myball.x,myball.y,myball.dx,myball.dy,bricks[i].x,bricks[i].y,brick_w,brick_h) then
							myball.dx = -myball.dx
						else
							myball.dy = -myball.dy
						end
					end
				end
				brickhit=true
				hitbrick(i,true)
			end
		end
		
		myball.x=nextx
		myball.y=nexty
		
		-- check if ball left screen
		if nexty > 127 then
			sfx(2)
			lives-=1
			if lives<0 then
				gameover()
			else
				serveball()
			end
		end
	end--end of sticky if
end

function powerupget(_p)
	if _p==1 then
		--slowdown
		powerup=1
		powerup_t=900
	elseif _p==2 then
		--life
		powerup=2
		powerup_t=0
		lives+=1
	elseif _p==3 then
		--catch
		powerup=3
		powerup_t=900
	elseif _p==4 then
		--expand
		powerup=4
		powerup_t=900
	elseif _p==5 then
		--reduce
		powerup=5
		powerup_t=900
	elseif _p==6 then
		--megaball
		powerup=6
		powerup_t=900
	elseif _p==7 then
		--multiball
		powerup=7
		powerup_t=900
	end
end

function hitbrick(_i,_combo)
	if bricks[_i].t=="b" then
		sfx(2+chain)
		bricks[_i].v=false
		if _combo then
			points+=10*chain*pointsmult
			chain+=1
			chain=mid(1,chain,7)
		end
	elseif bricks[_i].t=="i" then
		sfx(10)
	elseif bricks[_i].t=="h" then
		if powerup==6 then
			sfx(2+chain)
			bricks[_i].v=false
			if _combo then
				points+=10*chain*pointsmult
				chain+=1
				chain=mid(1,chain,7)
			end
		else	
			sfx(10)
			bricks[_i].t="b"
		end
	elseif bricks[_i].t=="p" then
		sfx(2+chain)
		bricks[_i].v=false
		if _combo then
			points+=10*chain*pointsmult
			chain+=1
			chain=mid(1,chain,7)
		end
		spawnpill(bricks[_i].x,bricks[_i].y)
	elseif bricks[_i].t=="s" then
		sfx(2+chain)
		bricks[_i].t="zz"
		if _combo then
			points+=10*chain*pointsmult
			chain+=1
			chain=mid(1,chain,7)
		end
	end
end

function spawnpill(_x,_y)
	local _t
	
	_t=flr(rnd(7)+1)
	
	_pill={}
	_pill.x=_x
	_pill.y=_y
	_pill.t=_t

	add(pill,_pill)

end

function checkexplosions()
	for i=1,#bricks do
		if bricks[i].t == "zz" then
			brick_t[i] = "z"
		end
	end
	for i=1,#bricks do
		if bricks[i].t == "z" then
			explodebrick(i)
		end
	end
	for i=1,#bricks do
		if bricks[i].t == "zz" then
			bricks[i].t = "z"
		end
	end
end

function explodebrick(_i)
	bricks[_i].v=false
	for j=1,#bricks do
		if j!=_i 
		and bricks[j].v 
		and abs(bricks[j].x - bricks[_i].x) <= (brick_w+2)
		and abs(bricks[j].y - bricks[_i].y) <= (brick_h+2)
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
	for i=1,#ball do
		circfill(ball[i].x,ball[i].y,ball_r, 10)
	end
	
	if sticky then
		-- serve preview
		line(ball[1].x+ball[1].dx*4,ball[1].y+ball[1].dy*4,ball[1].x+ball[1].dx*6,ball[1].y+ball[1].dy*6,10)
		
	end
	
	rectfill(pad_x,pad_y,pad_x+pad_w,pad_y+pad_h,pad_c)
	
	-- draw bricks
	local brickcol
	for i=1,#bricks do
		if bricks[i].v then
			if bricks[i].t == "b" then
				brickcol=14
			elseif bricks[i].t == "i" then
				brickcol=6
			elseif bricks[i].t == "h" then
				brickcol=15
			elseif bricks[i].t == "s" then
				brickcol=9
			elseif bricks[i].t == "p" then
				brickcol=12
			elseif bricks[i].t == "z" or brick_t[i] == "zz" then
				brickcol=8
			end
			rectfill(bricks[i].x,bricks[i].y,bricks[i].x+brick_w,bricks[i].y+brick_h,brickcol)
		end
	end
	
	for i=1,#pill do
		if pill[i].t==5 then
			palt(0,false)
			palt(15,true)
		end
		spr(pill[i].t,pill[i].x,pill[i].y)
		palt()
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

function box_box(box1_x,box1_y,box1_w,box1_h,box2_x,box2_y,box2_w,box2_h)
	-- checks a collision of the two boxes
	if box1_y>box2_y+box2_h then return false end
	if box1_y+box1_h<box2_y then return false end
	if box1_x>box2_x+box2_w then return false end
	if box1_x+box1_w<box2_x then return false end
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
0000000006777760067777600677776006777760f677777f06777760067777600000000000000000000000000000000000000000000000000000000000000000
00000000559949955576777555b33bb555c1c1c55508800555e222e5558288850000000000000000000000000000000000000000000000000000000000000000
00700700559499955576777555b3bbb555cc1cc55508080555e222e5558288850000000000000000000000000000000000000000000000000000000000000000
00077000559949955576777555b3bbb555cc1cc55508800555e2e2e5558228850000000000000000000000000000000000000000000000000000000000000000
00077000559499955576677555b33bb555c1c1c55508080555e2e2e5558228850000000000000000000000000000000000000000000000000000000000000000
00700700059999500577775005bbbb5005cccc50f500005f05eeee50058888500000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000
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
0001000038050330502f050290403905039050390501e0401a0200000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
