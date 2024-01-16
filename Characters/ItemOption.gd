extends ColorRect

var mouse_over = false
var item = null
@onready var player = get_tree().get_first_node_in_group("players")

@onready var item_icon = $ColorRect/ItemIcon
@onready var item_name = $Name
@onready var description = $Description

signal selected_upgrade(upgrade)

func _ready():
	connect("selected_upgrade",Callable(player,"upgrade_character"))
	if (item == null):
		item = "broken_game"
	item_name.text = UPGRADE_DB.UPGRADES[item]["displayname"]
	description.text = UPGRADE_DB.UPGRADES[item]["detail"]
	item_icon.texture = load(UPGRADE_DB.UPGRADES[item]["icon"])
	
func _input(event):
	if event.is_action("click"):
		if mouse_over:
			emit_signal("selected_upgrade",item)

func _on_mouse_entered():
	mouse_over = true


func _on_mouse_exited():
	mouse_over = false
