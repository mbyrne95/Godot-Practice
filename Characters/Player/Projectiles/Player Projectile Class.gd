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
var scorch_applies_radiant = false

var proptosis = false

@onready var ipecac_aoe = preload("res://Characters/Player/Projectiles/ipecac/ipecac_aoe.tscn")
@onready var poison_dot = preload("res://Characters/Player/DOTs/poison.tscn")
var ipecac = false

var current_scale = Vector2(1,1)

var hatchling_upgrade = false
var spawn_hatchling = false
@onready var hatchling_scene = preload("res://Characters/Player/DOTs/hatchling.tscn")
var apply_unravel = false

enum bullet_color_states{
	default,
	scorch,
	poison
}
var bullet_color_array = []

var bullet_color = bullet_color_states.default

var color_array_index = 0

func _ready():
	if scorch_shot:
		#bullet_color = bullet_color_states.scorch
		bullet_color_array.append(bullet_color_states.scorch)
	if ipecac:
		#bullet_color = bullet_color_states.poison
		bullet_color_array.append(bullet_color_states.poison)
	
	if bullet_color_array.size() < 1:
		print("default color")
		glow.modulate = Color("5fcde4")
	elif bullet_color_array.size() == 1:
		print("one color")
		if bullet_color_array[0] == bullet_color_states.scorch:
			glow.modulate = Color("df7126")
		elif bullet_color_array[0] == bullet_color_states.poison:
			glow.modulate = Color("99e550")
	elif bullet_color_array.size() > 1:
		print("cycling")
		cycle_colors()
	
	
#	match bullet_color:
#		bullet_color_states.default:
#			glow.modulate = Color("5fcde4")
#		bullet_color_states.scorch:
#			glow.modulate = Color("df7126")
#		bullet_color_states.poison:
#			glow.modulate = Color("99e550")

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
			if hatchling_upgrade:
				Globs.hatchling_target.emit(null)
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
	glow.scale.x = clamp(current_scale.x, 0.0, 1.0)
	glow.scale.y = clamp(current_scale.y, 0.0, 1.0)
	collision.scale = current_scale
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
	
func _on_body_entered(body):
	if body.is_in_group("enemies"):

		body.take_damage(current_damage)
		
		if hatchling_upgrade:
			Globs.hatchling_target.emit(body)
			
		if spawn_hatchling:
			#print("should spawn hatchling")
			call_deferred("spawn_hatch")
		
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
					i.apply_radiant = scorch_applies_radiant
					i.num_stacks += 1
					i.restart_timer()
			if !has_scorch:
				var x = scorch_dot.instantiate()
				x.apply_radiant = scorch_applies_radiant
				body.add_child(x)
		
		if ipecac:
			call_deferred("start_explo")
		else:
			call_deferred("start_death")
				
	elif body.is_in_group("level_bounds"):
		if hatchling_upgrade:
			Globs.hatchling_target.emit(null)
			
		if ipecac:
			call_deferred("start_explo")
		else:
			call_deferred("start_death")

func spawn_hatch():
	var hatch = hatchling_scene.instantiate()
	
	hatch.unravel = apply_unravel
	
	hatch.global_position = Vector2(global_position.x + randf_range(4,7), global_position.y + randf_range(4,7))
	get_tree().get_first_node_in_group("projectile_container").add_child(hatch)
	Globs.hatchling_spawned.emit()

func cycle_colors():
	var time_to_trans = 0.5 / bullet_color_array.size()
	var color
	if bullet_color_array[color_array_index] == bullet_color_states.scorch:
		color = Color("df7126")
	elif bullet_color_array[color_array_index] == bullet_color_states.poison:
		color = Color("99e550")
		
		
	print("tweening color")
	
	var tween = create_tween()
	tween.tween_property(glow, "modulate", color, time_to_trans)
	
	color_array_index += 1
	
	if color_array_index == bullet_color_array.size():
		color_array_index = 0
		
	await tween.finished
	cycle_colors()
		
#func _on_area_entered(area):
#	if area.is_in_group("level_bounds"):
#		call_deferred("start_death")
