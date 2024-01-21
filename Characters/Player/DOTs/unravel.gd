extends Node2D

var parent
@onready var lifespan_timer = $lifespan

var texture_rect
var parent_debuff_box
var parent_ratio_snap

var new_dmg_ratio = 0.65

func _ready():
	texture_rect = $TextureRect
	parent = get_parent()
	lifespan_timer.start()
	parent_debuff_box = parent.get_node_or_null("Control").get_child(0).get_node_or_null("debuff_container")
	texture_rect.reparent(parent_debuff_box)
	parent_ratio_snap = parent.dmg_output_ratio 
	parent.dmg_output_ratio = new_dmg_ratio
		
func restart_timer():
	lifespan_timer.stop()
	lifespan_timer.start()

func _on_lifespan_timeout():
	texture_rect.reparent(self)
	parent.dmg_output_ratio = parent_ratio_snap
	queue_free()
