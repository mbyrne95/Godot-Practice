extends Area2D

@export var damage = 50
@export var time_on_screen = 2
@export var warning_laser_screentime = 1
@onready var warning_laser = $warning_laser
@onready var collision = $CollisionShape2D
@onready var sprite = $Sprite2D

func _process(_delta):
	#collision.disabled = true
	warning_laser.visible = true
	#sprite.visible = false
	await get_tree().create_timer(warning_laser_screentime).timeout
	sprite.visible = true
	collision.disabled = false
	warning_laser.visible = false
	
	await get_tree().create_timer(time_on_screen).timeout
	
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("players"):
		body.take_damage(damage)
		#queue_free()
