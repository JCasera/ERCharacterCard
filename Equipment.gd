extends HBoxContainer

func get_image_paths():
	var imgs = []
	for i in get_children():
		imgs.append(i.img_path)
	return imgs

func load_images(imgs):
	if imgs == []:
		return
	
	for i in get_child_count():
		if i < imgs.size():
			get_child(i).set_image(imgs[i])
