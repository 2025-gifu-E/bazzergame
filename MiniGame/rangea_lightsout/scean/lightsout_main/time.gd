extends Control


@onready var game_timer = $Timer
@onready var time_label = $clock/time
@onready var time_bar = $clock/clockemeter
@onready var update_timer = $update
func _ready():
	game_timer.start()
	update_timer.start()

func _on_update_timeout() -> void:
	var remaining_time = game_timer.time_left
	time_bar.value = (remaining_time-1)*5.0
	time_label.text =str(int(remaining_time))
