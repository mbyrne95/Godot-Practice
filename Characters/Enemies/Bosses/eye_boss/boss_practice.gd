extends enemy_baseclass

var MAX_HEALTH

@onready var tentacle_projectile = preload("res://Characters/Enemies/Bosses/eye_boss/tentacle_attack.tscn")
@onready var wavey_bullet = preload("res://Characters/Enemies/Projectiles/wave_bullet.tscn")
@onready var cease_scene = preload("res://Characters/Enemies/Bosses/eye_boss/cease_anim.tscn")
@onready var dialogue = preload("res://Characters/dialogue.tscn")

@onready var rotator_scene = preload("res://Characters/Enemies/rotator.tscn")

@onready var aoe_scene = preload("res://Characters/Enemies/Bosses/eye_boss/boss_aoe.tscn")

@onready var sliding_point_scene = preload("res://Characters/Enemies/Bosses/eye_boss/sliding_point.tscn")
@onready var volley_container = $volley_container

@onready var eye_follow = $"Eye Follow"
var eye_follow_speed = 0.2

@onready var ability_duration_timer = $"ability timer"
var ability_timer_initialized = false
@onready var attack_cd_timer = $"attack timer"
var attack_timer_initialized = false

@onready  var rotator = $"Eye Follow/Rotator2"
@onready var rotate_spawn_count = 6
@onready var radius = 5

var attack_state
enum attack_list {
	default,
	one_shot,
	stop_player_movement,
	cease_light,
	rotate_shoot,
	column_attack, ##tentacle attack 
	volley_attack,	
}

var hp_ratio
var hp_state
enum hp_state_list{
	high,
	mid,
	low
}

var hits_in_flurry = 2
var total_flurries = 2
var time_between_hits = 0.15
var time_between_flurries = 1.5
var current_hit = 0
var current_flurry = 0
var previous_hit_loc = -1000
@onready var column_bw_hit_timer = $column_bw_hit_timer
@onready var column_bw_flurry_timer = $column_bw_flurry_timer

@onready var rotate_speed = 75
var rotate_shoot_projectile_vel = 150
var rotate_shoot_time = 4

var num_points_in_volley = 10
var volley_projectile_vel = 120
var volley_shoot_on_cd = false
var volley_shoot_cd = 0.5
var volley_shoot_time = 8
var volley_projectile_scene = preload("res://Characters/Enemies/Projectiles/round_enemy_bullet.tscn")

var AOE_CD
var aoe_on_cd = false 
var aoe_duration = false

var time_between_attacks = 2.0


signal healthChanged(percent_hp)
 
func _ready():
	self.add_to_group("enemies")
	Globs.children_allowed_to_move.connect(_connect_allowed_to_move)
	#enemy_container.add_child(self)
	sprite = $"Eye Follow/Sprite2D"
	MAX_HEALTH = 50000.0
	HEALTH = MAX_HEALTH
	SPEED = 20
	muzzle = %EyeMuzzle
	SHOOT_CD = 0.1
	projectile_scene = preload("res://Characters/Enemies/Projectiles/round_enemy_bullet.tscn")
	
	#print(MAX_HEALTH)
	player = get_tree().get_first_node_in_group("players")
	
	rotator.rotate_speed = 75
	rotator.rotate_spawn_count = 6
	rotator.radius = 5
	
	hp_ratio = HEALTH / MAX_HEALTH
	hp_state = hp_state_list.high
	attack_state = attack_list.cease_light
	
	for i in num_points_in_volley:
		var point = sliding_point_scene.instantiate()
		var x_value = randf_range(10.0, 170.0)
		point.position = Vector2(x_value, 310)
		point.rotation = rotation
		volley_container.add_child(point)
	
