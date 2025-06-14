extends Control

## Component References
@onready var timer_label: Label = %TimerLabel
@onready var score_label: Label = %ScoreLabel
@onready var timer: Timer = %Timer

## Holder Values
@export var seconds: int
var seconds_left: int

## Godot Inbuilt Methods
func _ready() -> void:
	seconds_left = seconds # Set value of seconds_left to value of seconds
	timer_label.text = str(seconds) # Set label text to seconds variable value
	start_timer() # Start timer
	GameLogic.game_paused.connect(handle_game_pause) # Connect game_paused signal with handle_game_pause method
	GameLogic.game_unpaused.connect(handle_game_unpause) # Connect game_unpaused signal with handle_game_unpause method

## Signals
func _on_timer_timeout() -> void: # Handle when timer finishes counting down
	seconds_left -= 1 # De-increment value of seconds_left
	timer_label.text = str(seconds_left) # Set the timer label to the new value of seconds_left
	if seconds_left == 0: # Check if the value of seconds_left is 0
		GameLogic.move_to_end_screen() # Move player to end game screen

## Custom Methods
func handle_game_pause() -> void:
	pause_timer() # Fire pause_timer method

func handle_game_unpause() -> void:
	unpause_timer() # Fire unpause_timer method

func start_timer() -> void:
	timer.start() # Start timer running

func pause_timer() -> void:
	timer.paused = true # Pause timer running

func unpause_timer() -> void:
	timer.paused = false # Unpause timer
