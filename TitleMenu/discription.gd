extends Control
@onready var cursor: TextureRect = $cursor
@onready var start: Button = $start
@onready var timer: Timer = $Timer

@onready var time: Label = $flavortext_background/MarginContainer/timer_background/MarginContainer/time

func _ready() -> void:
	timer.start()
	cursor.global_position = start.global_position + Vector2(-40,0)
	start.grab_focus()
	await SceneManager.transition_finished

func _process(delta: float) -> void:
	time.text = str(int(round(timer.time_left)))


func _on_start_pressed() -> void:
	timer.stop()
	SceneStorage.change_scene("res://TitleMenu/title.tscn")
