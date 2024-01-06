extends enemy_baseclass

var current_health
var matroyshka = preload("res://Characters/Enemies/Basic Enemies/matroyshka_enemy/matroyshka.tscn")
var number_of_splits = 2
var number_of_offspring= 2
var has_split = false
var contact_damage = 20
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var light_occluder = $LightOccluder2D

func _ready():
	#rotation_degrees = 90
	self.add_to_group("enemies")
	#enemy_container.add_child(self)
	SPEED = 50
	current_health = HEALTH
	muzzle = $Muzzle
	hit_flash_player = $HitFlashPlayer
	
func _physics_process(_delta):
	#print(HEALTH)
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
		#print(number_of_splits)
		#await get_tree().create_timer(0.5).timeout
		for i in range(number_of_offspring):
			var new_doll = matroyshka.instantiate()
			get_parent().add_child(new_doll)
			#enemy_container.add_child(new_doll)
			new_doll.position = position + Vector2(i*2,i*2)
			new_doll.scale = scale * 0.8
			new_doll.HEALTH = HEALTH / 2.0
			new_doll.number_of_splits = number_of_splits
			new_doll.SPEED = SPEED * 1.2

	queue_free()

func _on_hitbox_area_entered(area):
	print(area)
	if (area.is_in_group("player_hurtbox")):
		area.get_parent().take_damage(contact_damage)
