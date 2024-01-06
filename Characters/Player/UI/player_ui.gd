extends CanvasLayer

@onready var cooldown_progress = %CooldownProgress
@onready var player_health_bar = %PlayerHealthBar

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
