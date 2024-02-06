extends Node2D

@onready var witherhoard_hitbox = $witherhoard_hitbox/CollisionShape2D
var enemies_in_range = []
var tick_damage = 10
var has_ticked = false
var tick_cd = 0.75
@onready var witherhoard_sprite = $witherhoard_sprite
var witherhoard_time = 8.0
@onready var lifetime = $Timer
@onready var tick_timer = $ticket_timer

var unravel_scene = preload("res://Characters/Player/DOTs/unravel.tscn")
var scorch_scene = preload("res://Characters/Player/DOTs/scorch.tscn")
var poison_scene = preload("res://Characters/Player/DOTs/poison.tscn")
var jolt_scene = preload("res://Characters/Player/DOTs/jolt.tscn")

var player
var player_weapon

var apply_unravel = false
var apply_scorch = false
var apply_poison = false
var apply_jolt = false

func _ready():
	player = get_tree().get_first_node_in_group("players")
	player_weapon = player.find_child("Weapon")
	apply_unravel = player_weapon.apply_unravel
	apply_scorch = player_weapon.scorch_shot
	apply_poison = player_weapon.ipecac
	if (player.find_child("player_aura") != null):
		apply_jolt = player.find_child("player_aura").apply_jolt
		
	print(player.find_child("player_aura"))
	
	lifetime.wait_time = witherhoard_time
	lifetime.start()
	
func _process(_delta):
	if !has_ticked:
		tick_rate()

func tick_rate():
	has_ticked = true
	if enemies_in_range == null:
		return
	for in_range in enemies_in_range:
		in_range.take_damage(tick_damage)
		
		var has_scorch = false
		var poisoned = false
		var has_unravel = false
		var has_jolt = false
		
		for i in in_range.get_children():
			if apply_scorch:
				if i.is_in_group("scorch_DOT"):
					has_scorch = true
					i.num_stacks += 1
					i.restart_timer()
			if apply_poison:
				if i.is_in_group("poison_DOT"):
					poisoned = true
					i.restart_timer()
			if apply_unravel:
				if i.is_in_group("unravel_DOT"):
					has_unravel = true
					i.restart_timer()
			if apply_jolt:
				if i.is_in_group("jolt_DOT"):
					has_jolt = true
					i.restart_timer()
					
		if apply_jolt && !has_jolt:
			var jolt = jolt_scene.instantiate()
			in_range.add_child(jolt)
		if apply_unravel && !has_unravel:
			var dot = unravel_scene.instantiate()
			in_range.add_child(dot)
		if apply_scorch && !has_scorch:
			var x = scorch_scene.instantiate()
			in_range.add_child(x)
		if apply_poison&& !poisoned:
			var poison = poison_scene.instantiate()
			in_range.add_child(poison)


	tick_timer.wait_time = tick_cd
	tick_timer.start()
	
func _on_witherhoard_hitbox_body_entered(body):
	if body.is_in_group("enemies"):
		enemies_in_range.append(body)

func _on_witherhoard_hitbox_body_exited(body):
	if body.is_in_group("enemies"):
		enemies_in_range.erase(body)

func _on_timer_timeout():
	queue_free()


func _on_ticket_timer_timeout():
	has_ticked = false
