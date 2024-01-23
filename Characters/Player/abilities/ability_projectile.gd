extends player_projectileclass

func _ready():
	SPEED = 700
	DAMAGE = 100
	sprite = $Sprite2D
	BULLET_RANGE = 150
	player = get_tree().get_first_node_in_group("players")
	glow = $Sprite2D2
	collision = $CollisionShape2D
	emitter = $projectile_death
	current_damage = DAMAGE
