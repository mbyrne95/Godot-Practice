extends Node

const ICON_PATH = "res://Art/Free-Skill-32x32-Icons-for-Cyberpunk-Game/1 Icons/1/"
const UPGRADES = {
	"dmg_1": {
		"icon": ICON_PATH + "Skillicon1_01.png",
		"displayname": "Power Module",
		"detail": "Projectile damage up",
		"prerequisite": [],
		"rarity": 0,
		"type": "dmg"
	},
	"dmg_2": {
		"icon": ICON_PATH + "Skillicon1_01.png",
		"displayname": "Power Module+",
		"detail": "Greater projectile damage up",
		"prerequisite": ["dmg_1"],
		"rarity": 1,
		"type": "dmg"
	},
	"dmg_3": {
		"icon": ICON_PATH + "Skillicon1_01.png",
		"displayname": "Power Module++",
		"detail": "Significant projectile damage up",
		"prerequisite": ["dmg_2"],
		"rarity": 2,
		"type": "dmg"
	},
	"as_1": {
		"icon": ICON_PATH + "Skillicon1_01.png",
		"displayname": "Onslaught",
		"detail": "Fire rate up",
		"prerequisite": [],
		"rarity": 0,
		"type": "dmg"
	},
	"as_2": {
		"icon": ICON_PATH + "Skillicon1_01.png",
		"displayname": "Onslaught+",
		"detail": "Greater fire rate up",
		"prerequisite": ["as_1"],
		"rarity": 1,
		"type": "dmg"
	},
	"as_3": {
		"icon": ICON_PATH + "Skillicon1_01.png",
		"displayname": "Onslaught++",
		"detail": "Significant fire rate up",
		"prerequisite": ["as_2"],
		"rarity": 2,
		"type": "dmg"
	},
	"health_scorch_combo": {
		"icon": ICON_PATH + "Skillicon1_01.png",
		"displayname": "Ember of Empyrean",
		"detail": "Scorch ignitions make you radiant, temporarily increasing damage & healing.",
		"prerequisite": ["health_regen_3", "scorch_shot"],
		"rarity": 3,
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
	"health_regen_1": {
		"icon": ICON_PATH + "Skillicon1_03.png",
		"displayname": "Self Repair Unit",
		"detail": "Passively regenerates health over time",
		"prerequisite": [],
		"rarity": 0,
		"type": "defense"
	},
	"health_regen_2": {
		"icon": ICON_PATH + "Skillicon1_03.png",
		"displayname": "Self Repair Unit+",
		"detail": "Passively regenerates greater health over time",
		"prerequisite": ["health_regen_1"],
		"rarity": 1,
		"type": "defense"
	},
	"health_regen_3": {
		"icon": ICON_PATH + "Skillicon1_03.png",
		"displayname": "Self Repair Unit++",
		"detail": "Passively regenerates significant health over time",
		"prerequisite": ["health_regen_2"],
		"rarity": 2,
		"type": "defense"
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
		"detail": "Aura applies jolt, increasing enemy's damage taken. Jolted enemies occassionally chain damage to other enemies.",
		"prerequisite": ["aura_2"],
		"rarity": 2,
		"type": "dmg"
	},
	"aura_as_combo": {
		"icon": ICON_PATH + "Skillicon1_12.png",
		"displayname": "Spark of Ions",
		"detail": "Jolted targets periodically spawn an ionic trace. Ionic traces temporarily increase movespeed and attack speed.",
		"prerequisite": ["aura_3", "as_3"],
		"rarity": 3,
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
		"detail": "Bullets apply scorch. Scorch deals increasing damage per stack, and ignites at 20 stacks.",
		"prerequisite": [],
		"rarity": 2,
		"type": "dmg"
	},
	"hatchling_1": {
		"icon": ICON_PATH + "Skillicon1_12.png",
		"displayname": "Infestation",
		"detail": "Sustained damage spawns a damaging threadling",
		"prerequisite": [],
		"rarity": 0,
		"type": "dmg"
	},
	"hatchling_2": {
		"icon": ICON_PATH + "Skillicon1_12.png",
		"displayname": "Infestation+",
		"detail": "Threadlings apply unravel, reducing enemy damage output",
		"prerequisite": ["hatchling_1"],
		"rarity": 1,
		"type": "dmg"
	},
	"woven_mail": {
		"icon": ICON_PATH + "Skillicon1_12.png",
		"displayname": "Thread of Warding",
		"detail": "Applying unravel grants you woven mail. Woven mail temporarily reduces damage taken by a significant amount.",
		"prerequisite": ["hatchling_2", "armor_plate_3"],
		"rarity": 3,
		"type": "dmg"
	},
	"range_up_size_down": {
		"icon": ICON_PATH + "Skillicon1_12.png",
		"displayname": "Mini Mush",
		"detail": "Range up, size down",
		"prerequisite": [],
		"rarity": 0,
		"type": "dmg"
	},
	"range_up_speed_up": {
		"icon": ICON_PATH + "Skillicon1_12.png",
		"displayname": "Roid Rage",
		"detail": "Range up, speed up",
		"prerequisite": [],
		"rarity": 1,
		"type": "dmg"
	},
	"range_up_damage_up": {
		"icon": ICON_PATH + "Skillicon1_12.png",
		"displayname": "Synthoil",
		"detail": "Range up, damage up",
		"prerequisite": [],
		"rarity": 1,
		"type": "dmg"
	},
	"dash_cooldown_1": {
		"icon": ICON_PATH + "Skillicon1_12.png",
		"displayname": "Dash CD",
		"detail": "Dash CD reduced by 10%",
		"prerequisite": [],
		"rarity": 0,
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
