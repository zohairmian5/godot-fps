# Godot 4 Learning Notes

> Personal notes tracked alongside the FPS devlog.  
> The goal is to write things in your own words — not copy paste from docs.

---

## How to use this file

After each session, answer these three questions in the day's section:
1. **What did I learn?** — concepts, nodes, how things work
2. **What confused me?** — things that didn't make sense at first
3. **How did I solve it?** — what clicked, what helped

Writing it in your own words is what makes it stick.

---

## Day 1 — Project setup & scene structure
*Date: 2026-05-18*

### What I learned
- A Godot scene is a tree of nodes — every object is a node with a specific type and purpose
- `CharacterBody3D` is the physics actor for the player — it moves when code tells it to
- `CollisionShape3D` defines the physical boundary of a body — without it things pass through
- `StaticBody3D` is for immovable solid objects like floors and walls
- `MeshInstance3D` is purely visual — it has no effect on physics
- `CollisionShape3D` must always be a child of a physics body (`StaticBody3D`, `CharacterBody3D` etc) — it cannot work on its own
- Size a collision shape on the **shape resource** itself, not on the node transform — non-uniform node scale causes physics warnings
- `DirectionalLight3D` simulates sunlight — without it the scene is unlit and flat
- Light colour multiplies with surface colour to produce the final visible colour
- `WorldEnvironment` background is not a physical surface so lights don't affect it
- `CSGBox3D` combines `StaticBody3D` + `CollisionShape3D` + `MeshInstance3D` into one node — useful for fast prototyping
- `.godot/` folder should be gitignored — it contains auto-generated cache files

### What confused me
- Why `CollisionShape3D` can't exist on its own without a parent physics body
- Why scaling the node caused a warning instead of just working
- Why the `WorldEnvironment` colour didn't change when I changed the light colour

### How I solved it
- `CollisionShape3D` is just a shape definition — it needs a physics body parent to give it meaning in the physics engine
- Godot wants collision shapes sized via the shape resource, not node transform — avoids floating point errors in physics
- `WorldEnvironment` is a backdrop not a surface — it has its own colour setting independent of lights

### Nodes introduced today
| Node | Purpose |
|------|---------|
| `CharacterBody3D` | Physics actor controlled by code |
| `StaticBody3D` | Immovable solid object |
| `CollisionShape3D` | Defines physical boundary of a body |
| `MeshInstance3D` | Visual mesh — no physics |
| `Camera3D` | The player's view into the world |
| `DirectionalLight3D` | Scene-wide directional light (sun) |
| `WorldEnvironment` | Sky and background settings |
| `CSGBox3D` | Quick prototype box with built-in collision and mesh |

### Questions to follow up on
<!-- Things you want to understand better later -->
- What other shapes can CollisionShape3D use besides BoxShape3D and CapsuleShape3D?
- When would you use RigidBody3D vs StaticBody3D?
- What does AnimatableBody3D do?

---

## Day 2 — Movement & mouse look
*Date: 2026-05-20*

### What I learned
- `_physics_process()` runs at a fixed 60 times per second regardless of frame rate
- `_process()` runs every rendered frame — tied to GPU speed, inconsistent timing
- Physics and movement go in `_physics_process()`, visual effects go in `_process()`
- `Input.get_vector()` returns a Vector2 continuously while keys are held — best for WASD
- `Input.is_action_just_pressed()` fires once on keypress — best for jump and shoot
- `transform.basis` represents the player's current orientation — multiplying input by it makes movement relative to where the player is facing, not the world
- `.normalized()` rescales any vector to length 1 — keeps diagonal movement the same speed as straight movement. Without it diagonal movement is 40% faster
- Gravity needs `-=` not `=` — it accumulates over time, getting stronger each frame
- Gravity needs to be negative because Y axis is up in Godot — negative Y moves downward
- `velocity.x` and `velocity.z` don't need `* delta` because they set a fixed value each frame, not accumulate. `move_and_slide()` handles the frame rate math internally
- `velocity.y` needs `* delta` because gravity accumulates — without it falling speed depends on frame rate
- Godot axes: X = left/right, Y = up/down, Z = forward/back
- `Input.MOUSE_MODE_CAPTURED` hides the cursor and locks it to the window
- `InputEventMouseMotion` fires every time the mouse moves — `event.relative` contains how far it moved
- Rotate the **body** on Y axis for left/right look — keeps movement direction in sync with facing direction
- Rotate the **camera** on X axis for up/down look — only the view tilts, not the whole body
- Clamp camera X rotation between -90° and 90° — prevents the camera from flipping upside down
- `deg_to_rad()` converts degrees to radians — Godot stores rotation in radians internally
- `_ready()` runs once when the scene loads — right place for setup code
- `_input(event)` fires whenever any input event occurs — mouse, keyboard, controller
- `rotate_y()` adds to the current rotation by a relative amount each frame — used for mouse look because you want to accumulate rotation as the mouse moves
- `rotation.y =` sets an absolute angle directly — snaps to a fixed angle regardless of current rotation
- `event.relative.x` is positive when mouse moves right, but turning right in Godot needs a negative Y rotation — the minus sign corrects this mismatch
- `event.relative.y` is positive when mouse moves down, but looking down needs a negative X rotation — same reason for the minus
- Godot Y rotation convention: positive = turns left, negative = turns right
- Godot X rotation convention: positive = tilts up, negative = tilts down
- If mouse look ever feels inverted, the minus sign on relative.x or relative.y is the first thing to check
- The body rotates on Y for left/right look — keeps movement direction in sync with facing
- The camera rotates on X for up/down look — only the view tilts, not the whole body

