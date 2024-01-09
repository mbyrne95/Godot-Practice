extends Node2D

var has_started = false
var player_safe = false
var player_in_damage = false
@onready var ri = $inner
@onready var ro = $outer
@onready var anim_player = $AnimationPlayer

func _ready():
	$ColorRect.position = global_position - Vector2(160,160)

func _physics_process(_delta):		
	var player_position = get_tree().get_first_node_in_group("players").global_position
	var dist = global_position.distance_to(player_position) 
	var ri_dist = global_position.distance_to(ri.global_position)
	var ro_dist = global_position.distance_to(ro.global_position)
	
	if (dist < ro_dist && dist > ri_dist):
		if get_tree().get_first_node_in_group("players").is_damageable:
			get_tree().get_first_node_in_group("players").take_damage(50)
	
		
#	if player_in_damage && !player_safe:
#		if get_tree().get_first_node_in_group("players").is_damageable:
#			get_tree().get_first_node_in_group("players").take_damage(50)

	if !has_started:
		anim_player.play("expanding_wave_2")
		await get_tree().create_timer(5 / anim_player.speed_scale).timeout
		anim_player.play("RESET")
		queue_free()
#
#func _on_dmg_area_entered(area):
#	if get_tree().get_first_node_in_group("players") == null:
#		return
#	if area.is_in_group("player_hurtbox"):
#		print("entered dmg area")
#		player_in_damage = true
#
#
#func _on_dmg_area_exited(area):
#	if get_tree().get_first_node_in_group("players") == null:
#		return
#	if area.is_in_group("player_hurtbox"):
#		print("exited dmg area")
#		player_in_damage = false
#
#
#func _on_safe_area_entered(area):
#	if get_tree().get_first_node_in_group("players") == null:
#		return
#	if area.is_in_group("player_hurtbox"):
#		print("entered safe area")
#		player_safe = true
#		#player_in_damage = false
#
#func _on_safe_area_exited(area):
#	if get_tree().get_first_node_in_group("players") == null:
#		return
#	if area.is_in_group("player_hurtbox"):
#		print("exited safe area")
#		player_safe = false
