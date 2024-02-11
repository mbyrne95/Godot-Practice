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
var player
var lifespan

func _ready():
	player = get_tree().get_first_node_in_group("players")
	inner = $CanvasLayer/ColorRect2
	outer = $CanvasLayer/ColorRect
	#ring_scale = scale 
	outer_color = Vector4(1,0,0,1)
	outer.material.set_shader_parameter("Color",outer_color)
	outer.position = global_position - Vector2(160,160)
	outer.scale = scale
	
	inner_color = Vector4(0.9,0.7,0.9,1)
	inner.material.set_shader_parameter("Color",inner_color)
	inner.position = global_position - Vector2(160,160)
	inner.scale = scale
	
	lifespan = $lifespan
	
	anim_player.speed_scale = timescale
	
	#_tweens()

func _process(_delta):
	if player == null:
		return
		
	var player_position = get_tree().get_first_node_in_group("players").global_position
	var dist = global_position.distance_to(player_position) 
	var ri_dist = global_position.distance_to(ri.global_position)
	var ro_dist = global_position.distance_to(ro.global_position)
	
	if (dist < ro_dist && dist > ri_dist):
		if get_tree().get_first_node_in_group("players").is_damageable:
			get_tree().get_first_node_in_group("players").take_damage(damage)

	if !has_started:
		has_started = true

		anim_player.play("expanding_wave_2")
		lifespan.wait_time = 5.0 / anim_player.speed_scale
		lifespan.start()

		
		
func _tweens():
	#TWEENS THAT START AT 0
	var outer_diameter = create_tween()
	outer_diameter.tween_method(outer_diameter_tween, 0, 1, 5)
	
	var ro_tween = create_tween()
	ro_tween.tween_property(ro, "position", Vector2(16.08,0), 0.5)
	
	var inner_diameter = create_tween()
	inner_diameter.tween_method(inner_diameter_tween, 0, 0.09, 0.5)
	
	#TWEENS THAT START AT 0.5
	await get_tree().create_timer(0.5).timeout
	
	var ro_tween_2 = create_tween()
	ro_tween_2.tween_property(ro, "position", Vector2(160.1,0), 4.5)
	
	var ri_tween = create_tween()
	ri_tween.tween_property(ri, "position", Vector2(127.769,0), 4.0)
	
	var inner_diameter_2 = create_tween()
	inner_diameter_2.tween_method(inner_diameter_tween, 0.09, 0.11, 0.1)
	
	#TWEEN THAT STARTS AT 0.6
	await get_tree().create_timer(0.1).timeout
	
	var inner_diameter_3 = create_tween()
	inner_diameter_3.tween_method(inner_diameter_tween, 0.11, 0.89, 3.9)
	
	#TWEENS THAT START AT 4.5
	await get_tree().create_timer(3.9).timeout
	
	var outer_thickness = create_tween()
	outer_thickness.tween_method(outer_thickness_tween, 0.05, 0, 0.5)
	
	var ri_tween_2 = create_tween()
	ri_tween_2.tween_property(ri, "position", Vector2(160.1,0), 0.5)
	
	var inner_thickness = create_tween()
	inner_thickness.tween_method(inner_thickness_tween, 0.04, 0, 0.5)
	
	var inner_diameter_4 = create_tween()
	inner_diameter_4.tween_method(inner_diameter_tween, 0.89, 1.0, 0.5)
	
func outer_diameter_tween(value):
	outer.material.set_shader_parameter("diameter", value)
	
func outer_thickness_tween(value):
	outer.material.set_shader_parameter("thickness", value)

func inner_diameter_tween(value):
	inner.material.set_shader_parameter("diameter", value)
	
func inner_thickness_tween(value):
	inner.material.set_shader_parameter("thickness", value)


func _on_lifespan_timeout():
	anim_player.play("RESET")
	queue_free()
