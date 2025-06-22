extends Node2D

@onready var timer =$time
@onready var _label = $gameclear
@onready var _lavel2 = $gameover
@onready var target = $target
@onready var countdown_label = $startoverlay/countdown_time
@onready var theme: Label = $Theme
@onready var bgm: AudioStreamPlayer = $BGM


var gameover:bool = false
var gameclear:bool = false
var game_cleared:bool = false 
var game_start: bool = false

var target_font_size : float = 64
var outline : float =20


func _ready() -> void:
	bgm.play()
	start_countdown()
func start_countdown()-> void:
	# カウントダウンを順番に実行
	await show_countdown("3",Color(0,1,0))
	await show_countdown("2",Color(1,0.5,0))
	await show_countdown("1",Color(1,0,0))
	await show_countdown("スタート！",Color(1,0,0))
	
	$startoverlay.visible = false  # カウントダウン消す

	# ゲーム開始
	var tween = create_tween()
	tween.tween_property($Theme,"position",Vector2(223,90),0.1).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"target_font_size",24,0.1)
	tween.tween_property(self,"outline",10,0.1)
	await tween.finished
	game_start = true
	$time.time_start()

func show_countdown(text: String,color: Color) -> void:
	countdown_label.text = text
	countdown_label.add_theme_color_override("font_color",color)
	countdown_label.scale = Vector2(0.5, 0.5)
	
	var tween:Tween = create_tween()
	tween.tween_property(countdown_label, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await tween.finished
	await get_tree().create_timer(0.5).timeout
func _process(delta: float) -> void:
	theme.add_theme_font_size_override("font_size",target_font_size)
	theme.add_theme_constant_override("outline_size",outline)
	var cnt = 0
	for child in get_children():
		if "Tamakun" in child.name:
			cnt += 1
	if game_start and gameover==false and gameclear==false and cnt == 0:
		gameclear = true
		_label.visible = true
		target.visible = false
		timer.time_stop()
		for enemy in get_tree().get_nodes_in_group("tamas"):
			enemy.queue_free()
		await get_tree().create_timer(5.0).timeout
		SceneManager.change_scene("res://TitleMenu/title.tscn",{"color":Color("#ffffff"),"speed":2.5})

func _on_time_time_out() -> void:
	if gameclear == false and game_start:
		_lavel2.visible = true
		target.visible = false
		gameover = true
		for enemy in get_tree().get_nodes_in_group("tamas"):
				enemy.queue_free()
		get_tree().call_group("tamas","hide")
		get_tree().call_group("ozyamato-kunns","queue_free")
		timer.time_stop()
		await get_tree().create_timer(5.0).timeout
		SceneManager.change_scene("res://TitleMenu/title.tscn",{"color":Color("#ffffff"),"speed":2.5})
