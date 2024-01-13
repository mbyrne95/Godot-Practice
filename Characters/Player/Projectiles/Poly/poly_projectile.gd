extends player_projectileclass

func _ready():
	sprite = $Sprite2D
	glow = $Sprite2D2
	collision = $CollisionShape2D
	emitter = $projectile_death
	current_damage = DAMAGE

func _physics_process(delta):
	var player_position = get_tree().get_first_node_in_group("players").position
	var distance_x = player_position.x - position.x
	var distance_y = player_position.y - position.y
	var distance_from_player = sqrt((distance_x * distance_x) + (distance_y * distance_y))
	
	if (distance_from_player < BULLET_RANGE):
		var motion = Vector2(cos(self.global_rotation), sin(self.global_rotation)) * SPEED
		position += motion * delta
		
		proptosis_logic(distance_from_player)
			
	else:
		if !is_dead:
			call_deferred("start_death")
			
func proptosis_logic(distance_from_player):
	var percent_remaining = abs(BULLET_RANGE - distance_from_player) / BULLET_RANGE
	var current_scale = scale * percent_remaining
	#print(current_scale)
	current_damage = DAMAGE * (current_scale.x * 0.9)
	#print(current_damage)
	sprite.scale = current_scale
	glow.scale = current_scale
	collision.scale = current_scale
	
func start_death():
	is_dead = true
	emitter.emitting = true
	collision.disabled = true
	sprite.visible = false
	glow.visible = false
	await get_tree().create_timer(emitter.lifetime).timeout
	queue_free()
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		call_deferred("start_death")
		body.take_damage(current_damage)
