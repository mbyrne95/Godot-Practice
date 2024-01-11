extends CanvasLayer

@onready var cooldown_progress = %CooldownProgress
@onready var player_health_bar = %PlayerHealthBar
@onready var lerp_bar = %lerp

@onready var player = get_owner()

func _ready():
	Globs.blinkProgress.connect(_on_cooldown_progress)
	Globs.blinkReady.connect(_on_cooldown_finished)
	player.healthChanged.connect(_health_logic)

func _on_cooldown_progress(progress):
	#print(progress)
	cooldown_progress.value = progress
	
func _on_cooldown_finished():
	cooldown_progress.value = 1

func _health_logic(percentHP):
	player_health_bar.value = percentHP
	if player_health_bar.value <= 0.66 && player_health_bar.value > 0.33:
		player_health_bar.tint_progress = Color(0.98,0.95,0.21,1)
	elif player_health_bar.value <= 0.33:
		player_health_bar.tint_progress = Color(0.85,0.34,0.39,1)
		
	var tween = get_tree().create_tween()
	tween.tween_property(lerp_bar, "value", percentHP, 0.2)
