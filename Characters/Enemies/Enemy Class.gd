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
var contact_damage = 0
var allowed_to_move = false

@export var SPEED = 200
@export var HEALTH = 100
@export var move_delay = 2

@export var SHOOT_OFFSET = 20
@export var SHOOT_CD = 0.3
var shoot_on_cd : = false

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
		shoot(projectile)
		await get_tree().create_timer(SHOOT_CD).timeout
		shoot_on_cd = false

func _physics_process(_delta):
	pass

func follow_player_movement():
	if player == null:
		pass
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
	
func take_damage(amount : int):
	print(amount)
	hit_flash_player.play("hit_red")
	HEALTH -= amount
	if (HEALTH <= 0):
		Globs.child_of_wave_died.emit()
		queue_free()

func _connect_allowed_to_move():
	allowed_to_move = true

func _on_hitbox_area_entered(area):
	if allowed_to_move:
		if area.is_in_group("player_hurtbox"):
			if player.is_damageable:
				player.take_damage(contact_damage)
