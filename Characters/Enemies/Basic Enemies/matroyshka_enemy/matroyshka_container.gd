extends Node2D

var matroyshka = preload("res://Characters/Enemies/Basic Enemies/matroyshka_enemy/matroyshka.tscn")
var spawned_first = false
var allowed_to_move
var enemy

func _ready():
	Globs.children_allowed_to_move.connect(_connect_allowed_to_move)
	enemy = matroyshka.instantiate()

func _process(_delta):
	if !spawned_first:
		spawned_first = true
		self.add_child(enemy)
		
	if self.get_child_count() == 0:
		queue_free()

func _connect_allowed_to_move():
	enemy.allowed_to_move = true
