extends enemy_baseclass

var MAX_HEALTH

@onready var tentacle_projectile = preload("res://Characters/Enemies/Bosses/eye_boss/tentacle_attack.tscn")

@onready var eye_follow = $"Eye Follow"
var eye_follow_speed = 0.2

@onready var rotate_shoot_timer = $"rotate shoot clock"
@onready var rotator = %Rotator
@onready var rotate_speed = 75
@onready var rotate_spawn_count = 4
@onready var radius = 5
var is_rotate_shooting = false

var is_attacking
var attack_list = [
	0, #corresponds to rotate shoot
	1, #corresponds to ... 
]

signal healthChanged(percent_hp)
 
func _ready():
	self.add_to_group("enemies")
	Globs.children_allowed_to_move.connect(_connect_allowed_to_move)
	#enemy_container.add_child(self)
	hit_flash_player = $hit_flash_player
	HEALTH = 10000.0
	MAX_HEALTH = HEALTH
	SPEED = 20
	muzzle = %EyeMuzzle
	SHOOT_CD = 0.1
	projectile_scene = preload("res://Characters/Enemies/Projectiles/round_enemy_bullet.tscn")
	#print(MAX_HEALTH)
	is_attacking = false
	player = get_tree().get_first_node_in_group("players")
	#height = get_tree().get_first_node_in_group("spawn_points").get_node_or_null("boss_height")
	
	var step = 2 * PI / rotate_spawn_count
	for i in range(rotate_spawn_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotator.add_child(spawn_point)
	
func _process(delta):
	print(HEALTH)
	var new_rotation = rotator.rotation_degrees + rotate_speed * delta
	rotator.rotation_degrees = fmod(new_rotation, 360)
	
func _physics_process(_delta):
	#print(HEALTH / MAX_HEALTH)
	if allowed_to_move:
		if(player == null):
			pass
		else:
			#top end
			if (HEALTH/MAX_HEALTH >= 0.66) && !is_attacking:
				#print("top")
				var x = randi_range(0,1)
				#var x = 0
				if x == 0:
					rotate_shoot_init(4,2)
				else:
					tentacle_attack(2, 2, 2)
			elif (HEALTH/MAX_HEALTH < 0.66) && (HEALTH/MAX_HEALTH >= 0.33)  && !is_attacking:
				#print("mid")
				var x = randi_range(0,1)
				#var x = 0
				if x == 0:
					rotate_shoot_init(5,1)
				else:
					tentacle_attack(3, 3, 1)
			elif (HEALTH/MAX_HEALTH < 0.33)  && !is_attacking:
				#print("low")
				var x = randi_range(0,1)
				#var x = 0
				if x == 0:
					rotate_shoot_init(6,0.5)
				else:
					tentacle_attack(4,4,0.5)
		if is_rotate_shooting:
			rotate_shoot()		
	
func rotate_shoot():
	if !shoot_on_cd:
		shoot_on_cd = true
		for s in rotator.get_children():
			var projectile = projectile_scene.instantiate()
			projectile.velocity = 300
			projectile_container.add_child(projectile)
			projectile.position = s.global_position
			projectile.rotation = s.global_rotation
			
		await get_tree().create_timer(SHOOT_CD).timeout
		shoot_on_cd = false
		
func rotate_shoot_init(time, time_between_attacks):
	is_rotate_shooting = true
	is_attacking = true
	#time of rotate shoot
	await get_tree().create_timer(time).timeout
	is_rotate_shooting = false
	
	#time between being able to attack again
	await get_tree().create_timer(time_between_attacks).timeout
	is_attacking = false
		
func tentacle_attack(num_hits_flurry, num_flurry, time_before_next_attack):
	is_attacking = true
	var offset_right = 19
	var offset_left = -12
	for i in range(num_flurry):
		var previous_x= -1000
		for j in range(num_hits_flurry):
			var t = tentacle_projectile.instantiate()
			projectile_container.add_child(t)
			var new_position = randf_range(0,180)
			while(new_position < previous_x+offset_right && new_position > previous_x+offset_left):
				new_position = randf_range(0,180)
			previous_x = new_position
			t.global_position = Vector2(new_position, 320)
			#print(t.global_position)

			if (new_position > 90):
				t.scale.x = -1
			#time between attacks in a flurry
			await get_tree().create_timer(0.15).timeout
		#time between flurries
		await get_tree().create_timer(1.5).timeout
	
	#time between being able to attack again
	await get_tree().create_timer(time_before_next_attack).timeout
	is_attacking = false

func rotateToTarget(target, delta):
	var direction = (target.global_position - eye_follow.global_position)
	var angleTo = eye_follow.global_transform.x.angle_to(direction)
	eye_follow.rotate(sign(angleTo) * min(delta * eye_follow_speed, abs(angleTo)))

func take_damage(amount : int):
	hit_flash_player.play("hit_red")
	HEALTH -= amount
	healthChanged.emit(HEALTH / MAX_HEALTH)
	if (HEALTH <= 0):
		Globs.child_of_wave_died.emit()
		queue_free()
