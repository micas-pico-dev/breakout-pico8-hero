# Breakout #2 - Functions and Variables - Pico-8 Hero

## **PICO-8 Functions**

### Game Loop

**_INIT**

- Executed only once when the game loads.

**_UPDATE**

- Executed in every frame. This function consistently runs at 30/60 fps without any issues.
- Here, we handle game state changes, perform mathematical calculations, and manage most of the logic.

**_DRAW**

- Executed in every frame. This function doesn't always run at 30/60 fps.
- Here, we place operations that take time to draw something on the screen.

## **Programming Basics**

- Functions -> Blocks of code that can be reused.

```lua
  function test()
    ...
  end
  ...
  test()
  test()
  test()
  ...
```
- Variables -> Used to store information; for example, the variable p_x=10 could represent the X position of a player, with the X value set to ``10`.

- Variable Types -> You can store numbers, text (string), or booleans (true or false).

```lua
  p_x=10
  p_name="BOB"
  p_alive=true
```

## **PICO-8 tips**

- Declare your functions/variables before using or calling them. Examples: 
  Examples:
  
  **Wrong:**
  ```lua

    hello() -- this will cause an error because you're trying to access something that doesn't exist yet 

    function hello()
      print("hello")
    end
  ```

  **Fine:**
  ```lua
    function hello()
      print("hello")
    end
    
    hello()
  ```