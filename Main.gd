extends PanelContainer

onready var character = $Character

var image_source = ""

func _ready():
	get_tree().connect("files_dropped", self, "drop_image")

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
