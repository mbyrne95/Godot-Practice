extends Node2D

var enemies_in_range = []
var damage = 10
var has_ticked = false
var tick_cd = 0.75

var size = 1.63

var parent

var apply_jolt = false

@onready var sprite = $Sprite2D
@onready var collision = $Area2D

var jolt_dot = preload("res://Characters/Player/DOTs/jolt.tscn")
var jolt_trace = false

func _ready():
	parent = get_parent()
	parent.aura_upgrade.connect(increase_size)
	parent.aura_jolt.connect(apply_jolt_init)
	parent.aura_ionic_trace.connect(spawn_traces)

func _process(_delta):
	if !has_ticked:
		tick_rate()
		
func tick_rate():
	has_ticked = true
	if enemies_in_range == null:
		return
		
	for i in enemies_in_range:
		i.take_damage(damage)
		if apply_jolt:
			var i_has_jolt = false
			for j in i.get_children():
				if j.is_in_group("jolt_DOT"):
					i_has_jolt = true
					j.restart_timer()
			if !i_has_jolt:
				var jolt = jolt_dot.instantiate()
				jolt.spawn_traces = jolt_trace
				i.add_child(jolt)
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

func apply_jolt_init():
	apply_jolt = true
	
func spawn_traces():
	jolt_trace = true
