extends CenterContainer

var img_path = ""

signal pressed_slot(path)
signal clear_slot

func set_image(texture_path):
	img_path = texture_path
	if img_path == "":
		$Item.texture = null
	else:
		$Item.texture = load(img_path)

func _on_ItemSlot_gui_input(event):
	if event is InputEventMouseButton && event.pressed:
		if event.button_index == BUTTON_LEFT:
			emit_signal("pressed_slot", img_path)
		else:
			emit_signal("clear_slot")
