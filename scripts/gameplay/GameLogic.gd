extends Node

## Constants
const main_menu: PackedScene = preload("res://scenes/ui/main_screen.tscn")
const end_screen: PackedScene = preload("res://scenes/ui/EndGameScreen.tscn")

## Holder Values
var player_state: PlayerState = PlayerState.LOBBY
var game_state: GameState = GameState.NOGAME
var current_match_data: MatchData
var current_level: PackedScene

## Custom Enumerations
enum PlayerState {
	LOBBY,
	INGAME,
}

enum GameState {
	NOGAME,
	RUNNING,
	PAUSED,
	ENDED
}

## Custom Signals
@warning_ignore_start("unused_signal")
signal game_paused
signal game_unpaused
signal game_ended
@warning_ignore_restore("unused_signal")

## Custom Methods
func start_game() -> void:
	get_tree().change_scene_to_packed(current_level) # Change scene to selected level
	var match_data = MatchData.new() # Create a new match data object
	current_match_data = match_data # Set the current match data to the newly created match data
	player_state = PlayerState.INGAME # Set the player state to ingame
	game_state = GameState.RUNNING # Set the game state to running
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # Lock the cursor and make invisible

func end_game() -> void:
	current_match_data = null # Clear the current match data object from memory

func move_to_lobby() -> void:
	get_tree().change_scene_to_packed(main_menu) # Change scene to main menu screen
	player_state = PlayerState.LOBBY # Set the player state to loby
	game_state = GameState.NOGAME # Set the game state to nogame

func move_to_end_screen() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) # Unlock the cursor and make visible
	get_tree().change_scene_to_packed(end_screen) # Change scene to end game screen
	game_state = GameState.ENDED # Set the game state as ended
