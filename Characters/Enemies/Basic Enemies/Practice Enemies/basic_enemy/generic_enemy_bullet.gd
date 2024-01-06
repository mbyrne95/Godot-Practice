extends Area2D

var velocity = 150
@export var damage = 20

func _ready():
	pass
	#self.body_entered.connect(_on_body_entered)

func _process(delta):
	global_position.y -= velocity * delta
	
func _on_body_entered(body):
	if body.is_in_group("players"):
		body.take_damage(damage)
		queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
