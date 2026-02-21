# Smoothly ✨

A lightweight, tween utility for Roblox games.  
No boilerplate. No headaches. Just smooth animations.

---

## Installation

1. Put the codes in /src in ReplicatedStorage.
2. Require it wherever you need it:

```lua
local Smoothly = require(game.ReplicatedStorage.Smoothly)
```

---

## Quick Start

```lua
-- Move a part up over 2 seconds with a bounce
Smoothly.to(part, 2, { Position = Vector3.new(0, 50, 0) }, "easeOutBounce")

-- Fade in from invisible
Smoothly.from(part, 1, { Transparency = 1 }, "easeOutQuad")

-- Delay something by half a second
Smoothly.delay(0.5, function()
    print("half a second later!")
end)
```

---

## API Reference

### `Smoothly.to(obj, duration, properties, easing, options?)`

Tweens an object from its current values to the given properties.

```lua
Smoothly.to(part, 1.5, {
    Position     = Vector3.new(0, 20, 0),
    Transparency = 0.5,
}, "easeInOutQuad")
```

Returns a `Tween` object.

---

### `Smoothly.from(obj, duration, properties, easing, options?)`

Tweens an object **from** the given values to its current state.  
Great for intro animations, set where things start, not where they end.

```lua
Smoothly.from(frame, 0.3, { Size = UDim2.new(0, 0, 0, 0) }, "easeOutBack")
```

---

### `Smoothly.chain(obj)`

Returns a `Chain` builder for sequencing tweens one after another.

```lua
Smoothly.chain(part)
    :to(1, { Position = Vector3.new(0, 10, 0) }, "linear")
    :wait(0.5)
    :to(1, { Position = Vector3.new(0, 50, 0) }, "easeInOutQuad")
    :call(function() print("midpoint!") end)
    :to(0.5, { Transparency = 1 }, "easeOutSine")
    :onComplete(function() print("chain done!") end)
    :play()
```

**Chain methods:**

| Method | Description |
|---|---|
| `:to(duration, props, easing)` | Add a forward tween step |
| `:from(duration, props, easing)` | Add a tween-from step |
| `:wait(duration)` | Pause between steps |
| `:call(fn)` | Run a function between steps |
| `:onStart(fn)` | Called when the chain begins |
| `:onComplete(fn)` | Called when all steps finish |
| `:play()` | Start the chain |

---

### `Smoothly.parallel(tweenList, onComplete?)`

Runs multiple tweens at the same time. Fires `onComplete` when all finish.

```lua
Smoothly.parallel({
    { part1, 1, { Size = Vector3.new(5, 5, 5) }, "easeOutQuad" },
    { part2, 1, { Transparency = 0 }, "linear" },
    { part3, 2, { Position = Vector3.new(0, 30, 0) }, "easeInOutCubic" },
}, function()
    print("all done!")
end)
```

Each entry can also be a named table:

```lua
{ obj = part, duration = 1, props = { Transparency = 0 }, easing = "linear" }
```

---

### `Smoothly.sequence(obj, steps, options?)`

Shorthand for defining a chain of tweens on one object in a single table.

```lua
Smoothly.sequence(part, {
    { duration = 0.5, props = { Position = Vector3.new(0, 10, 0) }, easing = "linear" },
    { duration = 1,   props = { Position = Vector3.new(0, 50, 0) }, easing = "easeInOutQuad" },
    { duration = 0.5, props = { Transparency = 1 }, easing = "easeOutSine", wait = 0.2 },
}, {
    onComplete = function() print("sequence finished") end,
})
```

Each step supports:
- `duration` how long the tween lasts
- `props` / `properties` target property values
- `easing` easing name or function
- `wait` optional pause after this step (seconds)
- `after` optional callback to run after this step

---

### `Smoothly.delay(duration, callback)`

Fires a callback after a set time. Lightweight animation scheduler.

```lua
Smoothly.delay(2, function()
    part.BrickColor = BrickColor.new("Bright red")
end)
```

---

### `Smoothly.ease(name, func)`

Register a custom easing function globally so you can reference it by name anywhere.

```lua
Smoothly.ease("myBounce", function(t)
    return math.sin(t * math.pi)
end)

Smoothly.to(part, 1, { Position = Vector3.new(0, 20, 0) }, "myBounce")
```

