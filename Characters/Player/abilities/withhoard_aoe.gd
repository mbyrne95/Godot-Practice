extends Node2D

@onready var witherhoard_hitbox = $witherhoard_hitbox/CollisionShape2D
var enemies_in_range = []
var tick_damage = 10
var has_ticked = false
var tick_cd = 0.75
@onready var witherhoard_sprite = $witherhoard_sprite
var witherhoard_time = 8.0
@onready var lifetime = $Timer

func _ready():
	lifetime.wait_time = witherhoard_time
	lifetime.start()
	
func _process(_delta):
	if !has_ticked:
		tick_rate()

func tick_rate():
	has_ticked = true
	if enemies_in_range == null:
		return
	for i in enemies_in_range:
		i.take_damage(tick_damage)
	await get_tree().create_timer(tick_cd).timeout
	has_ticked = false
	
func _on_witherhoard_hitbox_body_entered(body):
	if body.is_in_group("enemies"):
		enemies_in_range.append(body)

func _on_witherhoard_hitbox_body_exited(body):
	if body.is_in_group("enemies"):
		enemies_in_range.erase(body)

func _on_timer_timeout():
	queue_free()
