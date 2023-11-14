# Breakout #4 - Sound Effects - Pico-8 Hero

## **Code Commands**

Play sound effect at position 1.
```lua
  sfx(1)
```

Draws a circle at `(10, 20)` with red color (8) and a radius of `2`. 
```lua
  circfill(10,20,2,8)
  --[[
    X -> 10
    Y -> 20
    8 -> red color
  ]]
```

Draws a rect that fills all the screen with blue color (1). 
```lua
  rectfill(0,0,127,127,1)
  --[[
    X -> 0
    Y -> 0
    X2 -> 127
    y2 -> 127
    1 -> blue color
  ]]
```
## **Command line**

Save your cartridge with a specified name.
```zsh
  save my_game
```

## **PICO-8 Tips**

- `cls()` -> You can use it to clear the screen with a given color. So if you want a red screen you can do `cls(8)`.