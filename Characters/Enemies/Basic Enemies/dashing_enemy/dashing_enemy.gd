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
var shockwave = preload("res://Characters/Enemies/Bosses/eye_boss/aoe_practice.tscn")

func _ready():
	sprite = $Sprite2D
	contact_damage = 30
	Globs.children_allowed_to_move.connect(_connect_allowed_to_move)
	self.add_to_group("enemies")
	muzzle = $Muzzle
	hit_flash_player = $HitFlashPlayer
	projectile_scene = preload("res://Characters/Enemies/Basic Enemies/Practice Enemies/basic_enemy/generic_enemy_bullet.tscn")


func _physics_process(_delta):
	if allowed_to_move:
		if player != null:
			look_at(player.global_position)
	#		if check_for_bounds:
	#			out_of_bounds()
			
			if !target_acquired:
				target_acquired = true
				get_target_position()
				
			dash_at_player()

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
	shockwave_init()
	velocity = Vector2.ZERO
	move_and_slide()
	check_for_bounds = false
	can_dash = false
	await get_tree().create_timer(time_between_dashes).timeout
	can_dash = true
	target_acquired = false
	await get_tree().create_timer(0.02).timeout
	check_for_bounds = true

func shockwave_init():
	var x = shockwave.instantiate()
	x.global_position = global_position
	projectile_container.call_deferred("add_child", x)
	#x.get_node_or_null("ColorRect").scale = Vector2(0.4, 0.4)
	x.timescale = 4
	x.scale = Vector2(0.4, 0.4)
	x.damage = contact_damage
	
func _on_hitbox_body_entered(body):
	if allowed_to_move:
		if body.is_in_group("level_bounds"):
			Globs.camera_shake.emit(0.3, 4.5)
			logic()
