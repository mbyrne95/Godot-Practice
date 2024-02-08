extends Node2D

var player
var SPEED

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
		var player_max_health = player.MAX_HEALTH
		#var player_current_health = player.current_health
		#print(player_current_health)
		player.current_health += clamp((0.08 * player_max_health), 0, player_max_health)
		#print("trace healed player: ", clamp((0.05 * player_max_health), 0, player_max_health))

		
		#print(player_current_health)

		player.healthChanged.emit(player.current_health / player_max_health)
		queue_free()
