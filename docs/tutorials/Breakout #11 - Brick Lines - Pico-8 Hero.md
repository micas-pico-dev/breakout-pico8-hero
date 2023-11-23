## Breakout #11 - Brick Lines - Pico-8 Hero

## **Code Explanation**

Adding `y` values to `brick_y` table
```lua
  ...
  -- 1
  add(brick_x,4+((i-1)%11)*(brick_w+2))
  -- 2
  add(brick_y,20+flr((I-1)/11)*(brick_h+2))
  ...
```
### **1. Step by Step**

- `4` -> initial left margin
- `(I-1)%11` -> here we garantee that will always fill the line with the maximum of 11 bricks
- `(brick_w+2)` -> adding the width of the brick and a small gap of 2
- `5 + (I-1) * (brick_w+2)` -> x value to the corresponding brick

### **2. Step by Step**

- `20` -> initial top margin
- `(I-1)` -> start counting from `0` so the first brick will be draw in y=20
- `flr((i-1)/11))` -> here we say that we want to move to the next line every 11 bricks, the `flr()` removes the decimal part of the division
- `(brick_h+2)` -> adding the height of the brick and a small gap of 2
- `20+flr((I-1)/11)*(brick_h+2)` -> y value to the corresponding brick
