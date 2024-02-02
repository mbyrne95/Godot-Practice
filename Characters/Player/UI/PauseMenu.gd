extends Control

signal pause_signal()

func _on_resume_pressed():
	pause_signal.emit()

func _on_quit_pressed():
	get_tree().quit()

func _on_restart_pressed():
	pass
