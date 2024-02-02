extends CharacterBody2D

#consider creating custom resource and moving these there
@export_group("Player Stats")
@export_subgroup("Movement")
@export var SPEED = 75
@export var ACCELERATION = 20
@export var FRICTION = 5
@export var rotation_speed = 5
var can_move = false

@export_subgroup("Health")
@export var MAX_HEALTH = 100
var current_health = MAX_HEALTH
@export var iframes = 2
var is_recently_dmg = false
var high_health_ratio = 0.66
var low_health_ratio = 0.33
var dmg_ratio = 1
@onready var armor_plate = $armor_plate
@export_group("")

signal healthChanged(percentHP)

@export_subgroup("UI")
@onready var level_panel = %level_panel
@onready var upgrade_options_container = %upgrade_options
@onready var item_options = preload("res://Characters/Player/UI/item_option.tscn")
var collected_upgrades = []
var upgrade_options = []
@onready var pause_menu = $CanvasLayer/PauseMenu
var paused = false
@export_group("")

var dialogue = preload("res://Characters/dialogue.tscn")

#this is the offset OUTSIDE of screen bounds at which point player will wrap
@export var wrap_offset = 7

@onready var camera = get_tree().get_first_node_in_group("camera")
#signal camera_shake(time, amount)
@export var cameraShake = true
@onready var shockwave = %Shockwave
@onready var shockwaveAnim = %ShockwaveAnim

enum State {
	idle, moving, rolling
}

var dodge_time = 0.2
var is_dodging : bool = false
@onready var collision_shape = $"Collision Shape"
var current_state = State.idle
@onready var hit_flash_player = $HitFlashPlayer
@onready var ship_sprite = $ship_sprite
@onready var thrust = $"thruster particles/thrust"
@onready var death_explo_particles = $death_explo
@onready var hurtbox = $Hurtbox
@onready var lightoccluder = $LightOccluder2D

#blink initialization stuff
@onready var blink = $Blink

@onready var weapon = $Weapon
@onready var upgrade_data = $upgrade_data
var aura = preload("res://Characters/Player/Projectiles/aura/player_aura.tscn")
signal aura_upgrade()
signal aura_jolt()

var is_damageable = true

#initialize input value to zero
var input = Vector2.ZERO

var mouse_direction

func _ready():
	pause_menu.pause_signal.connect(pauseMenu)
	Globs.player_can_move.connect(_can_move)
	Globs.level_player.connect(level_up)
	mouse_direction = (get_global_mouse_position() - global_position)

func _process(_delta):
	#shooting and ui is handled in respective nodes
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

	if can_move:
		if Input.is_action_just_pressed("debug"):
			level_up()
		

func _physics_process(delta):
	#print(get_global_mouse_position())
	if can_move:
		input = get_input()
		player_movement(delta)

		#var target = get_global_mouse_position()
		mouse_direction = (get_global_mouse_position() - global_position)
		var angle_to = self.transform.x.angle_to(mouse_direction)
		self.rotate(sign(angle_to) * min(delta * rotation_speed, abs(angle_to)))
	else:
		thrust.emitting = false
		pass

	screen_wrap()

###MOVEMENT
###########
func state_update():
	if input == Vector2.ZERO:
		current_state = State.idle
	else:
		current_state = State.moving

func get_input():
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	return input.normalized()
	
func player_movement(_delta):
	state_update()
	
	if (input != Vector2.ZERO):
		if Input.is_action_just_pressed("blink"):
				var velSnapshot = velocity
				dash_logic(velSnapshot, input)
			
	if (!is_dodging && input != Vector2.ZERO):
		thrust.emitting = true
		accelerate(input)
	elif(!is_dodging && input == Vector2.ZERO):
		thrust.emitting = false
		apply_friction()
	move_and_slide()
	#if Input.is_action_just_pressed("dash"):
	#	dash.start_dash(dash_duration)
	#print(velocity.x, "  ", velocity.y)

func accelerate(direction : Vector2):
	#var temp_speed = dash_speed if dash.is_dashing() else SPEED
	#var temp_accel = 1000 if dash.is_dashing() else ACCELERATION
	velocity = velocity.move_toward(SPEED * direction, ACCELERATION)
	
func apply_friction():
	#var temp_friction = 1000 if dash.is_dashing() else FRICTION
	velocity = velocity.move_toward(Vector2.ZERO, FRICTION)

#func blink_logic(distance : float, direction : Vector2):
#
#	#if on cooldown, just break
#	if !blink.is_ready():
#		return
#
#	#feels weird with acceleration based movement, maybe kill speed immediately before
#	velocity = Vector2.ZERO
#
#	#get current position, add blink distance to current direction
#	var temp = self.get_position()
#	if (direction.x >= 0):
#		temp.x += distance
#		self.set_position(temp)
#	else:
#		temp.x -= distance
#		self.set_position(temp)
#
#	blink.start_cooldown(BLINK_CD)
	
