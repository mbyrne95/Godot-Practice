extends enemy_baseclass

var can_dash = false
var player_position_initialized = false
var offset = 10
var viewport_size_x
var viewport_size_y
var out_of_bounds = true
var has_entered_arena = false
var player_position
@onready var rigid_body = $RigidBody2D

func _ready():
	self.add_to_group("enemies")
	muzzle = $Muzzle
	hit_flash_player = $HitFlashPlayer
	projectile_scene = preload("res://Characters/Enemies/Basic Enemies/Practice Enemies/basic_enemy/generic_enemy_bullet.tscn")
	height = get_tree().get_first_node_in_group("spawn_points").get_node_or_null("height")
	viewport_size_x = get_viewport_rect().size.x
	viewport_size_y = get_viewport_rect().size.y

func _physics_process(_delta):
	if ((global_position.x < offset) || 
	(global_position.x > viewport_size_x - offset) ||
	(global_position.y < offset) || 
	(global_position.y > viewport_size_y - offset)):
		out_of_bounds = true
		follow_player_movement()
		if (has_entered_arena):
			can_dash = true
	else:
		has_entered_arena = true
		out_of_bounds = false

func get_target_position():
	target_position = (global_position - player.global_position).normalized()

#func dash_at_player(delta):
#	if can_dash && !out_of_bounds:
##		if !player_position_initialized:
##			get_player_position()
##			player_position_initialized = true
#		velocity = Vector2(SPEED,SPEED)
#		print(velocity)
#
#func rigidbody_dash():
#	if can_dash:
#		can_dash = false
#		if !player_position_initialized:
#			player_position_initialized = true
#		rigid_body.apply_impulse(Vector2(SPEED,SPEED))
