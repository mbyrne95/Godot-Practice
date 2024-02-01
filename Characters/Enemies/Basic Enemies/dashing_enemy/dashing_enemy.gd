extends enemy_baseclass

var can_dash = true
var player_position_initialized = false
var offset = 10
@export var time_between_dashes = 1
var start_cd = false
var check_for_bounds = true
var has_entered_arena = false
var direction
#@onready var rigid_body = $RigidBody2D
var target_acquired = false
var shockwave = preload("res://Characters/Enemies/Projectiles/aoe_practice.tscn")
var shockwave_timeout = 0.05
var shockwave_ready = true

@onready var oob_timer = $Timer

func _ready():
	sprite = $Sprite2D
	contact_damage = 30
	Globs.children_allowed_to_move.connect(_connect_allowed_to_move)
	self.add_to_group("enemies")
	muzzle = $Muzzle
	hit_flash_player = $HitFlashPlayer
	SPEED = 300
		
func _physics_process(_delta):
	if allowed_to_move:
		if player != null:
			if can_dash:	
				dash_at_player()
			move_and_slide()

func dash_at_player():
	can_dash = false
	target_position = (player.global_position - global_position).normalized()
	if (target_position.x < 0):
		scale = Vector2(-1,1)
	else:
		scale = Vector2(1,1)
	var angle_to = transform.x.angle_to(target_position)
	rotation_degrees = sin(angle_to)
	var tween = create_tween()
	tween.tween_property(self, "velocity", target_position * SPEED, 0.3).set_trans(Tween.TRANS_CUBIC)

func logic():
	if shockwave_ready:
		shockwave_init()
		velocity = Vector2.ZERO
		await get_tree().create_timer(time_between_dashes).timeout
		can_dash = true
		await get_tree().create_timer(0.02).timeout

func shockwave_init():
	var x = shockwave.instantiate()
	x.global_position = global_position
	projectile_container.call_deferred("add_child", x)
	#x.get_node_or_null("ColorRect").scale = Vector2(0.4, 0.4)
	x.timescale = 4
	x.scale = Vector2(0.4, 0.4)
	x.damage = contact_damage

func _on_hurtbox_body_entered(body):
	#print("entered")
	if allowed_to_move:
		if body.is_in_group("level_bounds"):
			oob_timer.start()
			Globs.camera_shake.emit(0.3, 4.5)
			logic()
			shockwave_ready = false
			await get_tree().create_timer(shockwave_timeout).timeout
			shockwave_ready = true

func _on_hurtbox_body_exited(body):
	if allowed_to_move:
		if body.is_in_group("level_bounds"):
			oob_timer.stop()

func _on_timer_timeout():
	oob_timer.start()
	Globs.camera_shake.emit(0.3, 4.5)
	velocity = Vector2.ZERO
	shockwave_ready = true
	logic()
