# FPS Devlog — Godot 4

> A first-person shooter with aim tilt and self-tracking enemies.  
> Built in Godot 4 — 1 to 2 hours per day.

---

## Progress Tracker

| Day | Session | Status |
|-----|---------|--------|
| Day 1 | Project setup & scene structure | ⬜ Not started |
| Day 2 | Movement & mouse look | ⬜ Not started |
| Day 3 | Aim tilt | ⬜ Not started |
| Day 4 | Weapon model in view | ⬜ Not started |
| Day 5 | Weapon bob & sway | ⬜ Not started |
| Day 6 | Hitscan shooting | ⬜ Not started |
| Day 7 | Muzzle flash & recoil | ⬜ Not started |
| Day 8 | Navmesh & enemy movement | ⬜ Not started |
| Day 9 | Enemy state machine | ⬜ Not started |
| Day 10 | Line of sight & attack | ⬜ Not started |
| Day 11 | Health component | ⬜ Not started |
| Day 12 | HUD (crosshair, health bar, ammo) | ⬜ Not started |
| Day 13 | Level blockout | ⬜ Not started |
| Day 14 | Replace CSG with assets | ⬜ Not started |
| Day 15 | Visual polish & particles | ⬜ Not started |

> ⬜ Not started · 🔄 In progress · ✅ Done

---

## Phase 1 — Player Controller

### Day 1 — Project setup & scene structure
**Goal:** A Godot project open with a player scene that exists in a 3D world.  
**Key nodes:** `CharacterBody3D` · `CollisionShape3D` · `Camera3D`

- [x] Install Godot 4 — download from godotengine.org
- [x] Create a new project, choose `Forward+` renderer (best for 3D)
- [x] Create a new scene, set root node to `CharacterBody3D`, rename it `Player`
- [x] Add a `CollisionShape3D` child → set shape to `CapsuleShape3D`
- [x] Add a `Camera3D` child — position it at eye height (Y = 1.6)
- [x] Add a `MeshInstance3D` child → BoxMesh so you can see the player from outside
- [x] Create a test level: add a `StaticBody3D` with a large `BoxMesh` as the floor
- [x] Run the scene — you should see a 3D world from the camera's perspective

> **End of session check:** You can run the scene and see a 3D world from the camera's perspective.

#### Notes
<!-- Add your session notes here -->

---

### Day 2 — Movement & mouse look
**Goal:** Walk around the level with WASD and look around with the mouse.  
**Key nodes:** `Input` · `move_and_slide()`

- [x] Attach a new GDScript to the `Player` node
- [x] Add gravity: apply a downward velocity each frame when not on floor
- [x] Add WASD movement: read `Input.get_vector()` and apply to velocity
- [x] Call `move_and_slide()` at the end of `_physics_process()`
- [x] Capture the mouse on `_ready()` with `Input.mouse_mode = Input.MOUSE_MODE_CAPTURED`
- [x] Press `Escape` to release the mouse (for debugging)
- [x] In `_input()`, read `InputEventMouseMotion` — rotate the **body** on Y (left/right)
- [x] Rotate the **Camera3D** on X (up/down) — clamp between -90° and 90°
- [x] Run and walk around — tune movement speed until it feels right

> **End of session check:** You can walk around and look in any direction without the camera flipping.

#### Notes
<!-- Add your session notes here -->

---

### Day 3 — Aim tilt
**Goal:** The camera rolls slightly when strafing — subtle but makes the game feel polished.  
**Key nodes:** `lerp()`

- [x] In `_physics_process()`, read the horizontal strafe input value (-1 to 1)
- [x] Define a `tilt_amount` constant (try 3.0 degrees to start)
- [x] Each frame, lerp the camera's Z rotation toward `strafe_input * -tilt_amount`
- [x] When no strafe input, lerp Z rotation back toward 0
- [x] Use a lerp speed of around 8–10 multiplied by `delta`
- [x] Play with the tilt angle and lerp speed until it feels natural
- [x] Run and strafe back and forth — enjoy the result

> **End of session check:** The camera tilts smoothly when strafing and returns when you stop.  
> **Tip:** This is ~5 lines of code. If it takes 20 minutes, spend the rest of the session tuning feel.

