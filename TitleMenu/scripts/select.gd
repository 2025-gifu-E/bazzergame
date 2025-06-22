extends Control

@onready var game_image: GridContainer = $MarginContainer/GameImage
@onready var game_name: Label = $GameName

@onready var cursor: TextureRect = $cursor

@onready var gameselect: AudioStreamPlayer = $gameselect

@onready var background: TextureRect = $background

var game:Array = []
var corsor_pos_offset:Vector2 = Vector2(-20,100)
var current_game_name:String = ""
var select_time:float = 0.1

#基本的にいじらなくても機能しますよ。
#逆にいじるとセレクトがうまくいかなくなるよ
func _ready() -> void:
	background.texture = preload("res://TitleMenu/sprites/高専.JPG")
	background.modulate = "#ffd747"
	game_image.modulate = "#ffffffff"
	cursor.modulate = "#ffffffff"
	game = []
	for child in game_image.get_children():
		game.append(child)
	await get_tree().process_frame
	cursor.global_position = game[0].global_position + (game[0].get_rect().size / 2) + corsor_pos_offset
	current_game_name = game[0].name
	print(cursor.global_position)
	await SceneManager.transition_finished
	select_game()

#基本的にいじらなくても機能しますよ。
#逆にいじるとセレクトがうまくいかなくなるよ
func _process(delta: float) -> void:
	if current_game_name != game_name.text:
		game_name.text = current_game_name
	
	if Input.is_action_just_pressed("enter"):
		SceneStorage.change_scene("撃ち落とせ!!!!")

#基本的にいじらなくても機能しますよ。
#逆にいじるとセレクトがうまくいかなくなるよ
func select_game() -> void:
	gameselect.play()
	var game_number:int = 0
	var game_random:int = randi_range(0,game.size())

	var roulette_minimum:int = game.size() * 6

	while game_random != 0 or roulette_minimum != 0:
		if game_number == game.size()-1:
			game_number = 0
		else:
			game_number += 1
		if roulette_minimum > 0:
			roulette_minimum -= 1
		game_random = randi_range(0,game.size())
		cursor.global_position = game[game_number].global_position + (game[game_number].get_rect().size / 2) + corsor_pos_offset
		current_game_name = game[game_number].name
		await get_tree().create_timer(select_time).timeout

	await get_tree().create_timer(0.5).timeout
	create_tween().tween_property(background,"texture",game[game_number].texture,0.5)
	create_tween().tween_property(game_image,"modulate",Color("#ffffff00"),0.5)
	create_tween().tween_property(cursor,"modulate",Color("#ffffff00"),0.5)
	create_tween().tween_property(game_name,"position",Vector2(50,249),0.5)
	await get_tree().create_timer(0.5).timeout
	background.texture = game[game_number].texture
	background.modulate = "#ffffff"
	create_tween().tween_property(game_name,"scale",Vector2(1.5,1.5),1.5)
	await get_tree().create_timer(1.0).timeout
	gameselect.stop()
	SceneStorage.change_scene(game[game_number].name)
