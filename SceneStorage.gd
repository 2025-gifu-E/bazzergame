extends Node

#ゲームを追加したら、match game_name:にselectシーンで追加したtexturerectの名前を""で続けて、
#game_pathに説明画面のシーンを入れよう
#直接シーンの名前をいれても一応機能するよ
func change_scene(game_name:String) -> void:
	var game_path:String
	if game_name.ends_with(".tscn"):#直接シーンの名前をいれても一応機能するよ
		game_path = game_name
	else:
		match game_name:
			"おとすな！！":#selectシーンで追加したtexturerectの名前をかこう
				game_path = "res://TitleMenu/discription.tscn"#game_pathに説明画面のシーンを入れよう
			"つけろ!!!!":
				game_path = "res://MiniGame/rangea_lightsout/scean/discription/discription.tscn"
			"撃ち落とせ!!!!":
				game_path = "res://MiniGame/syoma_game1/discription.tscn"

	SceneManager.change_scene(game_path,{"color":Color("#000000"),"speed":2.0})
