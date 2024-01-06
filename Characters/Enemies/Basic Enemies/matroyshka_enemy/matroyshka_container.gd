extends Node2D

var matroyshka = preload("res://Characters/Enemies/Basic Enemies/matroyshka_enemy/matroyshka.tscn")
var spawned_first = false

func _process(_delta):
	if !spawned_first:
		spawned_first = true
		var enemy = matroyshka.instantiate()
		self.add_child(enemy)
		
	if self.get_child_count() == 0:
		queue_free()
