extends enemy_baseclass

var player_remote_transform = null

var player_position
var radius = 75
var is_orbiting = false

var can_move = true

func _ready():
	self.add_to_group("enemies")
	#enemy_container.add_child(self)
	SPEED = 100
	HEALTH = 100
	move_delay = 2
	SHOOT_OFFSET = 20
	SHOOT_CD = 0.3
	muzzle = $Muzzle
	hit_flash_player = $HitFlashPlayer
	projectile_scene = preload("res://Characters/Enemies/Projectiles/round_enemy_bullet.tscn")
	player = get_tree().get_first_node_in_group("players")

func _process(_delta):
	player_position = player.global_position

func _physics_process(_delta):
	$AnimatedSprite2D.global_rotation = 0
	if (player == null):
		pass
	if can_move:
		if (position.distance_to(player_position) <= radius):
			is_orbiting = true
		movement()
	else:
		shoot_logic()
	
	
func shoot_logic():
	if !shoot_on_cd:
		shoot_on_cd = true
		var projectile = projectile_scene.instantiate()
		projectile.velocity = 200
		projectile.position = muzzle.global_position
		projectile.global_rotation = muzzle.global_rotation
		shoot(projectile)
		await get_tree().create_timer(SHOOT_CD).timeout
		shoot_on_cd = false

func movement():
	if (!is_orbiting):
		look_at(player.position)
		player_position = player.global_position
		target_position = (player_position - position).normalized()
		velocity = target_position * SPEED
		move_and_slide()
	else:
		velocity = Vector2.ZERO
		self.reparent(get_tree().get_first_node_in_group("player_orbital_transform"))
		can_move = false
