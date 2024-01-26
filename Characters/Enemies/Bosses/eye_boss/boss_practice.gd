extends enemy_baseclass

var MAX_HEALTH

@onready var tentacle_projectile = preload("res://Characters/Enemies/Bosses/eye_boss/tentacle_attack.tscn")
@onready var wavey_bullet = preload("res://Characters/Enemies/Projectiles/wave_bullet.tscn")
@onready var cease_scene = preload("res://Characters/Enemies/Bosses/eye_boss/cease_anim.tscn")
@onready var dialogue = preload("res://Characters/dialogue.tscn")

@onready var rotator_scene = preload("res://Characters/Enemies/rotator.tscn")

@onready var aoe_scene = preload("res://Characters/Enemies/Bosses/eye_boss/aoe_practice.tscn")

@onready var eye_follow = $"Eye Follow"
var eye_follow_speed = 0.2
var has_ceased = true

@onready var rotate_shoot_timer = $"rotate shoot clock"
@onready  var rotator = $"Eye Follow/Rotator2"
@onready var rotate_speed = 75
@onready var rotate_spawn_count = 6
@onready var radius = 5
var is_rotate_shooting = false

var spin = true

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
	sprite = $"Eye Follow/Sprite2D"
	MAX_HEALTH = 1000.0
	HEALTH = MAX_HEALTH
	SPEED = 20
	muzzle = %EyeMuzzle
	SHOOT_CD = 0.1
	projectile_scene = preload("res://Characters/Enemies/Projectiles/round_enemy_bullet.tscn")
	
	#print(MAX_HEALTH)
	is_attacking = false
	player = get_tree().get_first_node_in_group("players")
	#height = get_tree().get_first_node_in_group("spawn_points").get_node_or_null("boss_height")
	
	rotator.rotate_speed = 75
	rotator.rotate_spawn_count = 6
	rotator.radius = 5
	
	
#	var step = 2 * PI / rotate_spawn_count
#	for i in range(rotate_spawn_count):
#		var spawn_point = Node2D.new()
#		var pos = Vector2(radius, 0).rotated(step * i)
#		spawn_point.position = pos
#		spawn_point.rotation = pos.angle()
#		rotator.add_child(spawn_point)
	
func _process(_delta):
	rotator.global_position = muzzle.global_position
	#print(HEALTH)
#	if spin:
#		var new_rotation = rotator.rotation_degrees + rotate_speed * delta
#		rotator.rotation_degrees = fmod(new_rotation, 360)
	if(player == null):
		return
	muzzle.look_at(player.global_position)
	
func _physics_process(_delta):
	#print(HEALTH / MAX_HEALTH)
	if allowed_to_move:
		if(player == null):
			return
		else:
			if !has_ceased:
				allowed_to_move = false
				_cease()
			#top end
			elif (HEALTH/MAX_HEALTH >= 0.66) && !is_attacking:
				#print("top")
				var x = randi_range(0,1)
				#var x = 0
				if x == 0:
					rotate_shoot_init(4,2)
				else:
					tentacle_attack(2, 2, 2)
			elif (HEALTH/MAX_HEALTH < 0.66) && (HEALTH/MAX_HEALTH >= 0.33)  && !is_attacking:
				#print("mid")
				projectile_scene = wavey_bullet
				SHOOT_CD = 0.06
				rotate_speed = 100
				rotator.rotate_speed = rotate_speed
				var x = randi_range(0,1)
				#var x = 0
				if x == 0:
					rotate_shoot_init(5,1)
				else:
					tentacle_attack(3, 3, 1)
			elif (HEALTH/MAX_HEALTH < 0.33)  && !is_attacking:
				#print("low")
				SHOOT_CD = 0.04
				rotator.rotate_speed = rotate_speed
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
			projectile.damage = projectile_damage
			projectile._green = true
			projectile_container.add_child(projectile)
			projectile.position = s.global_position
			projectile.rotation = s.global_rotation
			
			
		await get_tree().create_timer(SHOOT_CD).timeout
		shoot_on_cd = false
		
func rotate_shoot_init(time, time_before_next_attack):
#	var rotator = rotator_scene.instantiate()
#	rotator.rotate_speed = rotate_speed
#	rotator.rotate_spawn_count = rotate_spawn_count
#	rotator.position = muzzle.global_position
#	add_child(rotator)
	is_rotate_shooting = true
	is_attacking = true
	#time of rotate shoot
	await get_tree().create_timer(time).timeout
	is_rotate_shooting = false
	#rotator.queue_free()
	
	#time between being able to attack again
	await get_tree().create_timer(time_before_next_attack).timeout
	is_attacking = false
		
func tentacle_attack(num_hits_flurry, num_flurry, time_before_next_attack):
	is_attacking = true
	var offset_right = 20
	var offset_left = -20
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
	if allowed_to_move:
		HEALTH -= amount * dmg_taken_ratio
		healthChanged.emit(HEALTH/MAX_HEALTH)
		sprite.material.set_shader_parameter("enabled", true)
		if (HEALTH <= 0):
			Globs.child_of_wave_died.emit()
			queue_free()
			
		enemy_took_damage.emit(amount)
		
		await get_tree().create_timer(0.1).timeout
		
		sprite.material.set_shader_parameter("enabled", false)

func _cease():
	dmg_taken_ratio = 0.15
	has_ceased = true
	var dia = dialogue.instantiate()
	dia.messages = ["Cease", "So, you have risen again", "I will reward your insolence", "with Death"]
	add_child(dia)
	dia.global_position = Vector2(90,220)
	dia.read_time = 1.75
	dia.typing_speed = 0.07
	dia.start_dialogue()
	await get_tree().create_timer(2.0).timeout
#	var x = cease_scene.instantiate()
#	x.position = global_position
#	get_tree().get_root().add_child(x)
	var y = cease_scene.instantiate()
	get_tree().get_first_node_in_group("parallax_layer").add_child(y)
	y.position = global_position
	player.can_move = false
	await get_tree().create_timer(12.0).timeout
	var z = projectile_scene.instantiate()
	z.position = muzzle.global_position
	z.global_rotation = muzzle.global_rotation
	z._green = true
	z.velocity = 75
	z.damage = 999999
	shoot(z)

func _aoe_blast(time_before_next_attack):
	is_attacking = true
	var aoe = aoe_scene.instantiate()
	aoe.global_position = global_position
	aoe.scale = Vector2(2,2)
	aoe.damage = projectile_damage
	projectile_container.add_child(aoe)
	
	await get_tree().create_timer(time_before_next_attack).timeout
	is_attacking = false

