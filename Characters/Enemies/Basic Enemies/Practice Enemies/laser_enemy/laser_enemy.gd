extends enemy_baseclass

var shoot_big_laser : = false
var big_laser_cd = 10
var big_laser_on_cd : = false
var is_firing_big_laser = false

func _ready():
	enemy_container.add_child(self)
	muzzle = $Muzzle
	hit_flash_player = $HitFlashPlayer
	player = get_tree().get_first_node_in_group("players")
	hit_flash_player = $HitFlashPlayer
	projectile_scene = preload("res://Characters/enemies/proto_brim.tscn")
	height = get_tree().get_first_node_in_group("spawn_points").get_node_or_null("laser_height")
	
func _physics_process(_delta):
	if(position.y > height.position.y):
		move_to_height(_delta)
	#var height_transform = spawn_points.get_child("height").global_transform.y
	else:
		if !is_firing_big_laser:
			horizontal_only_movement()
			shoot_logic()
			
func shoot_logic():
	if (player == null):
		return	
	var diff = player.position.x - position.x
	if (shoot_big_laser):
		if (abs(diff) <= SHOOT_OFFSET):
			if !big_laser_on_cd:
				big_laser_on_cd = true
				hit_flash_player.play("hit_white")
				await get_tree().create_timer(0.2).timeout
				var projectile = projectile_scene.instantiate()
				shoot(projectile)
				stop_movement_during_laser(projectile.time_on_screen + projectile.warning_laser_screentime)
				await get_tree().create_timer(big_laser_cd).timeout
				big_laser_on_cd = false

func stop_movement_during_laser(projectile_time_on_screen):
	is_firing_big_laser = true
	await get_tree().create_timer(projectile_time_on_screen).timeout
	is_firing_big_laser = false
