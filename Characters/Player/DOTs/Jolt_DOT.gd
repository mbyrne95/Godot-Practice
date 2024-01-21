extends Node2D

var jolt_dmg
var jolt_dmg_ratio = 0.75

var jolt_dmg_cd = 0.2
var can_do_volt_dmg = true

var parent
@onready var lifespan_timer = $lifespan
var enemies_in_range = []
@onready var lightning_bolt = $Node2D/Sprite2D2
@onready var pivot = $Node2D
var icon 

var parent_num_status_effects

var texture_rect
var parent_debuff_box

func _ready():
	texture_rect = $TextureRect
	parent = get_parent()
	parent.dmg_taken_ratio = 1.3
	parent.enemy_took_damage.connect(_jolt_dmg)
	lifespan_timer.start()
	parent_debuff_box = parent.get_node_or_null("Control").get_child(0).get_node_or_null("debuff_container")
	texture_rect.reparent(parent_debuff_box)

func _process(_delta):
	pass

func _jolt_dmg(amount):
	if can_do_volt_dmg:
		can_do_volt_dmg = false
		jolt_dmg = clamp(amount * jolt_dmg_ratio, 10, 40)
		if enemies_in_range.size() != 0:
			var x = enemies_in_range.pick_random()
			x.take_damage(jolt_dmg)
			
			draw_lightning(x)
		await get_tree().create_timer(jolt_dmg_cd).timeout
		can_do_volt_dmg = true

func _on_lifespan_timeout():
	texture_rect.reparent(self)
	parent.dmg_taken_ratio = 1.0
	queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("enemies"):
		if body != parent:
			enemies_in_range.append(body)

func _on_area_2d_body_exited(body):
	if body.is_in_group("enemies"):
		if body != parent:
			enemies_in_range.erase(body)

func draw_lightning(x):
#	var target_position = (x.global_position - global_position)
#	var angle_to = transform.x.angle_to(target_position)
#	lightning_bolt.global_rotation_degrees = sin(angle_to)
	var distance = global_position.distance_to(x.global_position)
	pivot.look_at(x.global_position)
	
	if distance <= 8:
		lightning_bolt.frame = 0
	elif distance > 8 && distance <= 16:
		lightning_bolt.frame = 1
	elif distance > 16 && distance <= 24:
		lightning_bolt.frame = 2
	elif distance > 24 && distance <= 32:
		lightning_bolt.frame = 3
	elif distance > 32 && distance <= 40:
		lightning_bolt.frame = 4
	elif distance > 40 && distance <= 48:
		lightning_bolt.frame = 5
	elif distance > 48 && distance <= 56:
		lightning_bolt.frame = 6
	elif distance > 56 && distance <= 64:
		lightning_bolt.frame = 7

	
	lightning_bolt.visible = true
	await get_tree().create_timer(0.05).timeout
	#lightning_bolt.scale.x = 1
	lightning_bolt.visible = false

func restart_timer():
	lifespan_timer.stop()
	lifespan_timer.start()
