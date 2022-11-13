extends PanelContainer

onready var character = $Character
onready var equipment = $Overlay/Equipment
onready var popup = $PopupPanel
onready var popup_list = $PopupPanel/ImagesList

onready var class_label = $Overlay/ClassName/Label
onready var readonly_class_label = $Overlay/ClassName/ReadOnlyLabel
onready var stats_box = $Overlay/StatsBox

onready var screenshot = $Overlay/CaptureScreen
onready var save_profile_btn = $Overlay/Profiles/SaveProfile
onready var load_profile_btn = $Overlay/Profiles/LoadProfile

var image_source = ""
var current_slot
var config = ConfigFile.new()
var profile_popup = PopupMenu.new()

const save_path = "user://settings.cfg"

func _ready():
	var err = config.load(save_path)
	if err == OK:
		add_profiles_to_popup()
	add_child(profile_popup)
	
	get_tree().connect("files_dropped", self, "drop_image")
	for e in equipment.get_children():
		e.connect("pressed_slot", self, "show_equipment_list", [e])
		e.connect("clear_slot", e, "set_image", [""])
	popup_list.connect("equipment_selected", self, "set_equipment_for_current_slot")
	screenshot.connect("pressed", self, "take_screenshot")
	save_profile_btn.connect("pressed", self, "save_character_profile")
	load_profile_btn.connect("pressed", self, "display_profile_selector")
	connect("tree_exiting", config, "save", [save_path])

func set_equipment_for_current_slot(path):
	print(path)
	popup.hide()
	current_slot.set_image(path)
	current_slot = null

func show_equipment_list(_path, e):
	popup.popup_centered()
	current_slot = e

func take_screenshot():
	screenshot.hide()
	class_label.hide()
	readonly_class_label.show()
	readonly_class_label.text = class_label.text
	stats_box.readonly_mode()
	
	$Timer.start(0.5)
	yield($Timer, "timeout")
	
	var image = get_viewport().get_texture().get_data()
	image.flip_y()
	var path_select = FileDialog.new()
	add_child(path_select)
	path_select.access = FileDialog.ACCESS_FILESYSTEM
	path_select.window_title = 'Save a File'
	path_select.current_path = config.get_value("Settings", "last_save_path", path_select.current_path)
	path_select.popup_centered(Vector2(500,500))
	yield(path_select, "popup_hide")
	image.save_png(path_select.current_path)
	config.set_value("Settings", "last_save_path", path_select.current_path)
	
	class_label.show()
	readonly_class_label.hide()
	stats_box.editable_mode()
	screenshot.show()

func save_character_profile():
	var name = class_label.text
	config.set_value("Profile", name, stats_box.stats)
	config.set_value("Equipment", name, equipment.get_image_paths())
	config.save(save_path)

func display_profile_selector():
	profile_popup.popup_centered(Vector2(500,500))

func load_character_profile(index):
	var name = profile_popup.get_item_text(index)
	class_label.text = name
	var stats = config.get_value("Profile", name)
	for i in stats.keys():
		stats_box.update_level(stats[i], i)
	equipment.load_images(config.get_value("Equipment", name, []))

func add_profiles_to_popup():
	profile_popup.clear()
	for p in config.get_section_keys("Profile"):
		profile_popup.add_item(p)
	profile_popup.connect("index_pressed", self, "load_character_profile")

#func download_file():
#	var image = get_viewport().get_texture().get_data()
#	image.flip_y()
#	var buf = image.save_png_to_buffer()
#	JavaScript.download_buffer(buf, "screenshot.png")

func drop_image(files, _source):
	image_source = files[0]
	character.texture = load_image_from_filesystem(image_source)
	print(image_source)

func load_image_from_filesystem(path):
	var image_data = ImageTexture.new()
	var img = Image.new()
	img.load(path)
	image_data.create_from_image(img)
	return image_data
