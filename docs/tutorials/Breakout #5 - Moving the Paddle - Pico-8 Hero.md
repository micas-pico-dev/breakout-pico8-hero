## Breakout #5 - Moving the Paddle - Pico-8 Hero

## **Code Commands**

Creates a filled rectangle.
```lua
  rectfill(pad_x,pad_y,pad_x+pad_w,pad_y+pad_h,7)
  --[[
    (pad_x, pad_y) -> Top left corner
    (pad_x + pad_w, pad_y + pad_h) -> Bottom right corner
    7 -> White color
  ]]
```

Check if a button is pressed.
(See the [cheatsheet](./cheatsheet/newer.png))
```lua
  btn(0) -> Returns true if the `left` arrow is pressed, otherwise returns false.
  btn(1) -> Returns true if the `right` arrow is pressed, otherwise returns false.
```

Negate a variable with the `not` function. Very usefull when you need to do something depending on `false` value.
```lua
  buttpress=false
  if not(buttpress) then -- if the buttpress is false it'll enter the `if` statement
    ...
  end
```

## **Shortcuts**

- ALT + ⬆️/ ALT + ⬇️ -> Quick navigation between functions.

## **Game development tips** (juiceness)

- Natural movement: for a movement to feel natural, it's essential to introduce acceleration/slowdown, creating the sensation of organic motion.
  
## References from the episode

### Books
- [Game Fill by Steve Swink](https://www.amazon.com/Game-Feel-Designers-Sensation-Kaufmann/dp/0123743281)
- [The Illusion of Life: Disney Animation](https://www.amazon.com/Illusion-Life-Disney-Animation/dp/0786860707)
