extends CanvasLayer

@onready var boss_health_bar = $Control/TextureProgressBar
@onready var lerp_bar = $Control/lerp
@onready var boss = get_owner()

func _ready():
	boss.healthChanged.connect(_health_logic)
	Globs.children_allowed_to_move.connect(_visibility)

func _health_logic(percentHP):
	boss_health_bar.value = percentHP

	var tween = get_tree().create_tween()
	tween.tween_property(lerp_bar, "value", percentHP, 0.2)

func _visibility():
	visible = true
