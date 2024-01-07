extends Node2D

var SPEED = 150
var time_before_move = 1.5
var in_position = false
var children_active = false


func _ready():
	self.position = Vector2(0, 320)
	#Globs.wave_is_free.connect(set_children_active)

func _process(delta):
	#print(position)
	if (!position_approx()):
		position.y -= SPEED * delta
	else:
		in_position = true
		
	if in_position && !children_active:
		set_children_active()
		
	if self.get_child_count() == 0:
		Globs.wave_complete.emit()
		queue_free()

func set_children_active():
	children_active = true
	await get_tree().create_timer(time_before_move).timeout
	Globs.children_allowed_to_move.emit()
#	in_position = false
#	await get_tree().create_timer(time_before_move).timeout
#	for i in self.get_children():
#		i.allowed_to_move = true
		#get_tree().get_first_node_in_group("enemy_container").add_child(i)

func position_approx():
	# in range x
	if(global_position.y <= 0.05) && (global_position.y >= -0.5):
		return true
	else:
		return false
