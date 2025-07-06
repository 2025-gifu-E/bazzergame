extends CanvasLayer

var debug_mode:bool = false

var hold_time := 2.0
var hold_timer := 0.0
var meter_value := 0.0
var triggered := false

var progress_bar: TextureProgressBar
var label: Label

func _ready():
	# メーター生成
	progress_bar = TextureProgressBar.new()
	add_child(progress_bar)
	progress_bar.nine_patch_stretch=true
	progress_bar.size = Vector2(64,64)
	progress_bar.position = Vector2(333,13)

	progress_bar.min_value = 0
	progress_bar.max_value = 100
	progress_bar.value = 0
	progress_bar.visible = false

	# 円形用テクスチャ設定
	progress_bar.texture_progress = preload("res://TitleMenu/sprites/circle_meter.png")


	progress_bar.fill_mode = TextureProgressBar.FILL_COUNTER_CLOCKWISE # 時計回りに進行
	progress_bar.tint_progress = Color(1,0,0)

	# ラベル生成
	label = Label.new()
	add_child(label)
	label.size=Vector2(750,100)
	label.position=Vector2(426,13)
	label.text = "タイトルに戻っています"
	label.visible = false
	label.add_theme_color_override("font_color", Color.RED)
	label.add_theme_color_override("outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 16)
	label.add_theme_font_size_override("font_size",30)

func _process(delta):
	if is_in_title():
		reset()
		return

	if Input.is_action_pressed("X") and debug_mode:
		hold_timer += delta
		meter_value = min(hold_timer / hold_time, 1.0)
		progress_bar.value = meter_value * 100
		progress_bar.visible = true
		label.visible=true
		if meter_value >= 0.33 and meter_value <=0.66:
			label.text = "タイトルに戻っています."
		elif meter_value >=0.66 and meter_value <= 0.99:
			label.text = "タイトルに戻っています.."
		elif meter_value >= 0.99:
			label.text = "タイトルに戻っています..."
		if hold_timer >= hold_time and not triggered:
			triggered = true
			label.visible = true
			
			return_to_title()
	else:
		reset()

func reset():
	hold_timer = 0.0
	meter_value = 0.0
	progress_bar.value = 0
	progress_bar.visible = false
	label.visible = false
	triggered = false
	label.text = "タイトルに戻っています"

func return_to_title():
	print("タイトルに戻ります")
	await get_tree().create_timer(0.5).timeout  # 0.5秒だけラベルを見せる
	SceneManager.change_scene("res://TitleMenu/title.tscn",{"color":Color("#ffffff"),"speed":2.5})  # 自分のタイトルシーンパスに変更

func is_in_title() -> bool:
	var current_scene = get_tree().current_scene
	return current_scene and current_scene.name == "title"
