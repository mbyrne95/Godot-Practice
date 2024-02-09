extends Control

@export var vertical_offset = 0

func _process(_delta):
	global_position = Vector2(get_parent().global_position.x, get_parent().global_position.y - vertical_offset)