#### Notes
<!-- Add your session notes here -->

---

## Phase 2 — Weapon System

### Day 4 — Weapon model in view
**Goal:** A weapon mesh visible in the bottom-right of the screen that moves with the camera.  
**Key nodes:** `Node3D` · `MeshInstance3D`

- [x] Download a free weapon model from Kenney or Quaternius (or use a BoxMesh placeholder)
- [x] Create a new scene: `Node3D` root, add a `MeshInstance3D` for the weapon, save as `weapon.tscn`
- [x] Instance `weapon.tscn` as a child of `Camera3D` in your player scene
- [x] Position it bottom-right of view (e.g. X=0.3, Y=-0.3, Z=-0.5)
- [x] Run the scene — the weapon should stay fixed in the camera view as you look around

> **End of session check:** A weapon mesh is visible in the corner of the screen at all times.

#### Notes
<!-- Add your session notes here -->

---

### Day 5 — Weapon bob & sway
**Goal:** The weapon moves subtly when walking and lags behind when you look around.

- [ ] In the weapon script, track the player's movement speed each frame
- [ ] Add bob: offset weapon Y position with `sin(time * bob_speed) * bob_amount` when moving
- [ ] Only bob when the player is on the floor and moving — stop when idle
- [ ] Store the previous camera rotation each frame
- [ ] Lerp the weapon position toward a small offset based on how fast the camera is rotating (sway)
- [ ] Tune bob speed (~10), bob amount (~0.02), and sway amount (~0.05) for subtlety
- [ ] Run and walk around — weapon should feel weighted and alive

> **End of session check:** The weapon bobs when walking and swings slightly when you flick the mouse.

#### Notes
<!-- Add your session notes here -->

---

### Day 6 — Hitscan shooting
**Goal:** Click to shoot — a ray fires from the camera and detects what you hit.  
**Key nodes:** `RayCast3D`

- [ ] Add a `RayCast3D` node as a child of `Camera3D` — point it forward (Z = -1), length ~100
- [ ] Enable the raycast: `enabled = true`
- [ ] In `_input()`, listen for `InputEventMouseButton` left click
- [ ] On click: check `raycast.is_colliding()`
- [ ] Print `raycast.get_collider().name` to confirm you're hitting objects
- [ ] Add a simple enemy placeholder capsule to the level and add it to an "enemy" group
- [ ] If the collider is in the enemy group, print "hit enemy!" — damage logic comes on Day 11
- [ ] Add a short cooldown so you can't fire every frame (use a bool flag + timer)

> **End of session check:** Clicking fires a ray — you can confirm hits by name in the Output panel.

#### Notes
<!-- Add your session notes here -->

---

### Day 7 — Muzzle flash & recoil
**Goal:** Shooting has visual and camera feedback — it feels like a real gun.  
**Key nodes:** `GPUParticles3D` · `Tween` · `AudioStreamPlayer3D`

- [ ] Add a `GPUParticles3D` node at the weapon muzzle position
- [ ] Set it to one-shot (`one_shot = true`, `emitting = false`)
- [ ] On shoot: set `emitting = true` — it auto-resets after one burst
- [ ] Set particle lifetime to ~0.05s, amount ~12 for a quick flash
- [ ] Add recoil: on shoot, use a `Tween` to rotate Camera3D X by -3° (kick up)
- [ ] Chain a second tween to lerp back to 0 (recovery) — try 0.15s recovery time
- [ ] Add an `AudioStreamPlayer3D` to the weapon — assign a gunshot sound from Freesound.org
- [ ] Call `.play()` on shoot

> **End of session check:** Shooting shows a particle burst, kicks the camera, and plays a sound.

#### Notes
<!-- Add your session notes here -->

---

## Phase 3 — Enemy AI

### Day 8 — Navmesh & enemy movement
**Goal:** An enemy that walks toward the player automatically, navigating around obstacles.  
**Key nodes:** `NavigationRegion3D` · `NavigationAgent3D`

