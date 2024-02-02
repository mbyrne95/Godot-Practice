extends CharacterBody2D

var DAMAGE = 30
var SPEED = 70

var frequency = 3
var amplitude = 10
var unravel = false
var offset = 10.0

var viewport_size_x
var viewport_size_y
var target_destination

@onready var anim_player = $AnimationPlayer
@onready var anchor = $anchor
@onready var walk_destination = $anchor/walk_destination

@onready var unravel_scene = preload("res://Characters/Player/DOTs/unravel.tscn")

var searching = false

var initialized_target_loc = false
var walk = true
var first_walk = false  
var move_to_target = false

var in_range = []

var b
var new_target_pos = false

@onready var timer = $Timer

func _ready():
	#print("hatchling alive")
	timer.start()
	viewport_size_x = get_viewport_rect().size.x
	viewport_size_y = get_viewport_rect().size.y
	
func _process(delta):
	if !initialized_target_loc:
		get_target_destination()
		initialized_target_loc = true
	if walk:
		movement_logic(delta)
		
	if first_walk:
		walk = false
		initialized_target_loc = true
		if in_range.size() != 0:
			if !new_target_pos:
				get_new_target()
				new_target_pos = true
			if b == null:
				get_new_target()
				return
			target_destination = b.global_position
			look_at(b.global_position)
			position = position + (target_destination - position).normalized() * SPEED * delta
		else:
			walk = true
			initialized_target_loc = false
			first_walk = false
		
func movement_logic(delta):
	if !position_approx():
		if (position + (target_destination - position).normalized() * SPEED * delta).x < 0:
			scale.x = -1
		position = position + (target_destination - position).normalized() * SPEED * delta
	else:
		initialized_target_loc = false

func get_target_destination():
	anchor.rotation_degrees = randf_range(0, 360)
	
	#reroll the anchor rotation until the walk destination is in range
	while ((walk_destination.global_position.x < offset) || 
	(walk_destination.global_position.x > viewport_size_x - offset) ||
	(walk_destination.global_position.y < offset) || 
	(walk_destination.global_position.y > viewport_size_y - offset)):
		anchor.rotation_degrees = randf_range(0, 360)
		
	#snapshot the target destination
	target_destination = Vector2(walk_destination.global_position.x, walk_destination.global_position.y)

func position_approx():
	# in range x
	if ((abs(global_position.x) >= abs(target_destination.x - 0.5) && abs(global_position.x) <= abs(target_destination.x + 0.5)) &&
	(abs(global_position.y) >= abs(target_destination.y - 0.5) && abs(global_position.y) <= abs(target_destination.y + 0.5))):
		first_walk = true
		return true
	else:
		return false

func _on_hurtbox_body_entered(body):
	if first_walk && body.is_in_group("enemies"):
		body.take_damage(DAMAGE)
		
		if unravel:
			var has_unravel = false
			for j in body.get_children():
				if j.is_in_group("unravel_DOT"):
					has_unravel = true
					j.restart_timer()
			if !has_unravel:
				var dot = unravel_scene.instantiate()
				body.add_child(dot)
		
		queue_free()

func _on_detection_radius_body_entered(body):
	if body.is_in_group("enemies"):
		in_range.append(body)
		
func _on_timer_timeout():
	queue_free()

func get_new_target():
	b = in_range.pick_random()
