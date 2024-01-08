extends Node2D

@onready var player = $PlayerCharacter
@onready var enemy_container = $EnemyContainer

@export var mid_speed = 3
@export var low_speed = 1.5
@export var depths_speed = 0.5


var parallax_motion = false

var current_wave

var wave_array

var first_wave = preload("res://Levels/PracticeLevel/Practice Enemy Wave/practice_wave.tscn")

var wave_array_2
var can_spawn_new_wave = true

var r = 1
var g = 1
var b = 1
var r2 = 1
var g2 = 1
var b2 = 1

signal wave_complete_signal()

func _process(delta):	

	if parallax_motion:
		$"foreground/foreground parallax".motion_offset.y -= 50 * delta
		$eyecandy/bg_eyecandy.motion_offset.y -= 50 * delta
		r -= 0.02 * delta
		g -= 0.02 * delta
		b -= 0.02 * delta
		r2 -= 0.06 * delta
		g2 -= 0.06 * delta
		b2 -= 0.06 * delta
		#var rgb = Color(r,g,b)
		$CanvasModulate.color = Color(r,g,b) 
		$foreground/CanvasModulate2.color = Color(r2,g2,b2)
		if ($backgrounds/background.offset.y > 0):
			$backgrounds/background.offset.y -= 15 * delta
	
	if(can_spawn_new_wave):
		wave_spawner()
		can_spawn_new_wave = false
	
func _ready():
	Globs.parallax_motion_stop.connect(stop_foreground_motion)
	Globs.wave_complete.connect(wave_is_complete)
	wave_array_2 = [first_wave, first_wave, first_wave]
	current_wave = 0
	
func wave_spawner():
	var new_wave = wave_array_2[current_wave].instantiate()
	enemy_container.add_child(new_wave)
	
func wave_is_complete():
	parallax_motion = true
	await get_tree().create_timer(5).timeout
	can_spawn_new_wave = true
	current_wave += 1

func stop_foreground_motion():
	parallax_motion = false
