extends CharacterBody3D

## Constants
const CAMERA_MIN_DEGREES = -80
const CAMERA_MAX_DEGREES = 80
const MOVEMENT_MODIFIER = 0.3
const PLAYER_SPEED = 5.5

## Component References
@onready var interact_ray: RayCast3D = %InteractRay
@onready var camera_3d: Camera3D = %Camera3D
@onready var hold_pos: Marker3D = %HoldPos

## Holder Values
var held_item: RigidBody3D
var is_frozen: bool = false

## Godot Inbuilt Methods
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Hide mouse cursor
	camera_3d.current = true

	GameLogic.game_paused.connect(game_paused)
	GameLogic.game_unpaused.connect(game_unpaused)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion: # Handle mouse/trackpad movement
		rotation_degrees.y -= event.relative.x * MOVEMENT_MODIFIER
		camera_3d.rotation_degrees.x -= event.relative.y * MOVEMENT_MODIFIER
		camera_3d.rotation_degrees.x = clamp(
			camera_3d.rotation_degrees.x, CAMERA_MIN_DEGREES, CAMERA_MAX_DEGREES
		) # Set min/max view angle from constants
	elif event.is_action_pressed("ui_cancel") and GameLogic.game_state == GameLogic.GameState.RUNNING: # Handle "esc" input
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # Show mouse cursor
		GameLogic.game_paused.emit() # Fire game_paused signal
		GameLogic.game_state = GameLogic.GameState.PAUSED # Set game state to paused
	elif event.is_action_pressed("interact"): # Handle "e" input
		handle_collider("handle_pickup") # Handle picking up object
	elif event.is_action_pressed("item_drop"): # Handle "f" input
		if held_item == null: # Check if there is currently no item being held
			return
		drop_item() # Drop item if being held

func _physics_process(delta: float) -> void:
	if is_frozen: # Check if the game is frozen (true)
		velocity = Vector3.ZERO # Set the velocity to 0 to freeze movement
		return
	
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
	handle_collider("handle_hint_visibility") # Handle hint visibilty with raycasting collission

## Custom Methods
func handle_collider(method) -> void:
	var collider = interact_ray.get_collider() # Get object raycast is colliding with
	if interact_ray.is_colliding() and collider: # Check if there is a collision present
		if collider.has_method(method): # Check for method in collider
			if method == "handle_pickup" and not held_item == null: # Check if an item is currently being held
				drop_item() # Drop the current item being held to allow for another item to be held
			collider.callv(method, [self]) # Call method if present
			if method == "handle_pickup": # Check if the method is "handle_pickup"
				held_item = collider # Set the held_item variable to the collider
				held_item.freeze = true # Freeze item's physics rendering

func drop_item() -> void:
	if held_item == null and  not held_item.is_inside_tree(): # Check if the held_item does not exist and is not in the current scene tree
		return

	for child in camera_3d.get_children(): # Iterate through children in camera3d
		if not child == interact_ray and not child == hold_pos: # Check to make sure the child is not the raycast or holding position marker 3d
			child.queue_free() # Remove held item from holding position marker
			held_item.call("handle_drop") # Call "handle_drop" method in item
			held_item.global_position = hold_pos.global_position # Set global position to the holding position for where to drop the item
			held_item.freeze = false # Unfreeze the items physics rendering
			held_item = null # Set the held_item to disable functionality that requires an item being held

func game_paused() -> void:
	is_frozen = true

func game_unpaused() -> void:
	is_frozen = false
