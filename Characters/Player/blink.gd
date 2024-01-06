extends Node2D

var ready_to_flash = true
#signal blinkReady()
#signal blinkProgress(progress)
@onready var blink_timer = %blink_timer

func _process(_delta):
	if !ready_to_flash:
		Globs.blinkProgress.emit(1 - (time_remaining() / get_total_time()))
	else: 
		Globs.blinkReady.emit()

func is_ready():
	return ready_to_flash
	
func start_cooldown(dash_cd : int):
	ready_to_flash = false
	blink_timer.start(dash_cd)
	await blink_timer.timeout
	ready_to_flash = true

func time_remaining():
	return blink_timer.get_time_left()

func get_total_time():
	return blink_timer.get_wait_time()
