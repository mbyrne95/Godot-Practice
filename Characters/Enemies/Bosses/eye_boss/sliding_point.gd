extends Node2D

var wait_time = 1.5
@onready var timer = $Timer

func _ready():
	wait_time = randf_range(0.75, 2.5)
	timer.wait_time = wait_time
	timer.start()
	var tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(randf_range(10.0, 170.0),310), wait_time)
	
func _on_timer_timeout():
	wait_time = randf_range(0.75, 2.5)
	timer.wait_time = wait_time
	timer.start()
	var tween = create_tween()
	tween.tween_property(self, "global_position", Vector2(randf_range(10.0, 170.0),310), wait_time)
