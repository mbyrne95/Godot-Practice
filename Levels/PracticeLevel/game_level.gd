extends Node2D

@onready var player = $PlayerCharacter
@onready var enemy_container = $EnemyContainer
var player_ready = false

@export var mid_speed = 3
@export var low_speed = 1.5
@export var depths_speed = 0.5


var parallax_motion = false

var current_wave

var wave_array

var first_wave = preload("res://Levels/PracticeLevel/Practice Enemy Wave/practice_wave.tscn")

var can_spawn_new_wave = true

var r = 1
var g = 1
var b = 1
var r2 = 1
var g2 = 1
var b2 = 1

signal wave_complete_signal()

func _process(delta):	
	if !player_ready:
		player.position.y += 25*delta
		if player.position.y > 30:
			Globs.player_can_move.emit()
			player_ready = true
			parallax_motion = true
			
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
	
	if(can_spawn_new_wave && player_ready):
		wave_spawner()
		can_spawn_new_wave = false
	
func _ready():
	Globs.parallax_motion_stop.connect(stop_foreground_motion)
	Globs.wave_complete.connect(wave_is_complete)
	wave_array = [first_wave, first_wave]
	current_wave = 0
	
func wave_spawner():
	var new_wave = wave_array[current_wave].instantiate()
	enemy_container.add_child(new_wave)
	
func wave_is_complete():
	if current_wave < wave_array.size():
		current_wave += 1
		parallax_motion = true
		await get_tree().create_timer(2).timeout
		can_spawn_new_wave = true

		if (current_wave == 2 || current_wave == 4):
			Globs.level_player.emit()

	#end of stage process		
	else:
		can_spawn_new_wave = false
		end_of_stage()

func stop_foreground_motion():
	parallax_motion = false

func end_of_stage():
	var tween_rot = create_tween()
	tween_rot.tween_property(player, "rotation", 90, 0.2)
	var tween_pos = create_tween()
	tween_pos.tween_property(player, "position", Vector2(90,300), 0.5)
