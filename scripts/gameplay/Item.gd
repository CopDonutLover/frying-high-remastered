extends Node3D

## Exposed Values
@export var item: Item

## Component References
@onready var interact_hint: Label3D = %InteractHint
@onready var visibility_cooldown: Timer = %VisibilityCooldown
@onready var collision_shape_3d: CollisionShape3D = %CollisionShape3D

## Godot Inbuilt Methods
func _ready() -> void:
	var instance = item.model.instantiate() # Create an instance of the model from the data
	add_child(instance) # Add the model to the item scene
	self.visible = true # Set visible to player
	collision_shape_3d.disabled = false # Enable collission for raycasting
	interact_hint.visible = false # Set interact hint label to invisible

## Signals
func _on_visibility_cooldown_timeout() -> void:
	interact_hint.visible = false # Set interact hint label to invisible

## Custom Methods
func handle_hint_visibility(_player_character: CharacterBody3D) -> void:
	interact_hint.visible = true # Set interact hint label to visible
	visibility_cooldown.start() # Start interact hint visibility cooldown timer

func handle_pickup(player_character: CharacterBody3D) -> void:
	var model = item.model.instantiate() # Create a new instance of the item's model
	player_character.get_node("Camera3D").add_child(model) # Add model to player character camera node
	model.global_position = player_character.get_node("Camera3D/HoldPos").global_position # Set model position to holding position global position
	self.visible = false # Set invisible to player
	collision_shape_3d.disabled = true # Disable collission for raycasting

func handle_drop() -> void:
	self.visible = true # Set visible to player
	collision_shape_3d.disabled = false # Enable collission for raycasting
