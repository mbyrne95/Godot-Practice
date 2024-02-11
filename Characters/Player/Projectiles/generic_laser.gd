extends player_projectileclass

func _ready():
	sprite = $Sprite2D
	glow = $Sprite2D2
	collision = $CollisionShape2D
	emitter = $projectile_death
	current_damage = DAMAGE
	player = get_tree().get_first_node_in_group("players")

#	if scorch_shot:
#		bullet_color = bullet_color_states.scorch
#	if ipecac:
#		bullet_color = bullet_color_states.poison
#
#	match bullet_color:
#		bullet_color_states.default:
#			glow.modulate = Color("5fcde4")
#		bullet_color_states.scorch:
#			glow.modulate = Color("df7126")
#		bullet_color_states.poison:
#			glow.modulate = Color("99e550")

	if scorch_shot:
		#bullet_color = bullet_color_states.scorch
		bullet_color_array.append(bullet_color_states.scorch)
	if ipecac:
		#bullet_color = bullet_color_states.poison
		bullet_color_array.append(bullet_color_states.poison)
	
	if bullet_color_array.size() < 1:
		#print("default color")
		glow.modulate = Color("5fcde4")
	elif bullet_color_array.size() == 1:
		#print("one color")
		if bullet_color_array[0] == bullet_color_states.scorch:
			glow.modulate = Color("df7126")
		elif bullet_color_array[0] == bullet_color_states.poison:
			glow.modulate = Color("99e550")
	elif bullet_color_array.size() > 1:
		#print("cycling")
		cycle_colors()
