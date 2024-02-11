extends aoe_dmg

@onready var enemy_container
var enemies_on_screen = []
@onready var orbital_container
@onready var scorch_dot = preload("res://Characters/Player/DOTs/scorch.tscn")
var enemies_that_have_been_damaged = []

var ri_dist
var ro_dist 

func _ready():
	#print(ri.global_position)
	player = get_tree().get_first_node_in_group("players")
	#print(global_position)
	has_started = false
	outer = $ColorRect
	inner = $ColorRect2
	lifespan = $lifespan
	#print("ring started")
	#ring_scale = scale 
	outer_color = Vector4(1,0,0,1)
	#outer.material.set_shader_param("Color",outer_color)
	outer.position = global_position - Vector2(160,160)
	outer.scale = scale
	
	inner_color = Vector4(0.9,0.7,0.9,1)
	#inner.material.set_shader_param("Color",inner_color)
	inner.position = global_position - Vector2(160,160)
	inner.scale = scale
	
	#print(inner.position)
	
	anim_player.speed_scale = timescale

func _process(_delta):
	
	#get rings distance at start of frame
	ri_dist = global_position.distance_to(ri.global_position)
	ro_dist = global_position.distance_to(ro.global_position)
	
	#check if any enemies in the enemy container
	enemy_container = get_tree().get_first_node_in_group("enemy_container")
	
	if !has_started:
		has_started = true
		anim_player.play("expanding_wave_2")
		lifespan.wait_time = float(5.0 / timescale)
		lifespan.start()
	
	dmg_children(enemy_container)
	

		
func dmg_children(enemy_array):
	if enemy_array.get_child_count() == 0 || enemy_array.get_child(0) == null:
		return
		
	if enemy_array.get_child(0).get_child_count() == 0:
		return
		
	#getting CHILDREN OF THE WAVE
	for i in enemy_array.get_child(0).get_children():
		#step through the orbital transform
#		if i == get_parent(): 
#			return
		
		if i.is_in_group("player_orbital_transform"):
			if i.get_child_count() != 0:
				for j in i.get_children():
					var enemy_position = j.global_position
					var enemy_dist = position.distance_to(enemy_position)
			
					if ((enemy_dist < ro_dist && enemy_dist > ri_dist) || enemy_dist == 0):
						if j not in enemies_that_have_been_damaged:
							enemies_that_have_been_damaged.append(j)
							j.take_damage(damage)
							var poisoned = false
							for x in j.get_children():
								if x.is_in_group("scorch_DOT"):
									poisoned = true
									await get_tree().create_timer(0.05).timeout
									var current_stacks = x.num_stacks
									current_stacks += 5
									x.num_stacks = current_stacks
									x.restart_timer()
							if !poisoned:
								var scorch = scorch_dot.instantiate()
								scorch.num_stacks +=4
								j.add_child(scorch)
						
		elif i.is_in_group("matroyshka_container"):
			if i.get_child_count() != 0:
				for j in i.get_children():
					var enemy_position = j.global_position
					var enemy_dist = position.distance_to(enemy_position)
			
					if ((enemy_dist < ro_dist && enemy_dist > ri_dist) || enemy_dist == 0):
						if j not in enemies_that_have_been_damaged:
							enemies_that_have_been_damaged.append(j)
							j.take_damage(damage)
							var poisoned = false
							for x in j.get_children():
								if x.is_in_group("scorch_DOT"):
									poisoned = true
									await get_tree().create_timer(0.05).timeout
									var current_stacks = x.num_stacks
									current_stacks += 5
									x.num_stacks = current_stacks
									x.restart_timer()
							if !poisoned:
								var scorch = scorch_dot.instantiate()
								scorch.num_stacks +=4
								j.add_child(scorch)
						
		#otherwise, just step through normal enemies	
		elif i.is_in_group("enemies"):
			#var enemy = i
			var enemy_position = i.global_position
			var enemy_dist = position.distance_to(enemy_position)
			
			if ((enemy_dist < ro_dist && enemy_dist > ri_dist) || enemy_dist == 0):
				if i not in enemies_that_have_been_damaged:
					enemies_that_have_been_damaged.append(i)
					i.take_damage(damage)
					print(i, "took damage: ", damage)
					var poisoned = false
					for x in i.get_children():
						if x.is_in_group("scorch_DOT"):
							poisoned = true
							#await get_tree().create_timer(0.05).timeout
							var current_stacks = x.num_stacks
							current_stacks += 5
							x.num_stacks = current_stacks
							x.restart_timer()
					if !poisoned:
						var scorch = scorch_dot.instantiate()
						scorch.num_stacks +=4
						i.add_child(scorch)

func _on_lifespan_timeout():
	anim_player.play("RESET")
	queue_free()
