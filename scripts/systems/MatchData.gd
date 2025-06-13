class_name MatchData
extends Object

## Match Data
var score: int
var orders_complete: int

## Getters/Setters
func get_score() -> int:
	return score

func set_score(value: int) -> void:
	score = value

func get_orders_complete() -> int:
	return orders_complete

func set_orders_complete(value: int) -> void:
	orders_complete = value

## Custom Methods
func increment_score() -> void:
	score += 1

func increment_orders_complete() -> void:
	orders_complete += 1

func format_final_match_data() -> void: # Incomplete function
	pass
