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
	get_node(stat + "/Value").text = str(value) + "       "

func calc_stat_total():
	var total = 0
	for i in stats.values():
		total += i
	return total

func editable_mode():
	$Arcane/Selector.show()
	$Faith/Selector.show()
	$Intelligence/Selector.show()
	$Dexterity/Selector.show()
	$Strength/Selector.show()
	$Endurance/Selector.show()
	$Mind/Selector.show()
	$Vigor/Selector.show()
	
	$Arcane/Value.hide()
	$Faith/Value.hide()
	$Intelligence/Value.hide()
	$Dexterity/Value.hide()
	$Strength/Value.hide()
	$Endurance/Value.hide()
	$Mind/Value.hide()
	$Vigor/Value.hide()

func readonly_mode():
	$Arcane/Selector.hide()
	$Faith/Selector.hide()
	$Intelligence/Selector.hide()
	$Dexterity/Selector.hide()
	$Strength/Selector.hide()
	$Endurance/Selector.hide()
	$Mind/Selector.hide()
	$Vigor/Selector.hide()
	
	$Arcane/Value.show()
	$Faith/Value.show()
	$Intelligence/Value.show()
	$Dexterity/Value.show()
	$Strength/Value.show()
	$Endurance/Value.show()
	$Mind/Value.show()
	$Vigor/Value.show()
