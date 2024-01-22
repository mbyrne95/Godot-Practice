extends Node2D

@onready var projectile_scene = preload("res://Characters/Player/Projectiles/ability_projectile.tscn")
@onready var ability_muz = $"../muzzle_ability"
var projectile_container

@onready var projectile_damage = 20
@onready var projectile_speed = 200

@export var _cd = 15.0
var ready_to_use : = true
@onready var cooldown_timer = $Timer

var max_charges : float = 2.0
var num_charges : float = 2.0

enum abilities {
	shoot_modded_projectile,
}
var ability_state = abilities.shoot_modded_projectile

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
			if ready_to_use:
				ready_to_use = false
				
				match ability_state:
					abilities.shoot_modded_projectile:
						_shoot_modified_projectile()
				cooldown_timer.start(_cd)

func _shoot_modified_projectile():
	var projectile = projectile_scene.instantiate()
	#projectile_init(projectile)
	projectile.global_position = ability_muz.global_position
	projectile.rotation = ability_muz.global_rotation	
	projectile_container.add_child(projectile)

func _on_timer_timeout():
	ready_to_use = true
	
func projectile_init(projectile):
	pass
