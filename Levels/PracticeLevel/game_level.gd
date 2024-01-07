extends Node2D

@onready var player = $PlayerCharacter
@onready var enemy_container = $EnemyContainer

@export var mid_speed = 3
@export var low_speed = 1.5
@export var depths_speed = 0.5

@onready var mid = $backgrounds/mid
@onready var low = $backgrounds/low
@onready var depths = $backgrounds/depths
@onready var directional = $DirectionalLight2D

@onready var parallax = $ParallaxBackground/ParallaxLayer

var current_wave

var wave_array

var first_wave = preload("res://Levels/PracticeLevel/Practice Enemy Wave/practice_wave.tscn")

var wave_array_2
var can_spawn_new_wave = true

signal wave_complete_signal()

func _process(delta):	
	#rework this later
	if (mid.global_position.y != 0):
		mid.global_position.y -= delta * mid_speed
	if (low.global_position.y != 0):
		low.global_position.y -= delta * low_speed
	if (depths.global_position.y != 0):
		low.global_position.y -= delta * low_speed
	
	if(can_spawn_new_wave):
		wave_spawner()
		can_spawn_new_wave = false
	
func _ready():
	Globs.wave_complete.connect(wave_is_complete)
	wave_array_2 = [first_wave, first_wave, first_wave]
	current_wave = 0
	
	
func wave_spawner():
	var new_wave = wave_array_2[current_wave].instantiate()
	enemy_container.add_child(new_wave)
	
func wave_is_complete():
	can_spawn_new_wave = true
	current_wave += 1
