extends enemy_baseclass

var offset = 20

func _ready():
	self.add_to_group("enemies")
	sprite = $Sprite2D
	muzzle = $Muzzle
	hit_flash_player = $HitFlashPlayer
	projectile_scene = preload("res://Characters/Enemies/Basic Enemies/Practice Enemies/basic_enemy/generic_enemy_bullet.tscn")
	Globs.children_allowed_to_move.connect(_connect_allowed_to_move)

func _physics_process(_delta):
	if allowed_to_move:
		if player != null:
			horizontal_only_movement()
			
			if abs(position.x - player.position.x) < offset:
				shoot_logic()
