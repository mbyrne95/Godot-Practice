extends Node

var basic_projectile = preload("res://Characters/Player/Projectiles/generic_projectile.tscn")
var proptosis_projectile = preload("res://Characters/Player/Projectiles/Poly/poly_projectile.tscn")

@onready var muz_left = $"../muzzle_left"
@onready var muz_right = $"../muzzle_right"

var shot_position = 0

@export var shoot_cd = 0.25
@onready var projectile_damage = 20
@onready var projectile_speed = 200
var shoot_on_cd : = false

var crit_chance = 0
var crit_multiplier = 1.5
var damage_multiplier = 1.0
var bullet_range = 100
var size_multiplier = 1.0

var proptosis = false
#var poly_projectile = preload("res://Characters/player/poly_projectile.tscn")

@onready var projectile_container = get_tree().get_first_node_in_group("projectile_container")

func _process(_delta):
	#print(projectile_damage)
	if Input.is_action_pressed("shoot"):
		if !shoot_on_cd:
			shoot_on_cd = true
			shoot()
			await get_tree().create_timer(shoot_cd).timeout
			shoot_on_cd = false

func shoot():
	var projectile
	
	if proptosis:
		size_multiplier = 3
		projectile = proptosis_projectile.instantiate()	
	else:
		projectile = basic_projectile.instantiate()
		
	projectile.DAMAGE = projectile_damage * damage_multiplier
	projectile.SPEED = projectile_speed
	projectile.BULLET_RANGE = bullet_range
	projectile.SIZE_MULTIPLIER = size_multiplier
	
	#handle crit here?
	var x = randf_range(0, 1)
	if x <= crit_chance:
		projectile.DAMAGE = (crit_multiplier * projectile.DAMAGE) * damage_multiplier
		projectile.modulate = Color.PALE_GOLDENROD
		
	#alternate shot positions
	if shot_position == 0:
		projectile.global_position = muz_left.global_position
		projectile.rotation = muz_left.global_rotation
		shot_position = 1
	else:
		projectile.global_position = muz_right.global_position
		projectile.rotation = muz_right.global_rotation
		shot_position = 0
		
	projectile_container.add_child(projectile)
