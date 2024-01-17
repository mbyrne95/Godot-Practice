extends Node2D

var poison_on_cd = false
var poison_dmg = 15
var tick_cd = 0.75
var parent
@onready var lifespan_timer = $lifespan
var parent_num_status_effects = 0

func _ready():
	parent = get_parent()
	parent_num_status_effects = parent.get_status_effects()
	lifespan_timer.start()
	
func _process(_delta):
	parent_num_status_effects = parent.get_status_effects()
	if parent_num_status_effects <= 1 :
		position.x = 0
	elif parent_num_status_effects > 1:
		position.x = 4
	_poison_dmg()

func _poison_dmg():
	if !poison_on_cd:
		print("poison dmg")
		poison_on_cd = true
		parent.take_damage(poison_dmg)
		
		await get_tree().create_timer(tick_cd).timeout
		
		poison_on_cd = false

func _on_lifespan_timeout():
#	if parent.get_node_or_null("Sprite2D") != null:
#		parent.get_node_or_null("Sprite2D").modulate = Color.WHITE
#	if parent.get_node_or_null("AnimatedSprite2D") != null:
#		parent.get_node_or_null("AnimatedSprite2D").modulate = Color.WHITE

	queue_free()
