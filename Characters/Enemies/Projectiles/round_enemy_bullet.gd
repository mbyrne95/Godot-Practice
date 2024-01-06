extends Area2D

var velocity = 150
@export var damage = 25

func _ready():
	pass
	#self.body_entered.connect(_on_body_entered)

func _process(delta):
	var motion = Vector2(cos(self.rotation), sin(self.rotation)) * velocity
	position += motion * delta
	#position += transform.x * velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_exited(area):
	if area.is_in_group("player_hurtbox"):
		area.get_parent().take_damage(damage)
		queue_free()
