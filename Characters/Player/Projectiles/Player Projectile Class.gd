class_name player_projectileclass

extends Area2D

var SPEED
var DAMAGE
var current_damage
@onready var sprite
@onready var glow
@onready var collision
@onready var emitter
var BULLET_RANGE
var is_dead = false
var player

var scorch_shot = false
var scorch_dot = preload("res://Characters/Player/DOTs/scorch.tscn")

var proptosis = false

@onready var ipecac_aoe = preload("res://Characters/Player/Projectiles/ipecac/ipecac_aoe.tscn")
@onready var poison_dot = preload("res://Characters/Player/DOTs/poison.tscn")
var ipecac = false

var current_scale = Vector2(1,1)

func _physics_process(delta):
	
	var player_position = get_tree().get_first_node_in_group("players").position
	var distance_x = player_position.x - position.x
	var distance_y = player_position.y - position.y
	var distance_from_player = sqrt((distance_x * distance_x) + (distance_y * distance_y))

	if proptosis:
		proptosis_logic(distance_from_player)
	
	if (distance_from_player < BULLET_RANGE):
		var motion = Vector2(cos(self.global_rotation), sin(self.global_rotation)) * SPEED
		position += motion * delta
	else:
		if !is_dead:
			if ipecac:
				call_deferred("start_explo")
			else:
				call_deferred("start_death")

func start_death():
	is_dead = true
	emitter.emitting = true
	collision.disabled = true
	sprite.visible = false
	glow.visible = false
	await get_tree().create_timer(emitter.lifetime).timeout
	queue_free()

func start_explo():
	is_dead = true
	
	var ipecac_boom = ipecac_aoe.instantiate()

	ipecac_boom.damage = DAMAGE
	ipecac_boom.timescale = 12
	#print(self.global_position)
	ipecac_boom.scale = Vector2(0.15,0.15) 
	ipecac_boom.position = global_position
	get_tree().get_first_node_in_group("projectile_container").add_child(ipecac_boom)
	
	
	collision.disabled = true
	sprite.visible = false
	glow.visible = false
	#await get_tree().create_timer(5).timeout
	queue_free()

func proptosis_logic(distance_from_player):
	var percent_remaining = abs(BULLET_RANGE - distance_from_player) / BULLET_RANGE
	current_scale = scale * percent_remaining
	#print(current_scale)
	current_damage = DAMAGE * (current_scale.x * 0.5)
	#print(current_damage)
	sprite.scale = current_scale
	glow.scale = current_scale
	collision.scale = current_scale
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func _on_body_entered(body):
	if body.is_in_group("enemies"):

		body.take_damage(current_damage)
		
		if ipecac:
			var poisoned = false
			for i in body.get_children():
				if i.is_in_group("poison_DOT"):
					poisoned = true
					i.restart_timer()
			if !poisoned:
				var poison = poison_dot.instantiate()
				body.add_child(poison)
		
		
		if scorch_shot:
			var has_scorch = false
			for i in body.get_children():
				if i.is_in_group("scorch_DOT"):
					has_scorch = true
					i.num_stacks += 1
					i.restart_timer()
			if !has_scorch:
				var x = scorch_dot.instantiate()
				body.add_child(x)
		
		if ipecac:
			call_deferred("start_explo")
		else:
			call_deferred("start_death")
				
	elif body.is_in_group("level_bounds"):
		if ipecac:
			call_deferred("start_explo")
		else:
			call_deferred("start_death")

#func _on_area_entered(area):
#	if area.is_in_group("level_bounds"):
#		call_deferred("start_death")
