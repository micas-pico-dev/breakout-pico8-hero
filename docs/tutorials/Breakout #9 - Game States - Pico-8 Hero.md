## Breakout #9 - Game States - Pico-8 Hero

## **Code explanation**

Its very important do define which game modes we will have in our game, so we can start separating things early and have more clean code.
```lua
  function _update60()
  	if mode=="game" then
  		update_game()
  	elseif mode=="start" then
  		update_start()
  	elseif mode=="gameover" then
  		update_gameover()
  	end
  end
```

## **PICO-8 Tips**

Use the `_update60` function to run games at 60fps.
```lua
  ...
  function _update60()
    ...
  end
  ...
```
