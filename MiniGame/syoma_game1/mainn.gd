extends Node2D

@onready var timer = $time
@onready var _label = $gameclear
@onready var _lavel2 = $gameover

func _ready() -> void:
	timer.time_start()

func _process(delta: float) -> void:
	var cnt = 0
	for child in get_children():
		if "Tamakun" in child.name:
			cnt += 1
	if cnt == 0:
		_label.visible = true


func _on_time_time_out() -> void:
	_lavel2.visible = true
	
	
	
