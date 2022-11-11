extends PanelContainer

onready var character = $Character
onready var equipment = $Overlay/Equipment
onready var popup = $PopupPanel
onready var popup_list = $PopupPanel/ImagesList

onready var class_label = $Overlay/ClassName/Label
onready var readonly_class_label = $Overlay/ClassName/ReadOnlyLabel
onready var stats_box = $Overlay/StatsBox

onready var screenshot = $Overlay/CaptureScreen

var image_source = ""
var current_slot

func _ready():
	get_tree().connect("files_dropped", self, "drop_image")
	for e in equipment.get_children():
		e.connect("pressed_slot", self, "show_equipment_list", [e])
	popup_list.connect("equipment_selected", self, "set_equipment_for_current_slot")
	screenshot.connect("pressed", self, "take_screenshot")

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
	path_select.popup_centered(Vector2(500,500))
	yield(path_select, "popup_hide")
	image.save_png(path_select.current_path + "/screenshot.png")
	
	class_label.show()
	readonly_class_label.hide()
	stats_box.editable_mode()
	screenshot.show()
	
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
