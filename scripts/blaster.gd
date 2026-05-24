extends Node3D

const BOB_SPEED     = 10.0
const BOB_AMOUNT    = 0.02
const SWAY_AMOUNT   = 0.002
const SWAY_SPEED    = 6.0
const BASE_POSITION = Vector3(0.3, -0.3, -0.5)

@onready var player: CharacterBody3D = get_parent().get_parent()
@onready var camera: Camera3D = get_parent()

var time       = 0.0
var mouse_delta = Vector2.ZERO  # stores mouse movement each frame

func _ready() -> void:
	position = BASE_POSITION

func _input(event) -> void:
	if event is InputEventMouseMotion:
		mouse_delta = event.relative  # raw mouse movement — no wrapping issue

func _process(delta: float) -> void:
	_handle_bob(delta)
	_handle_sway(delta)
	mouse_delta = Vector2.ZERO  # reset after using it each frame

func _handle_bob(delta: float) -> void:
	var speed = Vector3(player.velocity.x, 0, player.velocity.z).length()
	
	if speed > 0.1 and player.is_on_floor():
		time += delta
	
	var bob_offset = sin(time * BOB_SPEED) * BOB_AMOUNT
	position.y = lerp(position.y, BASE_POSITION.y + bob_offset, 10.0 * delta)

func _handle_sway(delta: float) -> void:
	# use raw mouse delta instead of rotation difference — no wrapping
	var target_x = BASE_POSITION.x + (-mouse_delta.x * SWAY_AMOUNT)
	var target_y = BASE_POSITION.y + (-mouse_delta.y * SWAY_AMOUNT)
	
	position.x = lerp(position.x, target_x, SWAY_SPEED * delta)
	position.y = lerp(position.y, target_y, SWAY_SPEED * delta)