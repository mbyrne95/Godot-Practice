extends Area2D

var velocity = 50
@export var damage = 25
var time = 0
var frequency = 20
var amplitude = 150
var _green = false

@onready var color_green = $color_green
@onready var color_red = $color_red

func _ready():
	if _green:
		color_red.visible = false
		color_green.visible = true

func _process(delta):
	time += delta
	var motion = Vector2(cos(self.rotation), sin(self.rotation)) * velocity
	motion.x += cos(time * frequency)*amplitude
	position += motion * delta
	#position.x += sin(delta * 2) * 80
	#position += transform.x * velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area.is_in_group("player_hurtbox"):
		if area.get_parent().is_damageable:
			area.get_parent().take_damage(damage)
			queue_free()
