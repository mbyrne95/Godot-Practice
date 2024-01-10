extends Node2D
class_name aoe_dmg

var has_started = false
var player_safe = false
var player_in_damage = false
@onready var ri = $inner
@onready var ro = $outer
@onready var anim_player = $AnimationPlayer
var damage = 20
var outer_color
var inner_color
var outer
var inner
var timescale = 1



func _ready():
	inner = $ColorRect2
	outer = $ColorRect
	#ring_scale = scale 
	outer_color = Vector4(1,0,0,1)
	#outer.material.set_shader_param("Color",outer_color)
	outer.position = global_position - Vector2(160,160)
	outer.scale = scale
	
	inner_color = Vector4(0.9,0.7,0.9,1)
	#inner.material.set_shader_param("Color",inner_color)
	inner.position = global_position - Vector2(160,160)
	inner.scale = scale
	
	anim_player.speed_scale = timescale

func _physics_process(_delta):		
	var player_position = get_tree().get_first_node_in_group("players").global_position
	var dist = global_position.distance_to(player_position) 
	var ri_dist = global_position.distance_to(ri.global_position)
	var ro_dist = global_position.distance_to(ro.global_position)
	
	if (dist < ro_dist && dist > ri_dist):
		if get_tree().get_first_node_in_group("players").is_damageable:
			get_tree().get_first_node_in_group("players").take_damage(damage)

	if !has_started:
		anim_player.play("expanding_wave_2")
		await get_tree().create_timer(5 / anim_player.speed_scale).timeout
		anim_player.play("RESET")
		queue_free()
