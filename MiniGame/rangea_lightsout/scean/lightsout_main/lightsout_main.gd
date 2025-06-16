extends Node2D

const GRID_SIZE = 5
@onready var grid_container = $GridContainer
var grid = []
var ButtonScene = preload("res://MiniGame/rangea_lightsout/scean/button/button.tscn")  # プレハブボタン

func _ready():
	grid_container.columns = GRID_SIZE
	for y in range(GRID_SIZE):
		grid.append([])
		for x in range(GRID_SIZE):
			var btn = ButtonScene.instantiate()
			btn.toggle_mode = true
			btn.custom_minimum_size = Vector2(64, 64)
			btn.text = ""
			btn.pressed.connect(_on_button_pressed.bind(x, y))
			grid_container.add_child(btn)
			grid[y].append(btn)

func _on_button_pressed(x: int, y: int) -> void:
	_toggle(x, y)
	_toggle(x - 1, y)
	_toggle(x + 1, y)
	_toggle(x, y - 1)
	_toggle(x, y + 1)

	if _check_cleared():
		print("クリア！")

func _toggle(x: int, y: int) -> void:
	if x >= 0 and x < GRID_SIZE and y >= 0 and y < GRID_SIZE:
		var btn = grid[y][x]
		btn.button_pressed = !btn.button_pressed

func _check_cleared() -> bool:
	for row in grid:
		for btn in row:
			if btn.button_pressed:
				return false
	return true
