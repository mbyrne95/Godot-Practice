extends enemy_baseclass

var current_health
var number_of_splits = 2
var number_of_offspring= 2
var has_split = false

@onready var parent = get_parent()
@onready var collision = $CollisionShape2D
@onready var light_occluder = $LightOccluder2D

signal has_died(given_position, number_of_splits, given_scale, given_health, given_speed)

func _ready():
	sprite = $Sprite2D
	Globs.children_allowed_to_move.connect(_connect_allowed_to_move)
	self.add_to_group("enemies")
	contact_damage = 20
	SPEED = 50
	current_health = HEALTH
	muzzle = $Muzzle
	hit_flash_player = $HitFlashPlayer
	
func _process(_delta):
	#print(global_position)
	if allowed_to_move:
		
		follow_player_movement()

func take_damage(amount : int):
	if allowed_to_move:
		sprite.material.set_shader_parameter("enabled", true)
		current_health -= amount * dmg_taken_ratio
		enemy_took_damage.emit(amount)
		if (current_health <= 0):
			if(number_of_splits == 0):
				queue_free()
			parent.call_deferred("spawn_children", self, global_position, number_of_splits, number_of_offspring, scale, HEALTH, SPEED)
		
		await get_tree().create_timer(0.1).timeout
		sprite.material.set_shader_parameter("enabled", false)
