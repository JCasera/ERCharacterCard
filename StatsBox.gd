extends VBoxContainer

onready var level_value = $Level/Value

var min_stat_total = 80
var stats = {
	"Vigor": 10,
	"Mind": 10,
	"Strength": 10,
	"Endurance": 10,
	"Dexterity": 10,
	"Intelligence": 10,
	"Faith": 10,
	"Arcane": 10
}

func _ready():
	#Connect all stat selectors to update level and stat total
	$Arcane/Selector.connect("value_changed", self, "update_level", ["Arcane"])
	$Faith/Selector.connect("value_changed", self, "update_level", ["Faith"])
	$Intelligence/Selector.connect("value_changed", self, "update_level", ["Intelligence"])
	$Dexterity/Selector.connect("value_changed", self, "update_level", ["Dexterity"])
	$Strength/Selector.connect("value_changed", self, "update_level", ["Strength"])
	$Endurance/Selector.connect("value_changed", self, "update_level", ["Endurance"])
	$Mind/Selector.connect("value_changed", self, "update_level", ["Mind"])
	$Vigor/Selector.connect("value_changed", self, "update_level", ["Vigor"])

func update_level(value, stat):
	stats[stat] = value
	var current_stat_total = calc_stat_total()
	print("Value: " + str(value) + " Stat Total: " + str(current_stat_total))
	var level_change = current_stat_total - min_stat_total
	if level_change < 0:
		level_value.text = "1"
		level_value.self_modulate = Color.red
	else:
		level_value.text = str(level_change + 1)
		level_value.self_modulate = Color.white

func calc_stat_total():
	var total = 0
	for i in stats.values():
		total += i
	return total
