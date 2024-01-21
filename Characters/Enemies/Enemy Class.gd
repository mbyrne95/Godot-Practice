extends CharacterBody2D

class_name enemy_baseclass

@onready var player = get_tree().get_first_node_in_group("players")
@onready var enemy_container = get_tree().get_first_node_in_group("enemy_container")
@onready var projectile_container = get_tree().get_first_node_in_group("projectile_container")
@onready var height
@onready var muzzle
@onready var projectile_scene
@onready var hit_flash_player
@onready var target_position
var sprite

var allowed_to_move = false

@export var contact_damage = 0
@export var SPEED = 200
@export var HEALTH = 100
@export var projectile_damage = 25
@export var dmg_output_ratio = 1.0
@export var dmg_taken_ratio = 1.0

@export var SHOOT_CD = 0.3
var shoot_on_cd : = false

signal enemy_took_damage(amount)

func _ready():
	pass
	#enemy_container.add_child(self)
	
func shoot(projectile):
	#projectile_shot.emit(projectile_scene, Muzzle.global_position)
	#var projectile = projectile_scene.instantiate()
	projectile_container.add_child(projectile)
	
func shoot_logic():
	if (player == null):
		return
	if !shoot_on_cd:
		shoot_on_cd = true
		var projectile = projectile_scene.instantiate()
		projectile.position = muzzle.global_position
		projectile.global_rotation = muzzle.global_rotation
		
		projectile.damage = projectile_damage * dmg_output_ratio
		
		shoot(projectile)
		await get_tree().create_timer(SHOOT_CD).timeout
		shoot_on_cd = false

func _physics_process(_delta):
	pass

func follow_player_movement():
	if player == null:
		return
	look_at(player.position)
	target_position = (player.global_position - global_position).normalized()
	velocity = target_position * SPEED
	move_and_slide()

func movement():
	pass
	
func move_to_height(delta):
	if(position.y > height.position.y):
		position.y -= SPEED * delta
		
func horizontal_only_movement():
	if(player == null):
		return
	var player_position = player.position
	target_position = (player_position - position).normalized()
	target_position = Vector2(target_position.x, 0)
	velocity = target_position * SPEED
	move_and_slide()
	
func vertical_only_movement():
	if(player == null):
		return
	var player_position = player.position
	target_position = (player_position - position).normalized()
	target_position = Vector2(0, target_position.y)
	velocity = target_position * SPEED
	move_and_slide()
	
func take_damage(amount : int):
	if allowed_to_move:
		HEALTH -= amount * dmg_taken_ratio
		sprite.material.set_shader_parameter("enabled", true)
		if (HEALTH <= 0):
			Globs.child_of_wave_died.emit()
			queue_free()
			
		enemy_took_damage.emit(amount)
		
		await get_tree().create_timer(0.1).timeout
		
		sprite.material.set_shader_parameter("enabled", false)

func get_status_effects():
	var num_status_effects = 0
	if get_child_count() != 0:
		for i in get_children():
			if i.is_in_group("status_effect"):
				num_status_effects += 1
	return num_status_effects

func _connect_allowed_to_move():
	allowed_to_move = true

func _on_hitbox_area_entered(area):
	if allowed_to_move:
		if area.is_in_group("player_hurtbox"):
			if player.is_damageable:
				player.take_damage(contact_damage * dmg_output_ratio)