func _process(_delta):
	#print(attack_state)
	rotator.global_position = muzzle.global_position

	if(player == null):
		return

	muzzle.look_at(player.global_position)

	if allowed_to_move:
		match attack_state:
			attack_list.default:
				_attack_timer_init(time_between_attacks)
			attack_list.one_shot:
				pass
			attack_list.stop_player_movement:
				attack_state = attack_list.one_shot
				_cease()
			attack_list.cease_light:
				attack_state = attack_list.one_shot
				_cease_light()
				_ability_timer_init(0.8)
			attack_list.rotate_shoot:
				if hp_state == hp_state_list.mid:
					_aoe_blast(rotate_shoot_time / 2.0)
				elif hp_state == hp_state_list.low:
					_aoe_blast(rotate_shoot_time / 4.0)
				rotate_shoot()
				_ability_timer_init(rotate_shoot_time)
			attack_list.column_attack:
				attack_state = attack_list.one_shot
				column_attack()
				#tentacle_attack(hits_in_flurry,total_flurries,time_between_hits,time_between_flurries)
				_ability_timer_init((hits_in_flurry * time_between_hits) + (total_flurries * time_between_flurries))
			attack_list.volley_attack:
				if hp_state == hp_state_list.mid:
					_aoe_blast(volley_shoot_time / 2.0)
				elif hp_state == hp_state_list.low:
					_aoe_blast(volley_shoot_time / 4.0)
				_random_volley()
				_ability_timer_init(volley_shoot_time)

func rotate_shoot():
	if !shoot_on_cd:
		shoot_on_cd = true
		for s in rotator.get_children():
			var projectile = projectile_scene.instantiate()
			projectile.velocity = rotate_shoot_projectile_vel
			projectile.damage = projectile_damage
			projectile._green = true
			projectile_container.add_child(projectile)
			projectile.position = s.global_position
			projectile.rotation = s.global_rotation


		await get_tree().create_timer(SHOOT_CD).timeout
		shoot_on_cd = false
		
#func tentacle_attack(num_hits_flurry, num_flurry, time_bw_hits, time_bw_flurries):
##	is_attacking = true
#	var offset = 12
#	for i in range(num_flurry):
#		var previous_x= -1000
#		for j in range(num_hits_flurry):
#
#			var t = tentacle_projectile.instantiate()
#			projectile_container.add_child(t)
#			var new_position = randf_range(10,170)
#
#			while(new_position < previous_x+offset && new_position > previous_x-offset):
#				new_position = randf_range(10,170)
#
#			previous_x = new_position
#			t.global_position = Vector2(new_position, 320)
#			#print(t.global_position)
#
#			#time between attacks in a flurry
#			await get_tree().create_timer(time_bw_hits).timeout
#		#time between flurries
#		await get_tree().create_timer(time_bw_flurries).timeout
		
func column_attack():
	var offset = 12
	if current_flurry < total_flurries:
		if current_hit < hits_in_flurry:
			var t = tentacle_projectile.instantiate()
			projectile_container.add_child(t)
			var new_position = randf_range(10,170)

			while(new_position < previous_hit_loc+offset && new_position > previous_hit_loc-offset):
				new_position = randf_range(10,170)

			previous_hit_loc = new_position
			t.global_position = Vector2(new_position, 320)
			column_bw_hit_timer.wait_time = time_between_hits
			current_hit += 1
			column_bw_hit_timer.start()
		else:
			current_hit = 0
			current_flurry += 1
			column_bw_flurry_timer.wait_time = time_between_flurries
			column_bw_flurry_timer.start()
	else:
		current_hit = 0
		current_flurry = 0

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

		hp_ratio = HEALTH / MAX_HEALTH
		if hp_ratio >= 0.66:
			hp_state = hp_state_list.high
		elif hp_ratio < 0.66 && hp_ratio >= 0.33:
			hp_state = hp_state_list.mid
		elif hp_ratio < 0.33:
			hp_state = hp_state_list.low

		match hp_state:
			hp_state_list.high:	
				rotator.rotate_speed = 75
				hits_in_flurry = 2
				total_flurries = 2
				time_between_hits = 0.15
				time_between_flurries = 1.5
				rotate_shoot_time = 4
				time_between_attacks = 2.0
			hp_state_list.mid:
				volley_projectile_vel = 150
				rotate_shoot_projectile_vel = 225
				SHOOT_CD = 0.06
				projectile_scene = wavey_bullet
				rotator.rotate_speed = 110
				hits_in_flurry = 3
				total_flurries = 3
				time_between_hits = 0.15
				time_between_flurries = 1.2
				rotate_shoot_time = 4
				time_between_attacks = 1.5
			hp_state_list.low:
				volley_projectile_vel = 175
				rotate_shoot_projectile_vel = 275
				SHOOT_CD = 0.04
				rotator.rotate_speed = 150
				hits_in_flurry = 4
				total_flurries = 4
				time_between_hits = 0.12
				time_between_flurries = 0.8
				rotate_shoot_time = 6
				time_between_attacks = 0.8

		await get_tree().create_timer(0.1).timeout

		sprite.material.set_shader_parameter("enabled", false)

