extends TextureRect
class_name SelectRect

@export var game_discription:DiscriptionData
var discription_scean:PackedScene = preload("res://TitleMenu/new_discription.tscn")
func change_scean() ->void:
	SceneStorage.change_resouce = game_discription
	SceneManager.change_scene(discription_scean,{"color":Color("#000000"),"speed":2.0})
