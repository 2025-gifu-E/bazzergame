extends Control
@onready var curtain_l: ColorRect = $curtain_L
@onready var curtain_r: ColorRect = $curtain_R
@onready var start_text: RichTextLabel = $start_text
@onready var debug_meter: TextureProgressBar = $debug_meter

@onready var bgm: AudioStreamPlayer = $BGM

var curtain_time:float = 1.0

@onready var shutter: TextureRect = $shutter

@export var can_debug_mode:bool = true
var hold_time := 1.0  # 長押し判定時間（秒）
var hold_timer := 0.0
var is_button_held := false
var toggled := false
var meter_value:float = 0
#基本的にいじらなくても機能しますよ。
#逆にいじるとセレクトがうまくいかなくなるよ
func _ready() -> void:
	#bgm.play()
	start_text.show()
	curtain_l.scale = Vector2(1,1)
	curtain_r.scale = Vector2(1,1)

#基本的にいじらなくても機能しますよ。
#逆にいじるとセレクトがうまくいかなくなるよ
func _process(delta: float) -> void:
	debug_meter.value = meter_value*100
	if Global.debug_mode:
		$debugtext.visible=true
	else:
		$debugtext.visible=false
	if Input.is_action_just_pressed("enter"):
		start_text.hide()
		print("aaaaaa")
		create_tween().tween_property(shutter,"scale",Vector2(1,0.1),curtain_time).set_ease(Tween.EASE_OUT)
		create_tween().tween_property(curtain_l,"scale",Vector2(0.15,1),curtain_time).set_ease(Tween.EASE_OUT)
		create_tween().tween_property(curtain_r,"scale",Vector2(0.15,1),curtain_time).set_ease(Tween.EASE_OUT)
		await get_tree().create_timer(curtain_time).timeout
		SceneManager.change_scene("res://TitleMenu/select.tscn",{"color":Color("#ffffff"),"speed":2.5})
	if Input.is_action_pressed("X")and can_debug_mode:  # 入力アクション名を設定
		hold_timer += delta
		if toggled == false:
			meter_value = min(hold_timer / hold_time, 1.0)
		if hold_timer >= hold_time and not toggled:
			Global.debug_mode = !Global.debug_mode
			meter_value = 0.0
			print("Debug toggled:", Global.debug_mode)
			toggled = true  # 1回だけトグル
	else:
		hold_timer = 0.0
		meter_value = 0.0
		toggled = false
