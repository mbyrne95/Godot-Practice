extends Node2D

@export var num_points = 5
var x_min = 0.0
var x_max = 180.0
var points_array = []

var spawn_point_scene = preload("res://Characters/Enemies/Bosses/eye_boss/sliding_point.tscn")

func _ready():
	for i in num_points:
		var spawn_point = spawn_point_scene.instantiate()
		var x_value = randf_range(10.0, 170.0)
		spawn_point.position = Vector2(x_value, 0.0)
		points_array.append(spawn_point)
		add_child(spawn_point)
