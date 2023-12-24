extends Node

const TYPE_FLAT: int = 0
const TYPE_IN: int = 1
const TYPE_OUT: int = 2
const TYPE_ROUND_TOP_LEFT: int = 3
const TYPE_ROUND_TOP_RIGHT: int = 4
const TYPE_ROUND_BOTTOM_LEFT: int = 5
const TYPE_ROUND_BOTTOM_RIGHT: int = 6

func rand_in_out() -> int:
	return randi_range(1, 2)

func reverse(type: int) -> int:
	if type == 1:
		return 2
	return 1 