func _cease():
	dmg_taken_ratio = 0.15
	var dia = dialogue.instantiate()
	dia.messages = ["Fall", "So, you have risen again", "I will reward your insolence", "with Death"]
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

func _cease_light():
	var temp = dmg_taken_ratio
	dmg_taken_ratio = 0.01
	var dia = dialogue.instantiate()
	dia.messages = ["Fall"]
	add_child(dia)
	dia.global_position = Vector2(90,220)
	dia.read_time = 1
	dia.typing_speed = 0.09
	dia.start_dialogue()
	var y = cease_scene.instantiate()
	await get_tree().create_timer(0.3).timeout
	get_tree().get_first_node_in_group("parallax_layer").add_child(y)
	y.position = global_position
	await get_tree().create_timer(1).timeout
	dmg_taken_ratio = temp

func _aoe_blast(value):
	if !aoe_on_cd:
		aoe_on_cd = true
		var aoe = aoe_scene.instantiate()
		aoe.global_position = global_position
		aoe.scale = Vector2(2,2)
		#aoe.damage = projectile_damage
		projectile_container.add_child(aoe)
	
		await get_tree().create_timer(value).timeout
		aoe_on_cd = false

func _random_volley():
	if !volley_shoot_on_cd:
		volley_shoot_on_cd = true
		for i in volley_container.get_children():
			var projectile = volley_projectile_scene.instantiate()
			projectile.damage = projectile_damage
			projectile.velocity = volley_projectile_vel + randf_range(-20, 20)
			projectile._green = true
			projectile_container.add_child(projectile)
			projectile.position = i.global_position
			projectile.rotation_degrees = -90
		await get_tree().create_timer(volley_shoot_cd).timeout
		volley_shoot_on_cd = false

func _add_children_to_volley(num_children):
	for i in num_children:
		var point = sliding_point_scene.instantiate()
		var x_value = randf_range(10.0, 170.0)
		point.position = Vector2(x_value, 310)
		point.rotation = rotation
		volley_container.add_child(point)

#	is_attacking = true
#	var volley_spawn_container = random_volley_scene.instantiate()
#	volley_spawn_container.position = global_position
#	add_child(volley_spawn_container)

func _ability_timer_init(ability_time):
	if !ability_timer_initialized:
		ability_timer_initialized = true
		ability_duration_timer.wait_time = ability_time
		ability_duration_timer.start()
		
func _attack_timer_init(time_bw_attacks):
	if !attack_timer_initialized:
		attack_timer_initialized = true
		attack_cd_timer.wait_time = time_bw_attacks
		attack_cd_timer.start()

func _on_ability_timer_timeout():
	attack_state = attack_list.default
	ability_timer_initialized = false

func _on_attack_timer_timeout():
	#start at 4, because 0, 1, 2, and 3 are reserved and shouldn't be in rotation
	#five is in development
	attack_state = attack_list.column_attack
	#attack_state = attack_list.values()[randi_range(4,attack_list.size() - 1)]
	attack_timer_initialized = false

func _on_column_bw_hit_timer_timeout():
	column_attack()


func _on_column_bw_flurry_timer_timeout():
	column_attack()
