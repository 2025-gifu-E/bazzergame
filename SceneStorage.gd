extends Node

func change_scene(game_name:String) -> void:
	var game_path:String
	match game_name:
		"おとすな！！":
			game_path = "res://TitleMenu/title.tscn"
		"name":
			game_path = "res://TitleMenu/title.tscn"
	
	SceneManager.change_scene(game_path,{"color":Color("#ffffff"),"speed":2.5})
