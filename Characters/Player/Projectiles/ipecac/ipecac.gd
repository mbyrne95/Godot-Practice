extends player_projectileclass

@onready var ipecac_aoe = preload("res://Characters/Player/Projectiles/ipecac/ipecac_aoe.tscn")


func _ready():
	player = get_tree().get_first_node_in_group("players")
	sprite = $Sprite2D
	glow = $Sprite2D2
	collision = $CollisionShape2D
	emitter = $projectile_death
	current_damage = DAMAGE

func _physics_process(delta):
	if player == null:
		return
		
	var player_position = player.position
	var distance_x = player_position.x - position.x
	var distance_y = player_position.y - position.y
	var distance_from_player = sqrt((distance_x * distance_x) + (distance_y * distance_y))
	
	if (distance_from_player < BULLET_RANGE):
		var motion = Vector2(cos(self.global_rotation), sin(self.global_rotation)) * SPEED
		position += motion * delta
			
	else:
		if !is_dead:
			call_deferred("start_explo")
			
func start_explo():
	is_dead = true
	
	var projectile = ipecac_aoe.instantiate()
	projectile.damage = DAMAGE
	projectile.scale = Vector2(0.15,0.15)
	projectile.timescale = 12
	#print(self.global_position)
	add_child(projectile)
	projectile.position = global_position
	
	collision.disabled = true
	sprite.visible = false
	glow.visible = false
	
	await get_tree().create_timer(5).timeout
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(current_damage)
		call_deferred("start_explo")
	elif body.is_in_group("level_bounds"):
		call_deferred("start_explo")

#func _on_area_entered(area):
#	if area.is_in_group("level_bounds"):
#		call_deferred("start_explo")
