extends aoe_dmg

@onready var enemy_container
var enemies_on_screen = []
@onready var orbital_container

var ri_dist
var ro_dist 

func _ready():
	print(global_position)
	has_started = false
	outer = $ColorRect
	inner = $ColorRect2
	#print("ring started")
	#ring_scale = scale 
	outer_color = Vector4(1,0,0,1)
	#outer.material.set_shader_param("Color",outer_color)
	outer.global_position = global_position - Vector2(160,160)
	outer.scale = scale
	
	inner_color = Vector4(0.9,0.7,0.9,1)
	#inner.material.set_shader_param("Color",inner_color)
	inner.global_position = global_position - Vector2(160,160)
	inner.scale = scale
	
	#print(inner.position)
	
	anim_player.speed_scale = timescale

func _physics_process(_delta):
	#get rings distance at start of frame
	ri_dist = global_position.distance_to(ri.global_position)
	ro_dist = global_position.distance_to(ro.global_position)

	var player_position = get_tree().get_first_node_in_group("players").global_position
	var player_dist = global_position.distance_to(player_position) 

	#player is in ring
	if (player_dist < ro_dist && player_dist > ri_dist):
		if get_tree().get_first_node_in_group("players").is_damageable:
			get_tree().get_first_node_in_group("players").take_damage(damage)

	#check if any enemies in the enemy container
	enemy_container = get_tree().get_first_node_in_group("enemy_container")
	dmg_children(enemy_container)
	
	if !has_started:
		anim_player.play("expanding_wave_2")
		await get_tree().create_timer(5 / anim_player.speed_scale).timeout
		anim_player.play("RESET")
		queue_free()
		
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
					var enemy_dist = global_position.distance_to(enemy_position)
			
					if (enemy_dist < ro_dist && enemy_dist > ri_dist):
						j.take_damage(damage)
						
		#otherwise, just step through normal enemies	
		elif i.is_in_group("enemies"):
			#var enemy = i
			var enemy_position = i.global_position
			var enemy_dist = global_position.distance_to(enemy_position)
			
			if (enemy_dist < ro_dist && enemy_dist > ri_dist):
				i.take_damage(damage)
