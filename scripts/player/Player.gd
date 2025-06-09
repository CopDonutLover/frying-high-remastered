extends CharacterBody3D

# Constants
const CAMERA_MIN_DEGREES = -80
const CAMERA_MAX_DEGREES = 80
const MOVEMENT_MODIFIER = 0.3
const PLAYER_SPEED = 5.5

## Godot Inbuilt Methods
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Hide mouse cursor
	%Camera3D.current = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: # Handle mouse/trackpad movement
		rotation_degrees.y -= event.relative.x * MOVEMENT_MODIFIER
		%Camera3D.rotation_degrees.x -= event.relative.y * MOVEMENT_MODIFIER
		%Camera3D.rotation_degrees.x = clamp(
			%Camera3D.rotation_degrees.x, CAMERA_MIN_DEGREES, CAMERA_MAX_DEGREES
		) # Set min/max view angle from constants
	elif event.is_action_pressed("ui_cancel"): # Handle "esc" input
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # Show mouse cursor

func _physics_process(delta: float) -> void:
	var input_direction_2D = Input.get_vector(
		"move_left", "move_right", "move_forward", "move_back"
	) # Set the input directions for handling movement
	
	var input_direction_3D = Vector3(
		input_direction_2D.x, 0.0, input_direction_2D.y
	) # Create a positional vector for movement
	
	var direction = transform.basis * input_direction_3D
	velocity.x = direction.x * PLAYER_SPEED
	velocity.z = direction.z * PLAYER_SPEED
	
	velocity.y -= 20.0 * delta # Apply a constant downwards force (stimulate gravity)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = 10.0 # Apply high increase in velocity (long jump)
	elif Input.is_action_just_released("jump") and velocity.y > 0.0:
		velocity.y = 0 # Apply short increase in velocity (short jump)
	
	move_and_slide() # Apply calculated velocities to character