- [ ] In your level scene, add a `NavigationRegion3D` node
- [ ] Set its `NavigationMesh` resource — click "Bake NavigationMesh" in the editor toolbar
- [ ] Create an enemy scene: `CharacterBody3D` → `CollisionShape3D` + `MeshInstance3D`
- [ ] Add a `NavigationAgent3D` child to the enemy
- [ ] In the enemy script, get a reference to the player node
- [ ] Each frame: call `nav_agent.set_target_position(player.global_position)`
- [ ] Get the next path position with `nav_agent.get_next_path_position()`
- [ ] Move toward it with `move_and_slide()` — use `look_at()` to face the player
- [ ] Instance the enemy in the level and run — it should chase you

> **End of session check:** The enemy walks toward you and navigates around walls.

#### Notes
<!-- Add your session notes here -->

---

### Day 9 — Enemy state machine
**Goal:** The enemy has distinct behaviours — idle until it detects you, then chases.

- [ ] Add an `enum` at the top of the enemy script: `IDLE, PATROL, CHASE, ATTACK, DEAD`
- [ ] Add a `state` variable, default to `IDLE`
- [ ] Wrap `_physics_process()` logic in a `match state:` block
- [ ] `IDLE`: enemy stands still, check distance to player each frame
- [ ] If player is within detection radius (e.g. 15 units): switch to `CHASE`
- [ ] `CHASE`: run the navmesh movement code from Day 8
- [ ] If player moves outside a larger radius (e.g. 20 units): switch back to `IDLE`
- [ ] Run and test — walk into range, enemy chases. Walk away, it stops.

> **End of session check:** Enemy is idle at start, chases when you get close, stops when you escape.

#### Notes
<!-- Add your session notes here -->

---

### Day 10 — Line of sight & attack
**Goal:** Enemy only attacks when it can actually see you — walls block it.

- [ ] Add a `RayCast3D` to the enemy pointing from its head toward the player
- [ ] Each frame in `CHASE` state: update the raycast target to `player.global_position`
- [ ] Check `raycast.get_collider()` — only switch to `ATTACK` if it returns the player node
- [ ] `ATTACK` state: stop moving, face the player, fire on a timer (e.g. every 1.5s)
- [ ] Enemy attack for now: print "enemy attacks!" — damage to player comes on Day 11
- [ ] Switch back to `CHASE` if the player moves out of attack range
- [ ] Test: hide behind a wall — the enemy should stop attacking

> **End of session check:** Enemy attacks when it has clear line of sight, stops when you duck behind cover.

#### Notes
<!-- Add your session notes here -->

---

## Phase 4 — Health & HUD

### Day 11 — Health component
**Goal:** Both the player and enemies have health. Shooting an enemy damages it. Enemy attacks damage you.

- [ ] Create a new script `health_component.gd`
- [ ] Add `@export var max_hp: int = 100` and a `current_hp` variable
- [ ] Add a `take_damage(amount)` function — subtract from `current_hp`, emit a `died` signal at 0
- [ ] Add the node to both the player and enemy scenes
- [ ] In the player shoot code (Day 6): call `enemy.get_node("HealthComponent").take_damage(25)`
- [ ] Connect the enemy's `died` signal → flash red, then `queue_free()`
- [ ] In the enemy attack code (Day 10): call `player.get_node("HealthComponent").take_damage(10)`
- [ ] Test: shoot an enemy 4 times — it disappears. Let an enemy hit you — your health drops.

> **End of session check:** Enemies die after enough shots. Player health decreases when hit.

#### Notes
<!-- Add your session notes here -->

---

### Day 12 — HUD (crosshair, health bar, ammo)
**Goal:** A clean UI showing your health and ammo — plus a crosshair so you can aim.  
**Key nodes:** `CanvasLayer` · `TextureRect` · `ProgressBar` · `Label`

- [ ] Add a `CanvasLayer` node to the player scene
- [ ] Add a crosshair: `TextureRect` centered on screen (a small white cross image, or draw one with `draw_line`)
- [ ] Add a `ProgressBar` for health — anchor it bottom-left, connect it to `HealthComponent.current_hp`
- [ ] Add a `Label` for ammo count — update it when you fire
- [ ] Add a red screen flash on taking damage: a full-screen `ColorRect` that fades out via `Tween`
- [ ] Keep everything minimal — white/grey on transparent, small font

