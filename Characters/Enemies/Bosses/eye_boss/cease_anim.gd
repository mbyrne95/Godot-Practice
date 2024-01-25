extends Node2D

@onready var color_rect = $ColorRect

func _ready():
	var tween = create_tween()
	tween.tween_method(set_shader_value, 0.0, 1.5, 0.5)
	
func set_shader_value(value):
	color_rect.material.set_shader_parameter("diameter", value)
