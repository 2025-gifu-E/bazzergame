extends Node

func change_scene(game_name:String) -> void:
	var game_path:String
	match game_name:
		"おとすな！！":
			game_path = "res://TitleMenu/title.tscn"
		"GameName2":
			game_path = "res://TitleMenu/title.tscn"
		"GameName3":
			game_path = "res://TitleMenu/title.tscn"
	
	SceneManager.change_scene(game_path,{"color":Color("#000000"),"speed":2.0})
