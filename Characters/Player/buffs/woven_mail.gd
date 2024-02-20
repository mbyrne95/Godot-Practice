extends Node2D

var parent
@onready var lifespan_timer = $lifespan
var parent_num_status_effects = 0
var texture_rect
var parent_debuff_box
var dmg_reduction

func _ready():
	texture_rect = $TextureRect
	parent = get_parent()
	parent_num_status_effects = parent._get_buffs()
	lifespan_timer.start()
	#print(parent.get_node("radiant_sprite").visible)
	parent.get_node("radiant_sprite").visible = true
	parent.get_node("radiant_sprite").play("default")
	#var player_max_health = parent.MAX_HEALTH
	#parent.current_health += clamp((0.01 * player_max_health), 0, player_max_health)
	#parent.healthChanged.emit(parent.current_health / player_max_health)
	dmg_reduction = clamp(parent.dmg_ratio - 0.3, 0.1, 100.0)
	parent.dmg_ratio -= dmg_reduction

func restart_timer():
	lifespan_timer.stop()
	lifespan_timer.start()

func _on_lifespan_timeout():
	#parent.SPEED -= 20
	parent.dmg_ratio += dmg_reduction
	parent.get_node("radiant_sprite").visible = false
	#texture_rect.reparent(self)
	queue_free()
