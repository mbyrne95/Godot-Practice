extends Node2D

var poison_on_cd = false
var poison_dmg = 15
var tick_cd = 0.75
var parent
@onready var lifespan_timer = $lifespan
var parent_num_status_effects = 0

var texture_rect
var parent_debuff_box

func _ready():
	texture_rect = $TextureRect
	parent = get_parent()
	parent_num_status_effects = parent.get_status_effects()
	lifespan_timer.start()
	parent_debuff_box = parent.get_node_or_null("Control").get_child(0).get_node_or_null("debuff_container")
	texture_rect.reparent(parent_debuff_box)
	
func _process(_delta):
	_poison_dmg()

func _poison_dmg():
	if !poison_on_cd:
		print("poison dmg")
		poison_on_cd = true
		parent.take_damage(poison_dmg)
		
		await get_tree().create_timer(tick_cd).timeout
		
		poison_on_cd = false
		
func restart_timer():
	lifespan_timer.stop()
	lifespan_timer.start()

func _on_lifespan_timeout():
	texture_rect.reparent(self)
	queue_free()
