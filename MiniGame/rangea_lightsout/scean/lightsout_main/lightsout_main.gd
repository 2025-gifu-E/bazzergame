extends Control

@export var GRID_SIZE :int= 3
@export var random :int = 5
var grid_state :Array= []              # 二次元配列 (bool)
var grid_buttons:Array = []            # 二次元配列 (TextureButton)

@onready var grid_container = $MarginContainer/GridContainer
@onready var countdown_label = $startoverlay/countdown_time
@onready var bgm: AudioStreamPlayer = $BGM

var ButtonScene = preload("res://MiniGame/rangea_lightsout/scean/button/button.tscn")
var waiting_for_next_scene = false
func _ready() -> void:
	bgm.play()
	countdown_label.visible = true
	countdown_label.text = "3"
	grid_container.columns = GRID_SIZE
	
	for y in range(GRID_SIZE):
		var row_state = []
		var row_buttons = []
		for x in range(GRID_SIZE):
			row_state.append(false)  # 全部オフ
			var btn = ButtonScene.instantiate()
			btn.grid_x = x
			btn.grid_y = y
			btn.focus_mode = Control.FOCUS_ALL
			btn.pressed.connect(_on_button_pressed.bind(x, y))
			grid_container.add_child(btn)
			row_buttons.append(btn)
		grid_state.append(row_state)
		grid_buttons.append(row_buttons)
	randomize_grid_state(random)
	update_all_buttons()
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
	tween.tween_property($Theme,"position",Vector2(537,103),0.1).set_ease(Tween.EASE_OUT)
	await tween.finished
	grid_buttons[0][0].grab_focus()
	$time.time_start()

func show_countdown(text: String,color: Color) -> void:
	countdown_label.text = text
	countdown_label.add_theme_color_override("font_color",color)
	countdown_label.scale = Vector2(0.5, 0.5)
	
	var tween:Tween = create_tween()
	tween.tween_property(countdown_label, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await tween.finished
	await get_tree().create_timer(0.5).timeout


func _on_button_pressed(x: int, y: int)-> void:
	toggle(x, y)
	toggle(x - 1, y)
	toggle(x + 1, y)
	toggle(x, y - 1)
	toggle(x, y + 1)
	update_all_buttons()
	check_clear()

func toggle(x: int, y: int)-> void:
	if x >= 0 and x < GRID_SIZE and y >= 0 and y < GRID_SIZE:
		grid_state[y][x] = !grid_state[y][x]

func update_all_buttons()-> void:
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			grid_buttons[y][x].update_texture(grid_state[y][x])
func check_clear()-> void:
	for row in grid_state:
		if row.has(false):
			return
	print("ゲームクリア！")
	#clear_focus_all()
	var remaining_time:float = $time.time_left()
	$clearoverlay/VBoxContainer/cleartime.text ="クリアタイム:"+str(20-int(remaining_time))+"秒"
	$time.time_stop()
	$clearoverlay.visible = true
	$clearoverlay.modulate = Color(1, 1, 1, 0)  # 透明にしておく
	$clearoverlay.create_tween().tween_property($clearoverlay, "modulate:a", 1, 1.0)
	
	var return_button:Button = $clearoverlay/VBoxContainer/MarginContainer/titlebutton
	return_button.visible = true
	await get_tree().process_frame
	return_button.grab_focus()
	start_button_blink()
func start_button_blink():
	var tween:Tween = create_tween().set_loops()
	tween.tween_property($clearoverlay/VBoxContainer/MarginContainer/titlebutton, "modulate:a", 0.3, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property($clearoverlay/VBoxContainer/MarginContainer/titlebutton, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
func randomize_grid_state(count := 10)-> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()

	var positions = []
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			positions.append(Vector2i(x, y))

	positions.shuffle()

	for i in range(min(count, positions.size())):
		var pos = positions[i]
		grid_state[pos.y][pos.x] = true


func _on_timer_timeout() -> void:
	clear_focus_all()
	$gameoveroverlay.visible = true
	$gameoveroverlay.position.y = -self.size.y
	$gameoveroverlay/gameoverlabel.rotation = 0.0
	# Tweenで降りてくる
	var tween = create_tween()
	tween.tween_property($gameoveroverlay, "position:y", 0, 1.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_interval(0.1)
	tween.tween_property($gameoveroverlay/gameoverlabel, "rotation", 0.1, 0.1).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	await tween.finished
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://TitleMenu/title.tscn")
	
func clear_focus_all():
	var focused = get_viewport().gui_get_focus_owner()
	if focused != null:
		focused.release_focus()
	# さらに明示的に Viewport 全体のフォーカス無効にする


func _on_titlebutton_pressed() -> void:
	print("modoru")
	SceneManager.change_scene("res://TitleMenu/title.tscn",{"color":Color("#ffffff"),"speed":2.5})
