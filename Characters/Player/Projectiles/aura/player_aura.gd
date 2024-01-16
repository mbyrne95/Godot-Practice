extends Node2D

var enemies_in_range = []
var damage = 10
var has_ticked = false
var tick_cd = 0.75

var size = 1.63

var parent

@onready var sprite = $Sprite2D
@onready var collision = $Area2D

func _ready():
	parent = get_parent()
	parent.aura_upgrade.connect(increase_size)

func _process(_delta):
	if !has_ticked:
		tick_rate()
		
func tick_rate():
	has_ticked = true
	if enemies_in_range == null:
		return
		
	for i in enemies_in_range:
		i.take_damage(damage)
	await get_tree().create_timer(tick_cd).timeout
	has_ticked = false

func _on_area_2d_body_entered(body):
	if body.is_in_group("enemies"):
		enemies_in_range.append(body)
		
func _on_area_2d_body_exited(body):
	if body.is_in_group("enemies"):
		enemies_in_range.erase(body)

func increase_size():
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(2.3,2.3), 0.5)
	var col_tween = create_tween()
	col_tween.tween_property(collision, "scale", Vector2(1.45,1.45),0.5)
	tick_cd = 0.35
