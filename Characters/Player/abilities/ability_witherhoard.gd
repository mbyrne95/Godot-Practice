extends player_projectileclass

var witherhoard_aoe = preload("res://Characters/Player/abilities/withhoard_aoe.tscn")

func _ready():
	SPEED = 75
	DAMAGE = 25
	sprite = $Sprite2D
	BULLET_RANGE = 150
	player = get_tree().get_first_node_in_group("players")
	glow = $Sprite2D2
	collision = $CollisionShape2D
	emitter = $projectile_death
	current_damage = DAMAGE

func start_death():
	is_dead = true
	emitter.emitting = true
	collision.disabled = true
	sprite.visible = false
	glow.visible = false
	start_witherhoard()
	await get_tree().create_timer(emitter.lifetime).timeout
	queue_free()
	
func start_witherhoard():
	var x = witherhoard_aoe.instantiate()
	get_tree().get_first_node_in_group("projectile_container").add_child(x)
	x.global_position = global_position
