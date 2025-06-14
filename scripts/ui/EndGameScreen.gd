extends Control

## Component References
@onready var score_label: Label = %ScoreLabel
@onready var orders_complete_label: Label = %OrdersCompleteLabel

## Godot Inbuilt Functions
func _ready() -> void:
	score_label.text = "Score: " + str(GameLogic.current_match_data.score) # Set score
	orders_complete_label.text = "Orders Completed: " + str(GameLogic.current_match_data.score) # Set orders complete
	GameLogic.end_game() # Initate logic execution 

## Signals
func _on_lobby_button_pressed() -> void: # Handle lobby button pressed
	GameLogic.move_to_lobby() # Move the player back to the lobby

func _on_play_again_button_pressed() -> void: # Handle play again button pressed
	GameLogic.start_game() # Create a new match instance of the current level