### What confused me
- Why `velocity.y` needs `* delta` but `velocity.x` does not
- Why gravity has to be negative
- Why we rotate the body for left/right but only the camera for up/down
- Why `input.y` maps to `Vector3.z` not `Vector3.y`

### How I solved it
- `velocity.y` accumulates each frame with `-=` so without delta it grows too fast on high fps. `velocity.x` just sets a fixed value so frame rate doesn't affect it
- Y axis is up in Godot — negative Y means downward, so gravity subtracts to pull the player down
- Rotating the whole body keeps the movement direction in sync with where you're looking. Only rotating the camera would make W always move in the original direction even when looking sideways
- `Input.get_vector()` returns a Vector2 which only has x and y. In 3D, forward/back lives on the Z axis not Y — so input.y gets placed in Vector3.z slot

### Nodes & methods introduced today
| Node / Method | Purpose |
|---------------|---------|
| `Input.get_vector()` | Returns continuous 2D directional input as Vector2 |
| `Input.is_action_just_pressed()` | Returns true once on keypress |
| `Input.MOUSE_MODE_CAPTURED` | Hides and locks cursor to window |
| `InputEventMouseMotion` | Event that fires when mouse moves |
| `transform.basis` | Player's current orientation — used to make movement relative to facing direction |
| `move_and_slide()` | Moves the character by velocity and handles collisions |
| `rotate_y()` | Rotates node around Y axis (left/right) |
| `rotate_x()` | Rotates node around X axis (up/down) |
| `clamp()` | Restricts a value between a min and max |
| `deg_to_rad()` | Converts degrees to radians |
| `_ready()` | Called once when node enters the scene |
| `_input(event)` | Called on every input event |

### Questions to follow up on
- What is the difference between `rotate_y()` and setting `rotation.y` directly?
- What other mouse modes are there besides MOUSE_MODE_CAPTURED and MOUSE_MODE_VISIBLE?
- Why does Godot use radians internally instead of degrees?
- What happens if SENSITIVITY is too high or too low?

### What I learned
<!-- Write in your own words what you understood today -->

### What confused me
<!-- Anything that tripped you up -->

### How I solved it
<!-- What clicked, what resource helped -->

### Nodes introduced today
| Node | Purpose |
|------|---------|
| | |

### Questions to follow up on
<!-- Things you want to understand better later -->

---

## Day 3 — Aim tilt
*Date: 2026-05-21*

### What I learned
- Aim tilt is a camera Z rotation that tilts slightly when strafing left or right — purely a feel improvement, no gameplay effect
- `input.x` from `Input.get_vector()` already contains the horizontal strafe value (-1 to 1) — no need to read input again separately
- `deg_to_rad()` is needed because Godot stores all rotation internally in radians — we think in degrees but Godot works in radians
- `lerp(current, target, speed)` smoothly moves a value toward a target — used for tilt so it animates instead of snapping
- When strafe input returns to 0, tilt_target becomes 0 automatically — lerp smoothly returns camera to center with no extra code needed
- `* delta` is needed on the lerp speed to keep the animation speed consistent across different frame rates — without it the tilt snaps faster on high fps machines
- The minus on `input.x * -TILT_AMOUNT` corrects the rotation direction mismatch — same reason as mouse look minus signs
- Godot Z rotation convention: positive tilts one way, negative tilts the other — the minus corrects which direction feels natural
- Anything that changes over time every frame needs `* delta` to stay frame rate independent — gravity, lerp speeds, weapon bob, enemy movement all follow this rule

