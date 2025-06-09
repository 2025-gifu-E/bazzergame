extends Control

@onready var game_image: GridContainer = $MarginContainer/GameImage
@onready var game_name: Label = $GameName

@onready var cursor: TextureRect = $cursor


var game:Array = []
var corsor_pos_offset:Vector2 = Vector2(150,150)
var current_game_name:String = ""
var select_time:float = 0.1


func _ready() -> void:
	game = []
	for child in game_image.get_children():
		game.append(child)
	cursor.position = game[0].position + corsor_pos_offset
	current_game_name = game[0].name
	await SceneManager.transition_finished
	select_game()



func _process(delta: float) -> void:
	if current_game_name != game_name.text:
		game_name.text = current_game_name
	
	if Input.is_action_just_pressed("enter"):
		SceneStorage.change_scene("おとすな！！")

func select_game() -> void:
	var game_number:int = 0
	var game_random:int = randi_range(0,game.size())
	while game_random != 0:
		if game_number == game.size()-1:
			game_number = 0
		else:
			game_number += 1
		game_random = randi_range(0,game.size())
		cursor.position = game[game_number].position + corsor_pos_offset
		current_game_name = game[game_number].name
		await get_tree().create_timer(select_time).timeout
