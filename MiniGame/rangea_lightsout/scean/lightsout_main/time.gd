extends Control


@onready var game_timer:Timer = $Timer
@onready var time_label: Label = $clock/time
@onready var time_bar: TextureProgressBar = $clock/clockemeter
@onready var meter_bar: TextureProgressBar = $meter/bar
@onready var update_timer: Timer = $update
var max_time:float
var ratio_time: float
func _ready() -> void:
	game_timer.start()
	update_timer.start()
	max_time = game_timer.wait_time
	ratio_time = 100.0/max_time
func _on_update_timeout() -> void:
	var remaining_time: float = game_timer.time_left
	time_bar.value = (remaining_time-1)*ratio_time
	meter_bar.value = (remaining_time-1)*ratio_time
	time_label.text =str(int(remaining_time))
	meter_bar.tint_progress = get_meter_color((remaining_time-1)*ratio_time)
func get_meter_color(value: float) -> Color:
	value = clamp(value, 0, 100)
	var h: float = lerp(0.0, 0.33, value / 100.0)
	return Color.from_hsv(h, 1.0, 1.0)
