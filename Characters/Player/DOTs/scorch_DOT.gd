extends Node2D

var scorch_on_cd = false
var scorch_dmg = 2
var tick_cd = 0.75
var parent
@onready var lifespan_timer = $lifespan
var parent_num_status_effects = 0

var scorch_aoe = preload("res://Characters/Player/DOTs/scorch_AOE.tscn")
var apply_radiant = false
var radiant_scene = preload("res://Characters/Player/buffs/radiant.tscn")

var num_stacks = 1

var texture_rect
var parent_debuff_box
var stack_counter

var projectile_container

func _ready():
	projectile_container = get_tree().get_first_node_in_group("projectile_container")
	parent = get_parent()
	parent_num_status_effects = parent.get_status_effects()
	lifespan_timer.start()
	texture_rect = $TextureRect
	parent_debuff_box = parent.get_node_or_null("Control").get_child(0).get_node_or_null("debuff_container")
	stack_counter = $TextureRect/stacks
	texture_rect.reparent(parent_debuff_box)

	#stack_counter = 1
	
func _process(_delta):
	stack_counter.text = str(num_stacks)
	if num_stacks >= 20:
		if parent != null:
			var x = scorch_aoe.instantiate()
			x.damage = scorch_dmg * 20 * 2.5
			x.scale = Vector2(0.25,0.25)
			x.timescale = 12
			x.position = global_position
			projectile_container.add_child(x)
			num_stacks = 1
			
			if apply_radiant && get_tree().get_first_node_in_group("players") != null:
				var radiant = radiant_scene.instantiate()
				get_tree().get_first_node_in_group("players").add_child(radiant)
				print("applied radiant to player")
	_scorch_dmg()

func _scorch_dmg():
	if !scorch_on_cd:
		#print("poison dmg")
		scorch_on_cd = true
		parent.take_damage(scorch_dmg * num_stacks)
		
		await get_tree().create_timer(tick_cd).timeout
		
		scorch_on_cd = false
		
func restart_timer():
	lifespan_timer.stop()
	lifespan_timer.start()

func _on_lifespan_timeout():
	num_stacks -= 1
	lifespan_timer.start()
	if num_stacks < 1:
		texture_rect.reparent(self)
		queue_free()
