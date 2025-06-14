extends Control

## Component References
@onready var description_label: Label = %DescriptionLabel
@onready var total_score_label: Label = %TotalScoreLabel
@onready var total_orders_complete_label: Label = %TotalOrdersCompleteLabel
@onready var total_time_played_label: Label = %TotalTimePlayedLabel
@onready var levels_container: VBoxContainer = %LevelsContainer

## Holder Values
var selected_level: PackedScene = null

## Godot Inbuilt Methods
func _ready() -> void:
	GameLogic.current_level = null # Set the global current level to null
	for level_button: Button in levels_container.get_children(): # Iterate through each level button in the levels container
		level_button.pressed.connect(Callable(self, "handle_level_selected").bind(level_button)) # Connect the pressed signal with the handle_level_selected method with the level_button as the argument

## Signals
func _on_play_button_pressed() -> void: # Handle play button pressed
	if selected_level == null: # Check if the selected level does not exist
		return
	GameLogic.current_level = selected_level # Set global current level to selected level
	GameLogic.start_game() # Fire start_game method

## Custom Methods
func handle_level_selected(level_button: Button) -> void:
	var level_info: Level = level_button.get_meta("Level") # Get data of selected level
	set_selected_level(level_info.level) # Set selected level
	update_description(level_info.description) # Set description

func set_selected_level(level: PackedScene) -> void:
	selected_level = level # Set selected level value to parsed scene

func update_description(description: String) -> void:
	description_label.text = description # Set description label text to parsed string
