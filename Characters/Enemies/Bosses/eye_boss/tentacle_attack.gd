extends Area2D

@export var damage = 25
@export var speed = 2
@export var time_on_screen = 2
var has_started = false

@onready var collision = $CollisionShape2D
@onready var laser = $Sprite2D
@onready var warning = $AnimatedSprite2D
@onready var warning_timer = $Timer

func _ready():
	warning.visible = true
	warning.play("default")
	warning_timer.wait_time = 1.0
	warning_timer.start()

#func _on_body_entered(body):
#	if body.is_in_group("players"):
#		body.take_damage(damage)

func _on_area_entered(area):
	if area.is_in_group("player_hurtbox"):
		if area.get_parent().is_damageable:
			area.get_parent().take_damage(damage)


func _on_sprite_2d_animation_finished():
	queue_free()


func _on_timer_timeout():
	warning.visible = false
	collision.disabled = false
	laser.visible = true
	laser.play("default")
