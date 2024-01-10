extends Node2D

var enemies_in_range = []
var damage = 5
var has_ticked = false
var tick_cd = 1

func _process(_delta):
	if !has_ticked:
		tick_rate()
		
func tick_rate():
	has_ticked = true
	if enemies_in_range == null:
		pass
		
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
