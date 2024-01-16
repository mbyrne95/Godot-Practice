extends Node2D

var jolt_on_cd = false
var jolt_dmg = 15
var tick_cd = 0.75
var parent
@onready var lifespan_timer = $lifespan

func _ready():
	parent = get_parent()
	if parent.get_node_or_null("Sprite2D") != null:
		parent.get_node_or_null("Sprite2D").modulate = Color("5fcde4")
	if parent.get_node_or_null("AnimatedSprite2D") != null:
		parent.get_node_or_null("AnimatedSprite2D").modulate = Color("5fcde4")
	lifespan_timer.start()
	
func _process(_delta):
	_jolt_dmg()

func _jolt_dmg():
	if !jolt_on_cd:
		print("jolt dmg")
		jolt_on_cd = true
		parent.take_damage(jolt_dmg)
		
		await get_tree().create_timer(tick_cd).timeout
		
		jolt_on_cd = false

func _on_lifespan_timeout():
	if parent.get_node_or_null("Sprite2D") != null:
		parent.get_node_or_null("Sprite2D").modulate = Color.WHITE
	if parent.get_node_or_null("AnimatedSprite2D") != null:
		parent.get_node_or_null("AnimatedSprite2D").modulate = Color.WHITE

	queue_free()
