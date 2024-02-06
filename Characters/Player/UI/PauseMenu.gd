extends Control

signal pause_signal(deathPause)
var show_resume = true
@onready var resume = $MarginContainer/VBoxContainer/Resume
@onready var line_edit = $VBoxContainer2/LineEdit

func _process(_delta):
	if !show_resume:
		resume.visible = false

func _on_resume_pressed():
	pause_signal.emit(false)

func _on_quit_pressed():
	get_tree().quit()

func _on_restart_pressed():
	get_tree().reload_current_scene()
	pause_signal.emit(false)
	#pass

func _on_line_edit_text_submitted(new_text):
	line_edit.clear()
	if new_text == "enchiridion":
		get_tree().get_first_node_in_group("players").player_dies_to_lich = false
