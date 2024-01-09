extends Node2D

var matroyshka = preload("res://Characters/Enemies/Basic Enemies/matroyshka_enemy/matroyshka.tscn")
var spawned_first = false
var number_of_offspring= 2
var allowed_to_move
var enemy
var no_more_splits = false

func _ready():
	Globs.children_allowed_to_move.connect(_connect_allowed_to_move)
	enemy = matroyshka.instantiate()
	enemy.has_died.connect(spawn_children)
	enemy.contact_damage = 20
	enemy.SPEED = 50

func _process(_delta):
	if !spawned_first:
		spawned_first = true
		self.add_child(enemy)
		
#	if self.get_child_count() == 0:
#		queue_free()

	if no_more_splits:
		if self.get_child_count() == 0:
			queue_free()

func _connect_allowed_to_move():
	enemy.allowed_to_move = true
	
func spawn_children(given_enemy, given_position, number_of_splits, given_scale, given_health, given_speed):
	if (number_of_splits > 0):
		var offset = Vector2(3,3)
		for i in number_of_offspring:
			var new_enemy = matroyshka.instantiate()
			add_child(new_enemy)
			new_enemy.contact_damage = 20
			new_enemy.scale = given_scale * 0.8
			new_enemy.HEALTH = given_health / 2.5
			new_enemy.number_of_splits = number_of_splits - 1
			new_enemy.SPEED = given_speed * 1.2
			new_enemy.allowed_to_move = true
			new_enemy.global_position = given_position + offset
			offset = offset * -1
			given_enemy.queue_free()
			
	else:
		no_more_splits = true
