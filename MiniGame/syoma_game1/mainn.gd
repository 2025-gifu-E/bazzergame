extends Node2D

@onready var timer =$time
@onready var _label = $gameclear
@onready var _lavel2 = $gameover
@onready var target = $target
@onready var title = $CanvasLayer/start_countdown
@onready var clearoverlay: Control = $CanvasLayer/clearoverlay

@onready var bgm: AudioStreamPlayer = $BGM


var gameover:bool = false
var gameclear:bool = false
var game_cleared:bool = false 
var game_start: bool = false

var target_font_size : float = 64
var outline : float =20


func _ready() -> void:
	bgm.play()
	title.start_countdown()

	# ゲーム開始
func _on_start_countdown_game_start() ->  void:
	game_start = true
	$time.time_start()

func _process(delta: float) -> void:
	var cnt = 0
	for child in get_children():
		if "Tamakun" in child.name:
			cnt += 1
	if game_start and gameover==false and gameclear==false and cnt == 0:
		var remaining_time:float = timer.time_left()
		clearoverlay.score = str(20-int(remaining_time))
		gameclear = true
		target.visible = false
		timer.time_stop()
		for enemy in get_tree().get_nodes_in_group("tamas"):
			enemy.queue_free()
		clearoverlay.clear_view()

func _on_time_time_out() -> void:
	if gameclear == false and game_start:
		target.visible = false
		gameover = true
		for enemy in get_tree().get_nodes_in_group("tamas"):
				enemy.queue_free()
		get_tree().call_group("tamas","hide")
		get_tree().call_group("ozyamato-kunns","queue_free")
		timer.time_stop()
		$CanvasLayer/gameoveroverlay.gameover_view()
		await get_tree().create_timer(5.0).timeout
		SceneManager.change_scene("res://TitleMenu/title.tscn",{"color":Color("#ffffff"),"speed":2.5})
