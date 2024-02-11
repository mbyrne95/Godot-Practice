extends Node2D

var player
var SPEED
var amplify_scene = preload("res://Characters/Player/buffs/amplified.tscn")

func _ready():
	#print("ionic trace spawned")
	player = get_tree().get_first_node_in_group("players")
	SPEED = 0.8
	
func _process(_delta):
	if player != null:
		look_at(player.global_position)
	var target_position = (player.global_position - global_position).normalized()
	position += target_position * SPEED

func _on_timer_timeout():
	queue_free()

func _on_area_2d_area_entered(area):
	if area.is_in_group("player_hurtbox"):
		#var player_max_health = player.MAX_HEALTH
		#player.current_health += clamp((0.08 * player_max_health), 0, player_max_health)
		#player.healthChanged.emit(player.current_health / player_max_health)
		
		var amplified = false
		for i in player.get_children():
			if i.is_in_group("amplified_effect"):
				amplified = true
				i.restart_timer()
		if !amplified:
			var amplify = amplify_scene.instantiate()
			player.add_child(amplify)
		
		queue_free()
