extends TextureButton

@export var tex_on: Texture
@export var tex_off: Texture
@export var tex_on_hover: Texture
@export var tex_off_hover: Texture

var grid_x: int
var grid_y: int

func _ready():
	update_texture()

func toggle_pressed():
	button_pressed = !button_pressed
	update_texture()

func update_texture():
	texture_normal = tex_on if button_pressed else tex_off
	texture_focused = tex_on_hover if button_pressed else tex_off_hover
