extends Control

@export var GRID_SIZE :int= 3
@export var random :int = 5
var grid_state := []              # 二次元配列 (bool)
var grid_buttons := []            # 二次元配列 (TextureButton)

@onready var grid_container = $MarginContainer/GridContainer
var ButtonScene = preload("res://MiniGame/rangea_lightsout/scean/button/button.tscn")
func _ready():
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
	grid_buttons[0][0].grab_focus()
func _on_button_pressed(x: int, y: int):
	toggle(x, y)
	toggle(x - 1, y)
	toggle(x + 1, y)
	toggle(x, y - 1)
	toggle(x, y + 1)
	update_all_buttons()
	check_clear()

func toggle(x: int, y: int):
	if x >= 0 and x < GRID_SIZE and y >= 0 and y < GRID_SIZE:
		grid_state[y][x] = !grid_state[y][x]

func update_all_buttons():
	for y in range(GRID_SIZE):
		for x in range(GRID_SIZE):
			grid_buttons[y][x].update_texture(grid_state[y][x])
func check_clear():
	for row in grid_state:
		if row.has(false):
			return
	print("ゲームクリア！")
	release_focus()
	var remaining_time = $time/Timer.time_left
	$clearoverlay/VBoxContainer/cleartime.text ="クリアタイム:"+str(20-int(remaining_time))+"秒"
	$time/Timer.stop()
	$clearoverlay.visible = true
	$clearoverlay.modulate = Color(1, 1, 1, 0)  # 透明にしておく
	$clearoverlay.create_tween().tween_property($clearoverlay, "modulate:a", 1, 1.0)
	
	# 数秒後にシーン切り替え
	await get_tree().create_timer(3.0).timeout
	get_tree().change_scene_to_file("res://TitleMenu/select.tscn")

func randomize_grid_state(count := 10):
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
	release_focus()
	$gameoveroverlay.visible = true
	$gameoveroverlay.modulate = Color(1, 1, 1, 0)  # 透明にしておく
	$gameoveroverlay.create_tween().tween_property($gameoveroverlay, "modulate:a", 1, 1.0)
