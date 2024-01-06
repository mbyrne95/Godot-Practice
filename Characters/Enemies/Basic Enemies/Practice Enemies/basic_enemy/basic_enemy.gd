extends enemy_baseclass

func _ready():
	self.add_to_group("enemies")
	#enemy_container.add_child(self)
	muzzle = $Muzzle
	hit_flash_player = $HitFlashPlayer
	projectile_scene = preload("res://Characters/Enemies/Basic Enemies/Practice Enemies/basic_enemy/generic_enemy_bullet.tscn")
	height = get_tree().get_first_node_in_group("spawn_points").get_node_or_null("height")
	#var height_transform = spawn_points.get_child("height").global_transform.y


func _physics_process(_delta):
	if(position.y > height.position.y):
		move_to_height(_delta)
	#var height_transform = spawn_points.get_child("height").global_transform.y
	else:
		horizontal_only_movement()
		shoot_logic()