func dash_logic(velSnapshot : Vector2, direction : Vector2):
	#if on cooldown, just break
	if !blink.is_ready():
		return

	#arbitrary speed multiplier
	var dash_speed = 2
	
	#start dashing
	is_dodging = true
	#hurtbox.monitorable = false
	hit_flash_player.play("flash_white")
	is_damageable = false

	#this will appropriately work in both directions, since x can be negative
	velocity.x += dash_speed * SPEED * direction.x
	velocity.y += dash_speed * SPEED * direction.y
	await get_tree().create_timer(dodge_time).timeout
	#keep our velocity like that until time is over
	
	#end dash
	#hurtbox.monitorable = true
	hit_flash_player.play("flash_white")
	velocity = velSnapshot
	is_dodging = false
	is_damageable = true
	blink.start_cooldown()

#func dodge_logic(total_time : float):
#	if !blink.is_ready():
#		return
#
#	#starting dodge
#	collision_shape.disabled = true
#	hit_flash_player.play("hit_flash_white")
#	is_dodging = true
#
#	#take the total time of the dodge, play hit flash twice before ending
#	total_time -= 0.4
#	await get_tree().create_timer(total_time).timeout
#	hit_flash_player.play("hit_flash_white")
#
#	await get_tree().create_timer(0.2).timeout
#	hit_flash_player.play("hit_flash_white")
#
#	await get_tree().create_timer(0.2).timeout
#	hit_flash_player.play("hit_flash_white")
#	collision_shape.disabled = false
#	is_dodging = false
#	blink.start_cooldown(BLINK_CD)

func screen_wrap():
	if position.x <= -1 * wrap_offset:
		position.x = get_viewport_rect().size.x
	if position.x >= get_viewport_rect().size.x + wrap_offset:
		position.x = 0

### UI ####
###########

