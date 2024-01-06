extends Node2D

@onready var projectile_container = get_tree().get_first_node_in_group("projectile_container")
@onready var player = $PlayerCharacter
@onready var enemy_container = $EnemyContainer

var enemy_list = [
	preload("res://Characters/Enemies/Basic Enemies/Practice Enemies/basic_enemy/basic_enemy.tscn"),
	preload("res://Characters/Enemies/Basic Enemies/matroyshka_enemy/matroyshka_container.tscn"),
	preload("res://Characters/Enemies/Basic Enemies/roaming_archer/roaming_archer.tscn"),
	preload("res://Characters/Enemies/Bosses/eye_boss/boss_practice.tscn"),
	preload("res://Characters/Enemies/Basic Enemies/orbiting_enemy/orbiting_enemy.tscn")
]
	
@onready var spawn_points = get_tree().get_nodes_in_group("spawn_points")

@onready var spawn_left = $"Spawn Points/left"
@onready var spawn_mid = $"Spawn Points/mid"
@onready var spawn_right = $"Spawn Points/right"

@export var mid_speed = 3
@export var low_speed = 1.5
@export var depths_speed = 0.5

@onready var mid = $backgrounds/mid
@onready var low = $backgrounds/low
@onready var depths = $backgrounds/depths
@onready var directional = $DirectionalLight2D

@onready var parallax = $ParallaxBackground/ParallaxLayer

var current_wave
var current_wave_index = 0

var level_wave = 1

var is_current_completed = false

var wave_array

signal wave_complete_signal() 

func _process(delta):	
	
	if (mid.global_position.y != 0):
		mid.global_position.y -= delta * mid_speed
	if (low.global_position.y != 0):
		low.global_position.y -= delta * low_speed
	if (depths.global_position.y != 0):
		low.global_position.y -= delta * low_speed

	if (directional.energy < 0.65):
		directional.energy += delta * 0.005	
		
	parallax.motion_offset.y -= delta*5
	
	if(!is_current_completed):
		wave_state_tracker()
	

func _ready():
	self.wave_complete_signal.connect(wave_spawn_logic)
	var wave_0 = [ 
		[
			enemy_list[1].instantiate(),
		],
		[
			spawn_left,
		]
	]
	var wave_1 = [ 
		[
			enemy_list[0].instantiate(), 
		],
		[
			spawn_mid,
		]	
	]
	wave_array = [wave_0, wave_1]
	current_wave = wave_array[current_wave_index]
	wave_spawn_logic()

	#wave_0_begin()
	
func wave_state_tracker():
	var wave_counter = 0
	for i in range(len(current_wave[0])):
		var enemy = current_wave[0][i]
		if enemy == null:
			wave_counter += 1
			
		if wave_counter == len(current_wave[0]):
			if !is_current_completed:
				is_current_completed = true
				wave_complete_signal.emit()
				current_wave_index += 1
				current_wave = wave_array[current_wave_index]
				if current_wave_index == level_wave:
					Globs.level_player.emit()

func set_global(enemy, spawn_point):
	enemy.global_position = spawn_point.global_position

func wave_spawn_logic():
	is_current_completed = false
	await get_tree().create_timer(2).timeout
	traverse_enemy_array(current_wave)
		
func traverse_enemy_array(arr):
	for i in range(len(arr[0])):
		var enemy = arr[0][i]
		#enemy.add_to_group("enemies")
		enemy_container.add_child(enemy)
		var spawn_point = arr[1][i]
		enemy.global_position = spawn_point.global_position
