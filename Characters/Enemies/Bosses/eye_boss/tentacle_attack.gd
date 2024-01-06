extends Area2D

@export var damage = 25
@export var speed = 2
@export var time_on_screen = 2
var has_started = false
@onready var warning_player = $"Warning Player"
var height_target = 13
@onready var collision = $CollisionShape2D

func _ready():
	collision.disabled = true
	warning_player.play("warning flash")
	$AnimationPlayer.play("arm_thrust_sprite_only")
	await get_tree().create_timer(1.12).timeout
	collision.disabled = false
	await get_tree().create_timer(1.88).timeout
	collision.disabled = false
	await get_tree().create_timer(0.3).timeout
	queue_free()

func _process(_delta):
	pass
	
func _on_body_entered(body):
	if body.is_in_group("players"):
		body.take_damage(damage)
