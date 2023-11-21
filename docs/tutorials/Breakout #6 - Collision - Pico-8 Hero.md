## Breakout #6 - Collision - Pico-8 Hero

## **Code explanation**

Check the cases in which the ball will not collide with the paddle, if none of the instructions are executed we know we have a collision.
```lua
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
```
#### **Step by Step**

- First  if: `(ball_y - ball_r)`  -> top of the ball        / `(box_y + box_h)` -> bottom of the paddle
- Second if: `(ball_y + ball_r)`  -> bottom of the ball     / `(box_y)`         -> top of the paddle
- Third  if: `(ball_x - ball_r)`  -> left side of the ball  / `(box_x + box_w)` -> right side of the paddle
- Fourth if: `(ball_x + ball_r)`  -> right side of the ball / `(box_x)`         -> left side of the paddle

## **Shortcuts**

- CTRL + s -> Quick save game.

## **Game development tips**

- Collision: sometimes it is easier to check when an object does not collide with another object, this way we can eliminate these cases and what remains are collisions.
- Comments: use it in places that are more complex to understand, so you don't need to always remember but you can go back later to the comment.
