extends Node2D

var ready_to_flash = true
#signal blinkReady()
#signal blinkProgress(progress)
@onready var blink_timer = %blink_timer
@onready var cooldown_timer = $Timer

var max_charges : float = 2.0
var num_charges : float = 2.0

var _cd = 5.0

func _ready():
	cooldown_timer.wait_time = _cd

func _process(_delta):
	if cooldown_timer.is_stopped():
		Globs.blinkProgress.emit(num_charges / max_charges)
	else:
		Globs.blinkProgress.emit((num_charges / max_charges) + ((1 - (cooldown_timer.get_time_left() / _cd)) / max_charges ))
	
func is_ready():
	if num_charges > 0:
		return ready_to_flash
	else:
		return false
	
func start_cooldown():
	num_charges  = clamp((num_charges - 1), 0, max_charges)
	if cooldown_timer.is_stopped():
		cooldown_timer_init()
	ready_to_flash = false
	blink_timer.start(0.25)

func time_remaining():
	return blink_timer.get_time_left()

func get_total_time():
	return blink_timer.get_wait_time()

func _on_timer_timeout():
	#dnum_charges = clamp((num_charges + 1), 0, max_charges)
	if num_charges < 2:
		num_charges += 1
		cooldown_timer_init()

func _on_blink_timer_timeout():
	ready_to_flash = true
	
func cooldown_timer_init():
	cooldown_timer.wait_time = _cd
	cooldown_timer.start()
