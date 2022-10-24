extends PanelContainer

onready var character = $Character
onready var equipment = $Overlay/Equipment
onready var popup = $PopupPanel
onready var popup_list = $PopupPanel/ImagesList

var image_source = ""
var current_slot

func _ready():
	get_tree().connect("files_dropped", self, "drop_image")
	for e in equipment.get_children():
		e.connect("pressed_slot", self, "show_equipment_list", [e])
	popup_list.connect("equipment_selected", self, "set_equipment_for_current_slot")

func set_equipment_for_current_slot(path):
	print(path)
	popup.hide()
	current_slot.set_image(path)
	current_slot = null

func show_equipment_list(_path, e):
	popup.popup_centered()
	current_slot = e

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
