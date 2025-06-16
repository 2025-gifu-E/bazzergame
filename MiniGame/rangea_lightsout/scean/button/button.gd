extends TextureButton

@export var tex_on: Texture
@export var tex_off: Texture
@export var tex_on_hover: Texture
@export var tex_off_hover: Texture

var grid_x: int
var grid_y: int
var press: bool


func update_texture(is_on: bool):
	press = is_on
	if press:
		texture_normal = tex_on
		texture_focused = tex_on_hover
	else:
		texture_normal = tex_off
		texture_focused = tex_off_hover
