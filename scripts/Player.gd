extends CharacterBody3D

const SPEED = 5.0
const GRAVITY = 20
const SENSITIVITY = 0.003

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	pass # Replace with function body.
	
func _input(event) -> void:
	# release mouse on escape
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# mouse look
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * SENSITIVITY)
		$Camera3D.rotate_x(-event.relative.y * SENSITIVITY)
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, deg_to_rad(-90), deg_to_rad(90))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if  is_on_floor():
		velocity.y = 0;
	else:
		velocity.y -= GRAVITY * delta;
	
	var input = Input.get_vector("Left","Right","Up","Down")
	var direction = (transform.basis * Vector3(input.x,0,input.y)).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0
	move_and_slide()
		
		
