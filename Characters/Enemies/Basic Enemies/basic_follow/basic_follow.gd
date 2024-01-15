extends enemy_baseclass

var current_health
var number_of_splits = 2
var number_of_offspring= 3
var has_split = false

@onready var parent = get_parent()
@onready var collision = $CollisionShape2D
@onready var light_occluder = $LightOccluder2D

@export var shots_in_volley = 3
@export var time_between_shots = 0.15
@export var time_after_shooting = 2

var allowed_to_shoot = true

func _ready():
	sprite = $Sprite2D
	projectile_scene = preload("res://Characters/Enemies/Projectiles/round_enemy_bullet.tscn")
	Globs.children_allowed_to_move.connect(_connect_allowed_to_move)
	self.add_to_group("enemies")
	contact_damage = 20
	SPEED = 40
	current_health = HEALTH
	muzzle = $Muzzle
	hit_flash_player = $HitFlashPlayer
	
func _process(_delta):
	#print(global_position)d
	if allowed_to_move:
		
		follow_player_movement()
		
		if allowed_to_shoot:
			archer_shoot()

func archer_shoot():
	allowed_to_shoot = false
	var i = 0
	while i < shots_in_volley:
		var projectile = projectile_scene.instantiate()
		projectile_container.add_child(projectile)
		projectile.position = muzzle.global_position
		projectile.rotation_degrees = muzzle.global_rotation_degrees + randf_range(-10, 10)
		await get_tree().create_timer(time_between_shots).timeout
		i += 1
	await get_tree().create_timer(time_after_shooting).timeout
	allowed_to_shoot = true