Custom easing functions receive `t` (0–1) and must return a number (usually 0–1, but overshooting is fine).

---

### `Smoothly.reverse(tweenId)`

Reverses the direction of a playing tween.

```lua
local t = Smoothly.to(part, 3, { Position = Vector3.new(0, 50, 0) }, "linear")
task.wait(1)
Smoothly.reverse(t.id)
```

---

### Global Controls

```lua
Smoothly.pause(tweenId)          -- pause a specific tween
Smoothly.resume(tweenId)         -- resume a specific tween
Smoothly.cancel(tweenId)         -- cancel a specific tween

Smoothly.pauseAll()              -- pause everything
Smoothly.pauseAll("ui")          -- pause only tweens tagged "ui"

Smoothly.resumeAll()             -- resume everything
Smoothly.resumeAll("ui")         -- resume only tagged tweens

Smoothly.cancelAll()             -- cancel everything
Smoothly.cancelAll("effects")    -- cancel only tagged tweens

Smoothly.count()                 -- number of active tweens
Smoothly.count("ui")             -- active tweens with a given tag
```

Tags are set through the `options` table:

```lua
Smoothly.to(frame, 0.3, { Transparency = 0 }, "easeOutQuad", { tag = "ui" })
```

---

### Tween Object

Every `Smoothly.to` and `Smoothly.from` call returns a Tween object you can interact with directly.

```lua
local t = Smoothly.to(part, 2, { Transparency = 1 }, "linear")

t:pause()
t:resume()
t:cancel()
t:reverse()
t:reset()

t:onStart(function() print("started") end)
t:onUpdate(function(progress) print(progress) end)
t:onComplete(function() print("done") end)

print(t:getState())     -- "playing", "paused", "completed", "cancelled"
print(t:getProgress())  -- 0 to 1
print(t.id)             -- unique id string
```

---

### Options Table

All tween functions accept an optional `options` table as the last argument:

| Key | Type | Description |
|---|---|---|
| `tag` | string | Label this tween for group control |
| `loop` | boolean | Loop forever |
| `pingPong` | boolean | Reverse back and forth |
| `repeatCount` | number | Repeat N times (0 = no repeats) |

```lua
Smoothly.to(part, 1, { Transparency = 0.5 }, "easeInOutSine", {
    loop      = false,
    pingPong  = true,
    repeatCount = 3,
    tag       = "ambient",
})
```

---

## Easing Reference

| Name | Curve |
|---|---|
| `linear` | Constant speed |
| `easeInQuad` / `easeOutQuad` / `easeInOutQuad` | Smooth quadratic |
| `easeInCubic` / `easeOutCubic` / `easeInOutCubic` | Stronger curve |
| `easeInQuart` / `easeOutQuart` / `easeInOutQuart` | Even stronger |
| `easeInSine` / `easeOutSine` / `easeInOutSine` | Gentle, sine-based |
| `easeInExpo` / `easeOutExpo` / `easeInOutExpo` | Dramatic acceleration |
| `easeInCirc` / `easeOutCirc` / `easeInOutCirc` | Circular arc |
| `easeInBack` / `easeOutBack` / `easeInOutBack` | Slight overshoot |
| `easeInBounce` / `easeOutBounce` / `easeInOutBounce` | Bouncy landing |
| `easeInElastic` / `easeOutElastic` / `easeInOutElastic` | Spring-like snap |

You can also pass a **function directly** instead of a name string:

```lua
Smoothly.to(part, 1, { Transparency = 0 }, function(t)
    return t * t * t
end)
```

---

## Supported Property Types

Smoothly can animate any property of these types:

- `number`
- `Vector3`, `Vector2`
- `CFrame`
- `Color3`
- `UDim2`, `UDim`
- `NumberRange`

---

## Repository Structure

```
Smoothly/
├── init.lua        main API entry point
├── tween.lua       core tween object
├── chain.lua       sequential chaining
├── parallel.lua    simultaneous tweens
├── sequence.lua    step-list shorthand
├── easing.lua      built-in & custom easings
├── manager.lua     tween registry & group control
└── utils.lua       lerp, id gen, helpers
```

---

## License

This project is licensed under MIT License, check the license file for more.

Happy building! :)
