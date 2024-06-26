extends Node2D

var SPEED = 150
var time_before_move = 1.5
var in_position = false
var children_active = false

var orbital_empty = false
var num_children = 0

var enemies_in_children = []

func _ready():
	Globs.child_of_wave_died.connect(reduce_num_children)
	self.position = Vector2(0, 320)
	
	for i in get_children():
		if !i.is_in_group("player_orbital_transform"):
			num_children += 1
		else:
			for j in i.get_children():
				num_children += 1
	#Globs.wave_is_free.connect(set_children_active)

func _physics_process(delta):
	#print(position)
	if (!position_approx()):
		position.y -= SPEED * delta
	else:
		in_position = true
		
	if in_position && !children_active:
		set_children_active()
		
		
	
	for i in get_children():
		#if i.get_child_count() > 0:
		if i.is_in_group("player_orbital_transform"):
			if i.get_child_count() == 0:
				orbital_empty = true
	
	if orbital_empty == true && num_children == 0:
		Globs.wave_complete.emit()
		queue_free()

func set_children_active():
	children_active = true
	Globs.parallax_motion_stop.emit()
	await get_tree().create_timer(time_before_move).timeout
	Globs.children_allowed_to_move.emit()

func position_approx():
	# in range x
	if(global_position.y <= 0.05) && (global_position.y >= -0.5):
		return true
	else:
		return false

func reduce_num_children():
	num_children -= 1