### What confused me
- Why lerp needs `* delta` when it already has a speed value
- Why there is a minus on the tilt amount

### How I solved it
- Without `* delta` lerp runs the same fraction per frame regardless of time — on 120fps it runs twice as many frames per second so it moves twice as fast. `* delta` converts it from per frame to per second so both machines animate at the same speed
- The minus corrects the mismatch between input direction and Godot's Z rotation direction — without it strafing right tilts the camera the wrong way. Same pattern as the minus signs in mouse look

### Nodes & methods introduced today
| Node / Method | Purpose |
|---------------|---------|
| `lerp(current, target, speed)` | Smoothly moves a value toward a target each frame |
| `deg_to_rad()` | Converts degrees to radians for Godot's rotation system |
| `camera.rotation.z` | Z axis rotation — tilts the camera sideways |

### Questions to follow up on
- What is the difference between `lerp()` and `move_toward()`?
- What other camera effects can be added with rotation and lerp?
- Why does Godot use radians instead of degrees internally?

---

## Day 4 — Weapon model in view
*Date: <!-- fill in -->*

### What I learned

### What confused me

### How I solved it

### Nodes introduced today
| Node | Purpose |
|------|---------|
| | |

### Questions to follow up on

---

## Day 5 — Weapon bob & sway
*Date: <!-- fill in -->*

### What I learned

### What confused me

### How I solved it

### Nodes introduced today
| Node | Purpose |
|------|---------|
| | |

### Questions to follow up on

---

## Day 6 — Hitscan shooting
*Date: <!-- fill in -->*

### What I learned

### What confused me

### How I solved it

### Nodes introduced today
| Node | Purpose |
|------|---------|
| | |

### Questions to follow up on

---

## Day 7 — Muzzle flash & recoil
*Date: <!-- fill in -->*

### What I learned

### What confused me

### How I solved it

### Nodes introduced today
| Node | Purpose |
|------|---------|
| | |

### Questions to follow up on

---

## Day 8 — Navmesh & enemy movement
*Date: <!-- fill in -->*

### What I learned

### What confused me

### How I solved it

### Nodes introduced today
| Node | Purpose |
|------|---------|
| | |

### Questions to follow up on

---

## Day 9 — Enemy state machine
*Date: <!-- fill in -->*

### What I learned

### What confused me

### How I solved it

### Nodes introduced today
| Node | Purpose |
|------|---------|
| | |

### Questions to follow up on

---

## Day 10 — Line of sight & attack
*Date: <!-- fill in -->*

### What I learned

### What confused me

### How I solved it

### Nodes introduced today
| Node | Purpose |
|------|---------|
| | |

### Questions to follow up on

---

## Day 11 — Health component
*Date: <!-- fill in -->*

### What I learned

### What confused me

### How I solved it

### Nodes introduced today
| Node | Purpose |
|------|---------|
| | |

### Questions to follow up on

---

## Day 12 — HUD
*Date: <!-- fill in -->*

### What I learned

### What confused me

### How I solved it

### Nodes introduced today
| Node | Purpose |
|------|---------|
| | |

### Questions to follow up on

---

## Day 13 — Level blockout
*Date: <!-- fill in -->*

### What I learned

### What confused me

### How I solved it

### Nodes introduced today
| Node | Purpose |
|------|---------|
| | |

### Questions to follow up on

---

## Day 14 — Replace CSG with assets
*Date: <!-- fill in -->*

### What I learned

### What confused me

### How I solved it

### Questions to follow up on

---

## Day 15 — Visual polish & particles
*Date: <!-- fill in -->*

### What I learned

### What confused me

### How I solved it

### Nodes introduced today
| Node | Purpose |
|------|---------|
| | |

### Questions to follow up on

---

## Godot Concepts Reference

A running glossary — add to this as you learn new things.

| Concept | What it means |
|---------|--------------|
| Node | The basic building block of every Godot scene — everything is a node |
| Scene tree | The hierarchy of nodes that makes up a scene |
| Physics body | A node that participates in the physics engine (`StaticBody3D`, `CharacterBody3D`, `RigidBody3D`) |
| Resource | A data object shared across nodes — shapes, materials, meshes are all resources |
| Signal | Godot's event system — a node emits a signal, other nodes listen and react |
| `_ready()` | Called once when the node enters the scene — use for setup |
| `_process()` | Called every frame — use for non-physics logic |
| `_physics_process()` | Called every physics frame — use for movement and collision |
| `_input()` | Called when an input event occurs — use for mouse and keyboard handling |
| `delta` | Time in seconds since the last frame — multiply movement by this to keep it frame-rate independent |

---

*Started: 2026-05-18*
