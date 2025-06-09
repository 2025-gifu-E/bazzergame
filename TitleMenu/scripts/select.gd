extends Control


func _ready() -> void:
	await SceneManager.fade_complete
	slect_game()



func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		SceneStorage.change_scene("おとすな！！")

func select_game() -> void:
	