#this is adding the options to the panel, and making panel visible
func level_up():
	level_panel.visible = true
	var tween = level_panel.create_tween()
	tween.tween_property(level_panel, "position", Vector2(0,0), 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	#edit this later
	var options = 0
	var options_max = 3
	get_tree().paused = true
	await get_tree().create_timer(0.2).timeout
	while options < options_max:
		var option_choice = item_options.instantiate()
		
		# roll for item rarity here
		var r = randf_range(0,1)
		var rarity
		#common
		if r < 0.4:
			rarity = 0
		elif r >= 0.4 && r < 0.7:
			rarity = 1
			option_choice.color = Color("3f3f74")
		else:
			rarity = 2
			option_choice.color = Color("76428a")
			
		option_choice.item = get_random_item(rarity)
		
		await get_tree().create_timer(0.4).timeout
		upgrade_options_container.add_child(option_choice)
		
		var x = randi_range(0,2)
		match x:
			0:
				option_choice.get_node_or_null("AnimationPlayer").play("placement")
			1:
				option_choice.get_node_or_null("AnimationPlayer").play("placement_2")
			2:
				option_choice.get_node_or_null("AnimationPlayer").play("placement_3")
		options+=1
		
	#panel needs to have process > mode: when paused

#this applies update for the character, clears containers and resets vis
func upgrade_character(upgrade):
	match_item_upgrade(upgrade)
	var option_children = upgrade_options_container.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_options.clear()
	collected_upgrades.append(upgrade)
	level_panel.visible = false
	level_panel.position = Vector2(0,-320)
	
	get_tree().paused = false
	
func get_random_item(rarity):
	var db_list = []
	for i in UPGRADE_DB.UPGRADES:
		#check if we've already collected
		if i in collected_upgrades: 
			pass
		#check if we already have as an option
		elif i in upgrade_options:
			pass
		#check if consumable
		elif UPGRADE_DB.UPGRADES[i]["type"] == "test_consumable":
			pass
		#pass on the debug
		elif UPGRADE_DB.UPGRADES[i]["type"] == "broke_the_game":
			pass
		elif UPGRADE_DB.UPGRADES[i]["rarity"] != rarity:
			pass
		#check for prerequisites
		elif UPGRADE_DB.UPGRADES[i]["prerequisite"].size() > 0:
			for j in UPGRADE_DB.UPGRADES[i]["prerequisite"]:
				if not j in collected_upgrades:
					pass
				else:
					db_list.append(i)
		else:
			db_list.append(i)
	#found compatible+available items
	if db_list.size() > 0:
		var random_item = db_list.pick_random()
		upgrade_options.append(random_item)
		return random_item
	#didn't find items
	else:
		return null
	
func match_item_upgrade(upgrade):
	match upgrade:
		"test_dmg":
			weapon.projectile_damage += 10
		"test_movement":
			SPEED += 10
		"test_health":
			MAX_HEALTH += 20
		"armor_plate_1":
			dmg_ratio -= 0.08
			armor_plate.visible = true
			armor_plate.frame = 0
		"armor_plate_2":
			dmg_ratio -= 0.1
			armor_plate.frame = 1
		"armor_plate_3":
			dmg_ratio -= 0.12
			armor_plate.frame = 2
		"crit_chance_1":
			weapon.crit_chance += 0.15
		"crit_chance_2":
			weapon.crit_chance += 0.20
		"crit_chance_3":
			weapon.crit_chance += 0.30
		"proptosis":
			weapon.proptosis = true
			weapon.size_multiplier += 2
		"twentytwenty":
			weapon.twentytwenty = true
			if (weapon.damage_multiplier > 0.8):
				weapon.damage_multiplier = 0.8
		"soymilk":
			if (weapon.damage_multiplier > 0.25):
				weapon.damage_multiplier = 0.25
			weapon.shoot_cd -= 0.2
		"aura_1":
			var new_aura = aura.instantiate()
			add_child(new_aura)
		"aura_2":
			aura_upgrade.emit()
		"aura_3":
			aura_jolt.emit()
		"ipecac":
			weapon.ipecac = true
			weapon.size_multiplier += 0.4
			weapon.projectile_damage += 40
			weapon.shoot_cd += 1.5
		"scorch_shot":
			weapon.scorch_shot = true
		"hatchling_1":
			weapon.hatchling_upgrade = true
		"hatchling_2":
			weapon.apply_unravel = true
		"range_up_size_down":
			ship_sprite.scale = Vector2(ship_sprite.scale.x - 0.2, ship_sprite.scale.y - 0.2)
			hurtbox.scale = Vector2(hurtbox.scale.x - 0.2, hurtbox.scale.y - 0.2)
			lightoccluder.scale = Vector2(lightoccluder.scale.x - 0.2, lightoccluder.scale.y - 0.2)
			collision_shape.scale = Vector2(collision_shape.scale.x - 0.2, collision_shape.scale.y - 0.2)
			armor_plate.scale = Vector2(armor_plate.scale.x - 0.2, armor_plate.scale.y - 0.2)
			weapon.bullet_range += 35
		"range_up_speed_up":
			weapon.bullet_range += 35
			SPEED += 20
		"range_up_damage_up":
			weapon.bullet_range += 35
			weapon.projectile_damage += 20
		"dash_cooldown_1":
			blink._cd = blink._cd * .90

func pauseMenu():
	if paused:
		print("unpause")
		get_tree().paused = false
		pause_menu.hide()
	else:
		get_tree().paused = true
		pause_menu.show()
	paused = !paused

###TAKING DAMAGE
################
func take_damage(amount : float):
	if(!is_recently_dmg):
		if ((current_health - amount) <= 0):
			healthChanged.emit(0)
			call_deferred("death")
		else:
			current_health -= dmg_ratio * amount
			
			var percentHP = float(current_health) / float(MAX_HEALTH)
			#change sprite to more damaged based on %health
			if (percentHP <= high_health_ratio && percentHP > low_health_ratio):
				ship_sprite.frame = 1
			elif (percentHP <= low_health_ratio):
				ship_sprite.frame = 2
				
			healthChanged.emit(percentHP)

			if (cameraShake):
				Globs.camera_shake.emit(0.65, (amount/MAX_HEALTH) * 8)
				
			call_deferred("dmg_iframes")
			frame_freeze(0.05, 0.85)
			ship_sprite.material.set_shader_parameter("enabled", true)

			await get_tree().create_timer(0.1).timeout
			ship_sprite.material.set_shader_parameter("enabled", false)

func dmg_iframes():
	is_recently_dmg = true
	is_damageable = false
	#hurtbox.monitorable = false
	await get_tree().create_timer(iframes).timeout
	#hurtbox.monitorable = true
	is_damageable = true
	is_recently_dmg = false

func frame_freeze(timeScale, duration):
	Engine.time_scale = move_toward(1, timeScale, 0.75)
	await get_tree().create_timer(duration * timeScale).timeout
	Engine.time_scale = move_toward(timeScale, 1, 0.75)

func death():
	can_move = false
	#var scaled_position = Vector2((global_position.x/get_viewport_rect().size.x), (global_position.y/get_viewport_rect().size.y))
	#shockwave.material.set_shader_parameter("center", scaled_position)

	thrust.emitting = false
	Globs.camera_death_zoom.emit(global_position)
	await get_tree().create_timer(2).timeout
	#shockwaveAnim.play("shockwave")
	shockwave.position = global_position
	shockwave.visible = true
	var tween = create_tween()
	tween.tween_method(material_size, 0.0, 1.0, 0.5)
	
	death_explo_particles.emitting = true
	collision_shape.disabled = true
	ship_sprite.visible = false
	armor_plate.visible = false
	$PlayerUI.visible = false
	#$LightOccluder2D.visible = false
	await get_tree().create_timer(1).timeout
	queue_free()

func _can_move():
	can_move = true

func material_size(size : float):
	shockwave.material.set_shader_parameter("size", size)
