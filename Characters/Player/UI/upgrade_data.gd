extends Node
@onready var player = get_tree().get_first_node_in_group("players")
var player_weapon

var projectile_dmg
var speed
var turn_speed
var max_health
var dmg_ratio
var armor_plate_visible
var crit_multiplier
var crit_chance


func _ready():
	player_weapon = player.get_node_or_null("Weapon")
	projectile_dmg = player_weapon.projectile_damage
	speed = player.SPEED
	max_health = player.MAX_HEALTH
	dmg_ratio = player.dmg_ratio
	armor_plate_visible = false
	
	

func match_item_upgrade(upgrade):
	match upgrade:
		"test_dmg":
			projectile_dmg += 10
		"test_movement":
			speed += 10
		"test_health":
			max_health += 20
		"armor_plate":
			dmg_ratio = 0.5
			armor_plate_visible = true
