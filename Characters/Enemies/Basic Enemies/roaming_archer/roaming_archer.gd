extends enemy_baseclass

var offset = 10
var viewport_size_x
var viewport_size_y
var walk = true
var can_shoot = false
var target_destination
var initialized_target_loc = false
@export var shots_in_volley = 5
@export var time_between_shots = 0.2
@export var time_after_shooting = 1.0
@onready var anchor = $anchor
@onready var walk_destination = $anchor/walk_destination

func _ready():
	Globs.children_allowed_to_move.connect(_connect_allowed_to_move)
	self.add_to_group("enemies")
	sprite = $Sprite2D
	muzzle = $Muzzle
	hit_flash_player = $HitFlashPlayer
	viewport_size_x = get_viewport_rect().size.x
	viewport_size_y = get_viewport_rect().size.y
	projectile_scene = preload("res://Characters/Enemies/Projectiles/round_enemy_bullet.tscn")
	SPEED = 50
	
func _process(delta):
	if allowed_to_move:
		#if outside of the arbitrary bounds we're settings
		if player == null:
			return

		look_at(player.global_position)

		if !initialized_target_loc:
			get_target_destination()
			initialized_target_loc = true
		if walk:
			movement_logic(delta)
		if can_shoot:
			archer_shoot()
			
func movement_logic(delta):
	#print(target_destination)
	if !position_approx():
		position = position + (target_destination - position).normalized() * SPEED * delta
		
	else:
		walk = false
		can_shoot = true
		initialized_target_loc = false
		
func archer_shoot():
	can_shoot = false
	var i = 0
	while i < shots_in_volley:
		var projectile = projectile_scene.instantiate()
		projectile_container.add_child(projectile)
		projectile.velocity = 300
		projectile.position = muzzle.global_position
		projectile.rotation_degrees = muzzle.global_rotation_degrees + randf_range(-10, 10)
		await get_tree().create_timer(time_between_shots).timeout
		i += 1
	await get_tree().create_timer(time_after_shooting).timeout
	walk = true
		
func get_target_destination():
	anchor.rotation_degrees = randf_range(0, 360)
	
	#reroll the anchor rotation until the walk destination is in range
	while ((walk_destination.global_position.x < offset) || 
	(walk_destination.global_position.x > viewport_size_x - offset) ||
	(walk_destination.global_position.y < offset) || 
	(walk_destination.global_position.y > viewport_size_y - offset)):
		anchor.rotation_degrees = randf_range(0, 360)
		
	#snapshot the target destination
	target_destination = Vector2(walk_destination.global_position.x, walk_destination.global_position.y)

func position_approx():
	# in range x
	if ((abs(global_position.x) >= abs(target_destination.x - 0.5) && abs(global_position.x) <= abs(target_destination.x + 0.5)) &&
	(abs(global_position.y) >= abs(target_destination.y - 0.5) && abs(global_position.y) <= abs(target_destination.y + 0.5))):
		return true
	else:
		return false
