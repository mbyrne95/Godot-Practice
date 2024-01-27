extends enemy_baseclass

var MAX_HEALTH

@onready var tentacle_projectile = preload("res://Characters/Enemies/Bosses/eye_boss/tentacle_attack.tscn")
@onready var wavey_bullet = preload("res://Characters/Enemies/Projectiles/wave_bullet.tscn")
@onready var cease_scene = preload("res://Characters/Enemies/Bosses/eye_boss/cease_anim.tscn")
@onready var dialogue = preload("res://Characters/dialogue.tscn")

@onready var rotator_scene = preload("res://Characters/Enemies/rotator.tscn")

@onready var aoe_scene = preload("res://Characters/Enemies/Bosses/eye_boss/aoe_practice.tscn")

@onready var random_volley_scene = preload("res://Characters/Enemies/Bosses/eye_boss/random_volley_area.tscn")

@onready var eye_follow = $"Eye Follow"
var eye_follow_speed = 0.2
var has_ceased = true

@onready var ability_timer = $"ability timer"
var ability_timer_initialized = false
@onready var attack_timer = $"attack timer"
var attack_timer_initialized = false
@onready  var rotator = $"Eye Follow/Rotator2"
@onready var rotate_speed = 75
@onready var rotate_spawn_count = 6
@onready var radius = 5
var is_rotate_shooting = false

var spin = true

var is_attacking
var attack_state
enum attack_list {
	default,
	one_shot,
	stop_player_movement,
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
var rotate_shoot_time = 4

var time_between_attacks = 2.0

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
	
	rotator.rotate_speed = 75
	rotator.rotate_spawn_count = 6
	rotator.radius = 5
	
	hp_ratio = HEALTH / MAX_HEALTH
	hp_state = hp_state_list.high
	attack_state = attack_list.default
	
func _process(_delta):
	#print(attack_state)
	rotator.global_position = muzzle.global_position

	if(player == null):
		return

	muzzle.look_at(player.global_position)
	
	

	if allowed_to_move:
		
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
				SHOOT_CD = 0.04
				rotator.rotate_speed = 150
				hits_in_flurry = 4
				total_flurries = 4
				time_between_hits = 0.12
				time_between_flurries = 0.8
				rotate_shoot_time = 6
				time_between_attacks = 0.8
				
					
		match attack_state:
			attack_list.default:
				_attack_timer_init(time_between_attacks)
			attack_list.one_shot:
				pass
			attack_list.stop_player_movement:
				attack_state = attack_list.one_shot
				_cease()
			attack_list.rotate_shoot:
				rotate_shoot()
				_ability_timer_init(rotate_shoot_time)
			attack_list.column_attack:
				attack_state = attack_list.one_shot
				tentacle_attack(hits_in_flurry,total_flurries,time_between_hits,time_between_flurries)
				_ability_timer_init((hits_in_flurry * time_between_hits) + (total_flurries * time_between_flurries))

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
		
func tentacle_attack(num_hits_flurry, num_flurry, time_bw_hits, time_bw_flurries):
#	is_attacking = true
	var offset = 30
	for i in range(num_flurry):
		var previous_x= -1000
		for j in range(num_hits_flurry):
			var t = tentacle_projectile.instantiate()
			projectile_container.add_child(t)
			var new_position = randf_range(10,170)
			while(new_position < previous_x+offset && new_position > previous_x-offset):
				new_position = randf_range(10,170)
			previous_x = new_position
			t.global_position = Vector2(new_position, 320)
			#print(t.global_position)

			if (new_position > 90):
				t.scale.x = -1
			#time between attacks in a flurry
			await get_tree().create_timer(time_bw_hits).timeout
		#time between flurries
		await get_tree().create_timer(time_bw_flurries).timeout

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

func _random_volley(duration, time_before_next_attack):
	is_attacking = true
	var volley_spawn_container = random_volley_scene.instantiate()
	volley_spawn_container.position = global_position
	add_child(volley_spawn_container)

func _ability_timer_init(ability_time):
	if !ability_timer_initialized:
		ability_timer_initialized = true
		ability_timer.wait_time = ability_time
		ability_timer.start()
		
func _attack_timer_init(attack_time):
	if !attack_timer_initialized:
		print("timer started")
		attack_timer_initialized = true
		attack_timer.wait_time = attack_time
		attack_timer.start()

func _on_ability_timer_timeout():
	attack_state = attack_list.default
	ability_timer_initialized = false

func _on_attack_timer_timeout():
	print("timer stopped")
	#start at 3, because 0, 1, and 2 are attacks that shouldn't be in rotation
	#five is in development
	attack_state = attack_list.values()[randi_range(3,4)]
	attack_timer_initialized = false
