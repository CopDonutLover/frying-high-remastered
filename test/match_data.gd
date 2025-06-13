extends Node

## Custom Test Function
func test_match_data_object() -> void:
	var new_match_data = MatchData.new()
	print("Score: " + str(new_match_data.get_score()))
	print("Orders Complete: " + str(new_match_data.get_orders_complete()))
	new_match_data.increment_score()
	new_match_data.increment_orders_complete()
	print("Score: " + str(new_match_data.get_score()))
	print("Orders Complete: " + str(new_match_data.get_orders_complete()))
	new_match_data.set_score(100)
	new_match_data.set_orders_complete(100)
	print("Score: " + str(new_match_data.get_score()))
	print("Orders Complete: " + str(new_match_data.get_orders_complete()))

func _ready() -> void:
	test_match_data_object()
