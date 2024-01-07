extends enemy_baseclass

var current_health
var matroyshka = preload("res://Characters/Enemies/Basic Enemies/matroyshka_enemy/matroyshka.tscn")
var number_of_splits = 2
var number_of_offspring= 2
var has_split = false

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var light_occluder = $LightOccluder2D

func _ready():
	self.add_to_group("enemies")
	contact_damage = 20
	SPEED = 50
	current_health = HEALTH
	muzzle = $Muzzle
	hit_flash_player = $HitFlashPlayer
	
func _process(_delta):
	if allowed_to_move:
		follow_player_movement()

func take_damage(amount : int):
	#print(amount)
	hit_flash_player.play("hit_red")
	current_health -= amount
	
	if (current_health <= 0):
		call_deferred("matroyshka_logic")

func matroyshka_logic():
	if (number_of_splits > 0):
		number_of_splits = number_of_splits - 1
		for i in range(number_of_offspring):
			var new_doll = matroyshka.instantiate()
			get_parent().add_child(new_doll)
			new_doll.position = position + Vector2(i*2,i*2)
			new_doll.scale = scale * 0.8
			new_doll.HEALTH = HEALTH / 2.0
			new_doll.number_of_splits = number_of_splits
			new_doll.SPEED = SPEED * 1.2
			new_doll.allowed_to_move = true

	queue_free()

#func _on_hitbox_area_entered(area):
#	if (area.is_in_group("player_hurtbox")):
#		area.get_parent().take_damage(contact_damage)
