extends enemy_baseclass

var can_dash = true
var player_position_initialized = false
var offset = 10
var time_between_dashes = 1
var start_cd = false
var check_for_bounds = true
var has_entered_arena = false
var player_position
#@onready var rigid_body = $RigidBody2D
var target_acquired = false


func _ready():
	contact_damage = 20
	Globs.children_allowed_to_move.connect(_connect_allowed_to_move)
	self.add_to_group("enemies")
	muzzle = $Muzzle
	hit_flash_player = $HitFlashPlayer
	projectile_scene = preload("res://Characters/Enemies/Basic Enemies/Practice Enemies/basic_enemy/generic_enemy_bullet.tscn")


func _physics_process(_delta):
	if allowed_to_move:
		look_at(player.global_position)
		if check_for_bounds:
			out_of_bounds()
		
		if !target_acquired:
			target_acquired = true
			get_target_position()
			
		dash_at_player()
		
		if start_cd:
			start_cd = false
			logic()

func get_target_position():
	#await get_tree().create_timer(time_between_dashes).timeout
	target_position = (player.global_position - global_position).normalized()
	
	

func dash_at_player():
	if can_dash:
		#print(target_position)
#		if !player_position_initialized:
#			get_player_position()
#			player_position_initialized = true
		velocity = target_position * SPEED
		move_and_slide()
		#print(velocity)

func logic():
	velocity = Vector2.ZERO
	move_and_slide()
	check_for_bounds = false
	can_dash = false
	await get_tree().create_timer(time_between_dashes).timeout
	can_dash = true
	target_acquired = false
	await get_tree().create_timer(0.02).timeout
	check_for_bounds = true
		
func out_of_bounds():
	if ((global_position.x <= 11 && global_position.x >= 9)  || 
	(global_position.x <= 171 && global_position.x >= 169) || 
	(global_position.y <= 11 && global_position.y >= 9) || 
	 (global_position.y <= 311 && global_position.y >= 309)):
		start_cd = true
	else: 
		pass
