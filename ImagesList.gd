extends ScrollContainer

onready var list = $List
onready var item_slot = preload("res://ItemSlot.tscn")

signal equipment_selected(path)

func _ready():
	var sections = get_sections()
	for s in sections:
		var heading = Button.new()
		list.add_child(heading)
		heading.add_font_override("Font", load("res://Assets/StatsFont.tres"))
		heading.text = s
		heading.connect("pressed", self, "load_images_for_section", [s, heading])

func load_images_for_section(section, node):
	var img_grid = GridContainer.new()
	img_grid.columns = 10
	list.add_child_below_node(node, img_grid)
	var img_list = get_images(section)
	for i in img_list:
		var slot = item_slot.instance()
		img_grid.add_child(slot)
		slot.set_image(i)
		slot.connect("pressed_slot", self, "notify_fill_item_slot")

func create_image_slot(img_path):
	var texture = load(img_path)
	var slot = item_slot.instance()
	slot.set_image(texture)
	return slot

func get_sections():
	var sections = []
	var dir = Directory.new()
	if dir.open("res://Assets/Weapons") == OK:
		dir.list_dir_begin()
		var fname = dir.get_next()
		while fname != "":
			if dir.current_is_dir():
				sections.append(fname)
			fname = dir.get_next()
	sections.pop_front()
	sections.pop_front()
	return sections

func get_images(section):
	var images = []
	var dir = Directory.new()
	if dir.open("res://Assets/Weapons/"+section) == OK:
		dir.list_dir_begin()
		var fname = dir.get_next()
		while fname != "":
			if not dir.current_is_dir() && not fname.ends_with(".import"):
				images.append("res://Assets/Weapons/"+section+"/"+fname)
			fname = dir.get_next()
	else:
		print("Found no images for " + section)
	return images

func notify_fill_item_slot(path):
	print(path)
	emit_signal("equipment_selected", path)
