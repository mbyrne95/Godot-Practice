extends player_projectileclass

func _ready():
	sprite = $Sprite2D
	glow = $Sprite2D2
	collision = $CollisionShape2D
	emitter = $projectile_death
	current_damage = DAMAGE
	player = get_tree().get_first_node_in_group("players")
