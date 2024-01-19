extends Node

const ICON_PATH = "res://Art/Free-Skill-32x32-Icons-for-Cyberpunk-Game/1 Icons/1/"
const UPGRADES = {
	"test_dmg": {
		"icon": ICON_PATH + "Skillicon1_01.png",
		"displayname": "displayname dmg",
		"detail": "this is a test asdrasdfasdfkjhl",
		"prerequisite": [],
		"rarity": 0,
		"type": "dmg"
	},
	"test_health": {
		"icon": ICON_PATH + "Skillicon1_02.png",
		"displayname": "displayname health",
		"detail": "this is a test asdrasdfasdfkjhl",
		"prerequisite": [],
		"rarity": 0,
		"type": "defense"
	},
	"test_movement": {
		"icon": ICON_PATH + "Skillicon1_03.png",
		"displayname": "displayname movement",
		"detail": "this is a test asdrasdfasdfkjhl",
		"prerequisite": [],
		"rarity": 0,
		"type": "movement"
	},
	"test_consumable": {
		"icon": ICON_PATH + "Skillicon1_04.png",
		"displayname": "displayname consumable",
		"detail": "this is a test asdrasdfasdfkjhl",
		"prerequisite": [],
		"rarity": 0,
		"type": "test_consumable"
	},
	"armor_plate_1": {
		"icon": ICON_PATH + "Skillicon1_18.png",
		"displayname": "Deep Plating",
		"detail": "Reduces total damage taken by 8%",
		"prerequisite": [],
		"rarity": 0,
		"type": "defense"
	},
	"armor_plate_2": {
		"icon": ICON_PATH + "Skillicon1_18.png",
		"displayname": "Deep Plating+",
		"detail": "Reduces total damage taken by 18%",
		"prerequisite": ["armor_plate_1"],
		"rarity": 1,
		"type": "defense"
	},
	"armor_plate_3": {
		"icon": ICON_PATH + "Skillicon1_18.png",
		"displayname": "Deep Plating++",
		"detail": "Reduces damage taken by 30%",
		"prerequisite": ["armor_plate_2"],
		"rarity": 2,
		"type": "defense"
	},
	"crit_chance_1": {
		"icon": ICON_PATH + "Skillicon1_34.png",
		"displayname": "Adv. Targeting",
		"detail": "Increases critical hit chance to 15%",
		"prerequisite": [],
		"rarity": 0,
		"type": "dmg"
	},
	"crit_chance_2": {
		"icon": ICON_PATH + "Skillicon1_34.png",
		"displayname": "Adv. Targeting",
		"detail": "Increases critical hit chance to 35%",
		"prerequisite": ["crit_chance_1"],
		"rarity": 1,
		"type": "dmg"
	},
	"crit_chance_3": {
		"icon": ICON_PATH + "Skillicon1_34.png",
		"displayname": "Adv. Targeting",
		"detail": "Increases critical hit chance to 65%",
		"prerequisite": ["crit_chance_2"],
		"rarity": 2,
		"type": "dmg"
	},
	"proptosis": {
		"icon": ICON_PATH + "Skillicon1_04.png",
		"displayname": "Proptosis",
		"detail": "Short range mega tears",
		"prerequisite": [],
		"rarity": 2,
		"type": "dmg"
	},
	"twentytwenty": {
		"icon": ICON_PATH + "Skillicon1_22.png",
		"displayname": "20/20",
		"detail": "Double shot, damage down.",
		"prerequisite": [],
		"rarity": 1,
		"type": "dmg"
	},
	"soymilk": {
		"icon": ICON_PATH + "Skillicon1_22.png",
		"displayname": "Rapidfire Cannon",
		"detail": "Attack speed way up, damage way down",
		"prerequisite": [],
		"rarity": 2,
		"type": "dmg"
	},
	"aura_1": {
		"icon": ICON_PATH + "Skillicon1_12.png",
		"displayname": "Shock Plating",
		"detail": "Damaging aura",
		"prerequisite": [],
		"rarity": 0,
		"type": "dmg"
	},
	"aura_2": {
		"icon": ICON_PATH + "Skillicon1_12.png",
		"displayname": "Shock Plating+",
		"detail": "Aura size and tick rate up",
		"prerequisite": ["aura_1"],
		"rarity": 1,
		"type": "dmg"
	},
	"aura_3": {
		"icon": ICON_PATH + "Skillicon1_12.png",
		"displayname": "Shock Plating++",
		"detail": "Aura applies jolt, damaging affected enemies over time",
		"prerequisite": ["aura_2"],
		"rarity": 2,
		"type": "dmg"
	},
	"ipecac": {
		"icon": ICON_PATH + "Skillicon1_12.png",
		"displayname": "Ipecac",
		"detail": "Explosive Shots",
		"prerequisite": [],
		"rarity": 2,
		"type": "dmg"
	},
	"scorch_shot": {
		"icon": ICON_PATH + "Skillicon1_12.png",
		"displayname": "Firemind",
		"detail": "Bullets apply scorch",
		"prerequisite": [],
		"rarity": 2,
		"type": "dmg"
	},
	"broken_game": {
		"icon": ICON_PATH + "Skillicon1_09.png",
		"displayname": "Broken game!",
		"detail": "You aren't supposed to see this :0",
		"prerequisite": [],
		"rarity": 0,
		"type": "broke_the_game"
	}
}
