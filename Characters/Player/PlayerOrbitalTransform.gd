extends Node2D

var rotate_speed = 50

func _process(delta):
	if get_tree().get_first_node_in_group("players") != null:
		global_position = get_tree().get_first_node_in_group("players").global_position
	var new_rotation = self.rotation_degrees + rotate_speed * delta
	self.rotation_degrees = fmod(new_rotation, 360)
