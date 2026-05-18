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
*Date: <!-- fill in -->*

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