> **End of session check:** You can see your health, ammo count, and a crosshair during play.

#### Notes
<!-- Add your session notes here -->

---

## Phase 5 — Level & Polish

### Day 13 — Level blockout
**Goal:** A real playable level — not just a flat floor.

- [ ] Sketch a rough top-down layout on paper first: 3–4 rooms, corridors, some cover
- [ ] Build it in Godot using `CSGBox3D` nodes — walls, floors, ceilings, cover objects
- [ ] Keep corridors at least 3 units wide so enemies can navigate
- [ ] Re-bake the `NavigationRegion3D` navmesh after building
- [ ] Place 3–5 enemy instances around the level
- [ ] Playtest: walk through the whole level, make sure enemies can reach you everywhere
- [ ] Add a few `OmniLight3D` nodes — even basic lighting makes CSG feel intentional

> **End of session check:** You can walk through a multi-room level and be chased by enemies.

#### Notes
<!-- Add your session notes here -->

---

### Day 14 — Replace CSG with assets
**Goal:** Swap placeholder geometry for real assets — the level starts to look like a game.

- [ ] Download a modular environment pack from Kenney (sci-fi or dungeon kit)
- [ ] Import the GLTF/GLB files into Godot — drag into the FileSystem panel
- [ ] Replace CSG walls and floors with real asset meshes one room at a time
- [ ] Download a character from Quaternius or Mixamo — import and swap the enemy mesh
- [ ] Re-bake navmesh after replacing geometry
- [ ] Swap the player weapon placeholder with a real weapon model if not done yet
- [ ] Playtest — movement and AI should be identical, just looking better now

> **End of session check:** The level uses real assets. Enemies look like actual characters.

#### Notes
<!-- Add your session notes here -->

---

### Day 15 — Visual polish & particles
**Goal:** Atmosphere, juice, and particles — the layer that makes everything feel alive.

- [ ] Add a `WorldEnvironment` node — set a sky, enable ambient occlusion and bloom
- [ ] Add subtle fog in WorldEnvironment — distance fog adds depth cheaply
- [ ] Polish the muzzle flash particles from Day 7 — add a brief `OmniLight3D` flash on fire
- [ ] Add a hit spark particle at the raycast hit point when shooting a wall
- [ ] Add a blood/impact particle on enemy hit
- [ ] Add footstep sounds: play an `AudioStreamPlayer` on a timer when the player is moving
- [ ] Add ambient sound: a looping `AudioStreamPlayer` with an ambience track from Freesound.org
- [ ] Final playtest: play through start to finish — note what feels off in the notes below

> **End of session check:** The game has atmosphere. Shooting, movement, and enemy deaths all have feedback.

#### Notes
<!-- Add your session notes here -->

---

## Assets

| Asset | What it's good for | Link |
|-------|-------------------|------|
| Kenney 3D Assets | Modular sci-fi, military & dungeon kits. CC0 licensed. | https://kenney.nl/assets?q=3d |
| Quaternius | Low-poly characters, weapons & environments with animations. | https://quaternius.com |
| Godot Asset Library | FPS controllers, AI templates, weapon packs to study. | https://godotengine.org/asset-library/asset |
| Mixamo (Adobe) | Free animated 3D characters — idle, walk, attack, death. Export as GLTF. | https://mixamo.com |
| Sketchfab (free filter) | Props and environmental detail. Filter by CC license. | https://sketchfab.com/features/free-3d-models |
| Freesound.org | Gunshots, footsteps, ambient loops. Filter by CC0. | https://freesound.org |

---

## Resources

- [Game Programming Patterns](https://gameprogrammingpatterns.com) — free online, essential reading for devs
- [Godot 4 Docs](https://docs.godotengine.org/en/stable/) — best engine docs in the industry
- [Godot FPS Tutorial](https://docs.godotengine.org/en/stable/tutorials/3d/fps_tutorial/index.html) — official starting point

---

## Changelog

<!-- Add a line after each session. Format: YYYY-MM-DD — what you did -->

---

*Started: <!-- add today's date -->*
