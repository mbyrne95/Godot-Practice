extends Node2D

@onready var projectile_scene = preload("res://Characters/Player/abilities/ability_projectile.tscn")
@onready var witherhoard_scene = preload("res://Characters/Player/abilities/ability_witherhoard.tscn")
@onready var ability_muz = $"../muzzle_ability"
var projectile_container

@onready var projectile_damage = 20
@onready var projectile_speed = 200

@export var _cd = 15.0
var ready_to_use : = true
@onready var cooldown_timer = $Timer
@onready var inbetween_timer = $inbetween_timer

var max_charges : float = 2.0
var num_charges : float = 2.0

enum abilities {
	shoot_modded_projectile,
	shoot_witherhoard,
}
var ability_state = abilities.shoot_witherhoard

func _ready():
	projectile_container = get_tree().get_first_node_in_group("projectile_container")

func _process(_delta):
	if cooldown_timer.is_stopped():
		pass
		Globs.abilityProgress.emit(num_charges / max_charges)
	else:
		pass
		Globs.abilityProgress.emit((num_charges / max_charges) + ((1 - (cooldown_timer.get_time_left() / _cd)) / max_charges ))

	
	if get_parent().can_move:
		if Input.is_action_pressed("ability"):
			if is_ready():
				match ability_state:
					abilities.shoot_modded_projectile:
						_shoot_modified_projectile()
					abilities.shoot_witherhoard:
						_shoot_witherhoard_projectile()
				start_cooldown()

func is_ready():
	if num_charges > 0:
		return ready_to_use
	else:
		return false
		
func start_cooldown():
	num_charges  = clamp((num_charges - 1), 0, max_charges)
	if cooldown_timer.is_stopped():
		cooldown_timer_init()
	ready_to_use = false
	inbetween_timer.start(0.25)

func _shoot_modified_projectile():
	var projectile = projectile_scene.instantiate()
	#projectile_init(projectile)
	projectile.global_position = ability_muz.global_position
	projectile.rotation = ability_muz.global_rotation	
	projectile_container.add_child(projectile)
	
func _shoot_witherhoard_projectile():
	var projectile = witherhoard_scene.instantiate()
	#projectile_init(projectile)
	projectile.global_position = ability_muz.global_position
	projectile.rotation = ability_muz.global_rotation	
	projectile_container.add_child(projectile)

func cooldown_timer_init():
	cooldown_timer.wait_time = _cd
	cooldown_timer.start()

func _on_timer_timeout():
	if num_charges < 2:
		num_charges += 1
		cooldown_timer_init()
	
func projectile_init(_projectile):
	pass

func _on_inbetween_timer_timeout():
	ready_to_use = true
