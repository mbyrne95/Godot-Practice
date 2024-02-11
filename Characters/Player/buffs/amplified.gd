extends Node2D

var parent
@onready var lifespan_timer = $lifespan
var parent_num_status_effects = 0
var texture_rect
var parent_debuff_box

func _ready():
	texture_rect = $TextureRect
	parent = get_parent()
	parent_num_status_effects = parent._get_buffs()
	lifespan_timer.start()
	parent.get_node_or_null("amplify_sprite").visible = true
	#parent_debuff_box = parent.get_node_or_null("Control").get_child(0).get_node_or_null("debuff_container")
	#texture_rect.reparent(parent_debuff_box)
	parent.SPEED += 20
	parent.get_node_or_null("Weapon").shoot_cd_multiplier -= 0.15
		
func restart_timer():
	lifespan_timer.stop()
	lifespan_timer.start()

func _on_lifespan_timeout():
	parent.SPEED -= 20
	parent.get_node_or_null("Weapon").shoot_cd_multiplier += 0.15
	parent.get_node_or_null("amplify_sprite").visible = false
	#texture_rect.reparent(self)
	queue_free()
