extends aoe_dmg

@onready var enemy_container
var enemies_on_screen = []
@onready var orbital_container
@onready var poison_dot = preload("res://Characters/Player/DOTs/poison.tscn")
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
	lifespan = $Timer
	#print(inner.position)
	
	anim_player.speed_scale = timescale

func _process(_delta):
	if player == null:
		return
	#var player_position = player.global_position
	var player_dist = position.distance_to(player.global_position)
#	print("player global = ", player.global_position)
#	print("self global = ", position)
	
		#get rings distance at start of frame
	ri_dist = global_position.distance_to(ri.global_position)
	ro_dist = global_position.distance_to(ro.global_position)
	
	#print(ri_dist)
	
	#player is in ring
	if (player_dist < ro_dist && player_dist > ri_dist):
		#print("player should take damage")
		if player.is_damageable:
			player.take_damage(damage)

	#check if any enemies in the enemy container
	enemy_container = get_tree().get_first_node_in_group("enemy_container")
	dmg_children(enemy_container)
	
	if !has_started:
		has_started = true
		anim_player.play("expanding_wave_2")
		lifespan.wait_time = 5 / anim_player.speed_scale
		lifespan.start()
		
func dmg_children(enemy_array):
	if enemy_array.get_child_count() == 0 || enemy_array.get_child(0) == null:
		return
		
	if enemy_array.get_child(0).get_child_count() == 0:
		return
		
	#getting CHILDREN OF THE WAVE
	for i in enemy_array.get_child(0).get_children():
		#step through the orbital transform
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
								if x.is_in_group("poison_DOT"):
									poisoned = true
									x.restart_timer()
							if !poisoned:
								var poison = poison_dot.instantiate()
								j.add_child(poison)
							
		if i.is_in_group("matroyshka_container"):
			if i.get_child_count() != 0:
				for j in i.get_children():
					var enemy_position = j.global_position
					var enemy_dist = position.distance_to(enemy_position)
			
					if ((enemy_dist < ro_dist && enemy_dist > ri_dist) || enemy_dist == 0):
						if j not in enemies_that_have_been_damaged:
							j.take_damage(damage)
							var poisoned = false
							for x in j.get_children():
								if x.is_in_group("poison_DOT"):
									poisoned = true
									x.restart_timer()
							if !poisoned:
								var poison = poison_dot.instantiate()
								j.add_child(poison)
						
		#otherwise, just step through normal enemies	
		elif i.is_in_group("enemies"):
			#var enemy = i
			var enemy_position = i.global_position
			var enemy_dist = position.distance_to(enemy_position)
			
			if ((enemy_dist < ro_dist && enemy_dist > ri_dist) || enemy_dist == 0):
				if i not in enemies_that_have_been_damaged:
					i.take_damage(damage)
					var poisoned = false
					for x in i.get_children():
						if x.is_in_group("poison_DOT"):
							poisoned = true
							x.restart_timer()
					if !poisoned:
						var poison = poison_dot.instantiate()
						i.add_child(poison)
