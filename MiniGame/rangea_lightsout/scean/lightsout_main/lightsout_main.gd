extends Control

@export var GRID_SIZE :int= 3
@export var random :int = 5
var grid_state :Array= []              # 二次元配列 (bool)
var grid_buttons:Array = []            # 二次元配列 (TextureButton)

@onready var grid_container = $MarginContainer/GridContainer
@onready var start = $CanvasLayer/startoverlay
@onready var bgm: AudioStreamPlayer = $BGM
@onready var gameoveroverlay: Control = $CanvasLayer/gameoveroverlay
@onready var clearoverlay: Control = $clearoverlay

var ButtonScene = preload("res://MiniGame/rangea_lightsout/scean/button/button.tscn")
var waiting_for_next_scene = false
func _ready() -> void:
	bgm.play()
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
	start.start_countdown()
	
func _on_startoverlay_game_start()->  void:
	# ゲーム開始
	grid_buttons[0][0].grab_focus()
	$time.time_start()
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
	clearoverlay.score = str(20-int(remaining_time))
	$time.time_stop()
	clearoverlay.clear_view()
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
	gameoveroverlay.gameover_view()
	await get_tree().create_timer(5.0).timeout
	SceneManager.change_scene("res://TitleMenu/title.tscn",{"skip_fade_out":true,"skip_fade_in":true})
	
func clear_focus_all():
	var focused = get_viewport().gui_get_focus_owner()
	if focused != null:
		focused.release_focus()
	# さらに明示的に Viewport 全体のフォーカス無効にする
