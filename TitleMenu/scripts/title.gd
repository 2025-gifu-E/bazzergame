extends Control
@onready var curtain_l: ColorRect = $curtain_L
@onready var curtain_r: ColorRect = $curtain_R
@onready var start_text: RichTextLabel = $start_text

@onready var bgm: AudioStreamPlayer = $BGM

var curtain_time:float = 1.0

@onready var shutter: TextureRect = $shutter

@export var can_debug_mode:bool = true
var debug_mode := false
var hold_time := 1.0  # 長押し判定時間（秒）
var hold_timer := 0.0
var is_button_held := false
var toggled := false
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
	if debug_mode:
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
		if not is_button_held:
			print("hold")
			# 押し始めた瞬間
			hold_timer = 0.0
			is_button_held = true
			toggled = false
		hold_timer += delta
		print(hold_timer)
		if hold_timer >= hold_time and not toggled:
			debug_mode = !debug_mode
			print("Debug toggled:", debug_mode)
			toggled = true  # 一度だけトグルする
	else:
		is_button_held = false
