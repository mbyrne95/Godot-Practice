class_name player_projectileclass

extends Area2D

var SPEED
var DAMAGE
var current_damage
@onready var sprite
@onready var glow
@onready var collision
@onready var emitter
var BULLET_RANGE
var SIZE_MULTIPLIER
var is_dead = false

func _physics_process(delta):
	var player_position = get_tree().get_first_node_in_group("players").position
	var distance_x = player_position.x - position.x
	var distance_y = player_position.y - position.y
	var distance_from_player = sqrt((distance_x * distance_x) + (distance_y * distance_y))
	
	if (distance_from_player < BULLET_RANGE):
		var motion = Vector2(cos(self.global_rotation), sin(self.global_rotation)) * SPEED
		position += motion * delta
			
	else:
		if !is_dead:
			call_deferred("start_death")

func start_death():
	is_dead = true
	emitter.emitting = true
	collision.disabled = true
	sprite.visible = false
	glow.visible = false
	await get_tree().create_timer(emitter.lifetime).timeout
	queue_free()
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func _on_body_entered(body):
	if body.is_in_group("enemies"):
		call_deferred("start_death")
		body.take_damage(current_damage)
