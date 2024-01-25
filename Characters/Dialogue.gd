extends Node2D

var messages = []

var typing_speed = 0.1
var read_time = 2

var current_message = 0
var display = ""
var current_char = 0

@onready var next_char_timer = $next_char
@onready var next_message = $next_message
@onready var label = $Label

func _process(_delta):
	print(global_position)
	
func start_dialogue():
	current_message = 0
	display = ""
	current_char = 0
	
	next_char_timer.set_wait_time(typing_speed)
	next_char_timer.start()
	
func stop_dialogue():
	queue_free()

func _on_next_char_timeout():
	if current_char < len(messages[current_message]) :
		var next_char = messages[current_message][current_char]
		display += next_char
		
		label.text = display
		current_char += 1
	else:
		next_char_timer.stop()
		next_message.one_shot = true
		next_message.set_wait_time(read_time)
		next_message.start()

func _on_next_message_timeout():
	if current_message == len(messages) - 1:
		stop_dialogue()
	else:
		current_message += 1
		display = ""
		current_char = 0
		next_char_timer.start()
