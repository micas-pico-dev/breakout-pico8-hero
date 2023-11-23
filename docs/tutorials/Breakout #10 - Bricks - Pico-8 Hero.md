## Breakout #10 - Bricks - Pico-8 Hero

## **Code Explanation**

Adding `x` values to `brick_x` table
```lua
  ...
  add(brick_x,5+(I-1)*(brick_w+2))
  ...
```
### **Step by Step**

- `5` -> initial left margin
- `(I-1)` -> start counting from `0` so the first brick will be draw in x=5
- `(brick_w+2)` -> add gap of two to the brick width
- `5 + (I-1) * (brick_w+2)` -> x value to the corresponding brick

**Example**

Drawing 3 bricks:
  - first brick (I=1)-> 5 + (1-1) * (10 + 2) => `x => 5` => `rectfill(5,20,5+10,24,14)`
  - second brick (I=2) -> 5 + (2-1) * (10 + 2) => `x => 17`=> `rectfill(17,20,17+10,24,14)`
  - third brick (I=3) -> 5 + (3-1) * (10 + 2) => `x => 29`=> `rectfill(29,20,29+10,24,14)`

## **Code Commands**

Add item to a table 
```lua
  table={}
  add(table,10)
  print(table[1]) -- output => 10
```

## **Programming basics**

- Loops: with loops we can repeat a pice of code and make some repeatable tasks adding dynamics to it.
```lua
  for I=1,10 do
    print(I)
  end
```

- Tables: variable type that can store lot of values.
```lua
  heroes={"ironman", "spiderman", "hulk"}
  for I=1,#heroes do
    print(heroes[I])
  end
```
