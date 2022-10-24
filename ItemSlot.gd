extends CenterContainer

var img_path = ""

signal pressed_slot(path)

func set_image(texture_path):
	img_path = texture_path
	$Item.texture = load(texture_path)

func _on_ItemSlot_gui_input(event):
	if event is InputEventMouseButton && event.pressed:
		emit_signal("pressed_slot", img_path)
