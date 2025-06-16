extends Control
@onready var cursor: TextureRect = $cursor
@onready var start: Button = $start
@onready var timer: Timer = $Timer

@onready var time: Label = $flavortext_background/MarginContainer/timer_background/MarginContainer/time

@onready var discribe: AudioStreamPlayer = $discribe

#ルートノードのインスペクターからこの3つの値をいじれるよ
@export var timer_time:float = 11.0#説明を表示する時間を設定するよ。画面右上の数字だね
@export var game_scene:PackedScene#ここにファイルからゲームのシーンをいれてね
@export var fade_color:Color#画面の暗転の色をかえるよ

#基本的にいじらなくても機能しますよ。
#逆にいじるとすべてのゲームの説明画面に適応されるよ
func _ready() -> void:
	timer.wait_time = timer_time
	timer.start()
	cursor.global_position = start.global_position + Vector2(-40,0)
	start.grab_focus()
	await SceneManager.transition_finished
	discribe.play()

#基本的にいじらなくても機能しますよ。
#逆にいじるとすべてのゲームの説明画面に適応されるよ
func _process(delta: float) -> void:
	time.text = str(int(round(timer.time_left)))

#基本的にいじらなくても機能しますよ。
#逆にいじるとすべてのゲームの説明画面に適応されるよ
func _on_start_pressed() -> void:
	timer.stop()
	discribe.stop()
	SceneManager.change_scene(game_scene,{"color":fade_color,"speed":2.0})
