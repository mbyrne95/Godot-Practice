extends Camera2D

var intensity : float = 0
var default_offset : Vector2 = offset
var pos_x
var pos_y
var zoom_amount = 2.5

@onready var timer : Timer = %ShakeTimer

func _ready():
	Globs.camera_shake.connect(shake)
	Globs.camera_death_zoom.connect(death_zoom)
	set_process(false)
	randomize()
	
func _process (_delta):
	var shake_vector = Vector2(randf_range(-1, 1) * intensity, randf_range(-1, 1) * intensity)
	var tween = create_tween()
	tween.tween_property(self, "offset", shake_vector, 0.1)
	
func shake(time, shake_intensity):
	set_process(true)
	timer.wait_time = time
	intensity = shake_intensity
	timer.start()
	
func _on_timer_timeout():
	set_process(false)
	var tween = create_tween()
	tween.tween_property(self, "offset", default_offset, 0.1)

func death_zoom(player_position):
	global_position = player_position
	zoom = Vector2(zoom_amount, zoom_amount)
	#print(zoom)
