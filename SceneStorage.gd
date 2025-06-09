extends Node

func change_scene(game_name:String) -> void:
	var game_path:String
	if game_name.ends_with(".tscn"):
		game_path = game_name
	else:
		match game_name:
			"おとすな！！":
				game_path = "res://TitleMenu/discription.tscn"
			"GameName2":
				game_path = "res://TitleMenu/discription.tscn"
			"GameName3":
				game_path = "res://TitleMenu/discription.tscn"

	SceneManager.change_scene(game_path,{"color":Color("#000000"),"speed":2.0})
