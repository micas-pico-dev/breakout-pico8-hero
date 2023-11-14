## Breakout #2 - Functions and Variables - Pico-8 Hero

  ## **PICO-8 Functions**
  
  ### Game loop

  **_INIT**
  - Executed only once when the game loads.
  
  **_UPDATE**
  - Executed in every single frame. This function is always running at 30/60 fps without any problem.
  - Here we put game state changes, math calculation and most part of the logic.

  **_DRAW**
  - Executed in every single frame. This function is not always running at 30/60 fps.
  - Here we put things that cost time to draw something in the screen.

  ## **Programming basics**
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
  - Variables -> Used to store information, for example the variable
  `p_x=10` could be the X position of a player in which the X value is `10`.
 
  - Variable type -> You can store numbers, text (string) or booleans (true or false).

  ```lua
    p_x=10
    p_name="BOB"
    p_alive=true
  ```

  ## **PICO-8 tips**
  - Declare your functions/variable in a way that is located before using or calling it. 
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