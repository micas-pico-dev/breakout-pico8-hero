# Breakout Pico-8 Hero

This repository serves as a companion to the [TeamworkCast](https://www.youtube.com/@TeamworkCast) or [Lazy Devs](https://www.youtube.com/@LazyDevs) tutorial playlist on building games from scratch, in this case the Breakout game and for complete beginners.

PS.: I'll be incorporating insights from what I've learned in the videos into this repository. I hope it proves helpful to you as well! 
Feel free to sugest any modification or improvements in the repository!

Reference: [Tutorial](https://youtube.com/playlist?list=PLea8cjCua_P0qjjiG8G5FBgqwpqMU7rBk&si=QSzfSuZvIDRNSmiD) 

**Older PICO-8 cheat sheet:**

<img src="./cheatsheet/older.png" width="400"/>

**Newer PICO-8 cheat sheet:** 

<img src="./cheatsheet/newer.png" width="800"/>


## Breakout #1 - Hello World - Pico-8 Hero

  ### **Code Commands**

  Clear screen with black color.
  ```lua
    cls()
  ```

  Print text to the screen.
  ```lua
    print("Hello World")
  ```

  Print text with a given X position, Y position and a text color as arguments for the print function.
   ```lua
    print("♥", 30, 35, 8)
    --[[
      X -> 30
      Y -> 40
      8 -> color red (see cheat sheet)
    ]]
  ```

  Comments.
  ```lua
    -- this is a single line comment
    --[[
      this 
      is
      a 
      multiline
      comment
    ]]
  ```

  ### **Command line**

  Start the current loaded cartridge.
  ```zsh
    run
  ```

  Splore your cartridges or other people's cartridges.
  ```zsh
    splore
  ```

  ### **Shortcuts**
  - ESC -> Escape to command line or go back to the editor you were in.
  - CTRL + s -> Save.
  - CTRL + r -> Start the current cartridge.

  ### **Programming basics**

  - Functions: blocks of code that can be executed in different places without
  writing to much code. Everything inside a function will be executed when the function
  signature is called. Example:
  ```lua
    function hello_world()
      print("hello world")
      print("") -- empty line
      print("hello world")
      print("")
      print("hello world")
      print("")
    end

    hello_world() -- call the function
    hello_world() -- call the function again
  ```
  The expected result is that will print `hello world` six times and a empty line between each `hello world`.

  ### **PICO-8 tips**

  - PICO-8 doesn't have uppercase, but when you press `shift` + `<key>` in the code editor 
  it'll probably draw some special characters. Example: shift + h -> ♥.