extends Control

## Component References
@onready var resume_button: Button = %ResumeButton
@onready var exit_button: Button = %ExitButton

## Godot Inbuilt Methods
func _ready() -> void:
	GameLogic.game_paused.connect(handle_game_pause) # Connect game_paused signal to handle_game_pause function

## Signals
func _on_resume_button_pressed() -> void: # Handle resume button pressed
	GameLogic.game_unpaused.emit()
	toggle_visibilty(false) # Toggle visibility to invisible
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Hide mouse cursor
	GameLogic.game_state = GameLogic.GameState.RUNNING # Set game state to running

func _on_exit_button_pressed() -> void: # Handle exit button pressed
	GameLogic.game_ended.emit() # Emit game_ended signal
	GameLogic.move_to_lobby() # Fire method to move player to main menu screen

## Custom Methods
func handle_game_pause() -> void:
	toggle_visibilty(true) # Toggle visibility to visible

func toggle_visibilty(visibilty: bool) -> void:
	self.visible = visibilty
