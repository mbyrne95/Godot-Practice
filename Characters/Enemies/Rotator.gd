extends Node2D

@export var rotate_speed = 75
@export var rotate_spawn_count = 6
@export var radius = 5

func _ready():
	var step = 2 * PI / rotate_spawn_count
	for i in range(rotate_spawn_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		add_child(spawn_point)

func _process(delta):
	var new_rotation = rotation_degrees + rotate_speed * delta
	rotation_degrees = fmod(new_rotation, 360)
