extends Node

const ICON_PATH = "res://Art/Free-Skill-32x32-Icons-for-Cyberpunk-Game/1 Icons/1/"
const UPGRADES = {
	"test_dmg": {
		"icon": ICON_PATH + "Skillicon1_01.png",
		"displayname": "displayname dmg",
		"detail": "this is a test asdrasdfasdfkjhl",
		"prerequisite": [],
		"type": "dmg"
	},
	"test_health": {
		"icon": ICON_PATH + "Skillicon1_02.png",
		"displayname": "displayname health",
		"detail": "this is a test asdrasdfasdfkjhl",
		"prerequisite": [],
		"type": "defense"
	},
	"test_movement": {
		"icon": ICON_PATH + "Skillicon1_03.png",
		"displayname": "displayname movement",
		"detail": "this is a test asdrasdfasdfkjhl",
		"prerequisite": [],
		"type": "movement"
	},
	"test_consumable": {
		"icon": ICON_PATH + "Skillicon1_04.png",
		"displayname": "displayname consumable",
		"detail": "this is a test asdrasdfasdfkjhl",
		"prerequisite": [],
		"type": "test_consumable"
	},
	"armor_plate_1": {
		"icon": ICON_PATH + "Skillicon1_18.png",
		"displayname": "Deep Plating",
		"detail": "Reduces total damage taken by 8%",
		"prerequisite": [],
		"type": "defense"
	},
	"armor_plate_2": {
		"icon": ICON_PATH + "Skillicon1_18.png",
		"displayname": "Deep Plating+",
		"detail": "Reduces total damage taken by 18%",
		"prerequisite": ["armor_plate_1"],
		"type": "defense"
	},
	"armor_plate_3": {
		"icon": ICON_PATH + "Skillicon1_18.png",
		"displayname": "Deep Plating++",
		"detail": "Reduces damage taken by 30%",
		"prerequisite": ["armor_plate_2"],
		"type": "defense"
	},
	"crit_chance_1": {
		"icon": ICON_PATH + "Skillicon1_34.png",
		"displayname": "Adv. Targeting",
		"detail": "Increases critical hit chance by 15%",
		"prerequisite": [],
		"type": "dmg"
	},
	"proptosis": {
		"icon": ICON_PATH + "Skillicon1_04.png",
		"displayname": "Proptosis",
		"detail": "Short range mega tears",
		"prerequisite": [],
		"type": "dmg"
	},
	"twentytwenty": {
		"icon": ICON_PATH + "Skillicon1_22.png",
		"displayname": "20/20",
		"detail": "Double shot, damage down.",
		"prerequisite": [],
		"type": "dmg"
	},
	"soymilk": {
		"icon": ICON_PATH + "Skillicon1_22.png",
		"displayname": "Rapidfire Cannon",
		"detail": "Attack speed way up, damage way down.",
		"prerequisite": [],
		"type": "dmg"
	},
	"aura": {
		"icon": ICON_PATH + "Skillicon1_12.png",
		"displayname": "sunfire cape",
		"detail": "dmg aura",
		"prerequisite": [],
		"type": "dmg"
	},
	"ipecac": {
		"icon": ICON_PATH + "Skillicon1_12.png",
		"displayname": "Ipecac",
		"detail": "Explosive Shots",
		"prerequisite": [],
		"type": "dmg"
	},
	"broken_game": {
		"icon": ICON_PATH + "Skillicon1_09.png",
		"displayname": "Broken game!",
		"detail": "You aren't supposed to see this :0",
		"prerequisite": [],
		"type": "broke_the_game"
	}
}
