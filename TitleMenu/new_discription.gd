@tool
extends Control
@onready var cursor: TextureRect = $cursor
@onready var start: Button = $start
@onready var timer: Timer = $Timer

@onready var time: Label = $flavortext_background/MarginContainer/timer_background/MarginContainer/time

@onready var discribe: AudioStreamPlayer = $discribe
@onready var game_name: Label = $flavortext_background/MarginContainer/gamename_background/MarginContainer/game_name
@onready var play_video: TextureRect = $"discription_background/MarginContainer/HBoxContainer/VBoxContainer/プレイ映像"
@onready var how_to_operate: Label = $discription_background/MarginContainer/HBoxContainer/VBoxContainer/操作方法
@onready var game_ex: Label = $discription_background/MarginContainer/HBoxContainer/ゲーム説明



#ルートノードのインスペクターからこの3つの値をいじれるよ
@export var discription:DiscriptionData:set = _on_data_changed
@export var timer_time:float = 11.0#説明を表示する時間を設定するよ。画面右上の数字だね
@export var fade_color:Color#画面の暗転の色をかえるよ

var title:PackedScene = preload("res://TitleMenu/title.tscn")
#基本的にいじらなくても機能しますよ。
#逆にいじるとすべてのゲームの説明画面に適応されるよ
func _ready() -> void:
	_update_display()
	if not Engine.is_editor_hint():
		discription = SceneStorage.change_resouce
		timer.wait_time = timer_time
		timer.start()
		cursor.global_position = start.global_position + Vector2(-40,0)
		start.grab_focus()
		await SceneManager.transition_finished
		discribe.play()

#基本的にいじらなくても機能しますよ。
#逆にいじるとすべてのゲームの説明画面に適応されるよ
func _process(delta: float) -> void:
	if not Engine.is_editor_hint():
		time.text = str(int(round(timer.time_left)))

#基本的にいじらなくても機能しますよ。
#逆にいじるとすべてのゲームの説明画面に適応されるよ
func _on_start_pressed() -> void:
	timer.stop()
	discribe.stop()
	SceneManager.change_scene(discription.Scean if discription else title,{"color":fade_color,"speed":2.0})
func _on_data_changed(value) -> void:
	discription = value
	call_deferred("_update_display")
func _update_display():
	if not is_inside_tree():
		print("ha")
		# ツリー未参加なら_ready()後に再実行
		call_deferred("_on_data_changed")
		return
	if discription:
		print("TextureRect:",play_video)
		game_name.text = discription.name
		play_video.texture = discription.screanshot
		how_to_operate.text = discription.how_to_oparate
		game_ex.text = discription.gema_explanation
		
	else:
		game_name.text = "ゲーム名!!!!"
		play_video.texture = preload("res://TitleMenu/sprites/スクリーンショット 2024-10-26 112119.png")
		how_to_operate.text = "操作方法をここに！！！"
		game_ex.text = "ゲーム説明をここに！！！"
