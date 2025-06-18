extends Control

@export var time_limit:float = 10.0
@export var change_value_color:bool = true
@export var meter_color: Color = Color(0,1,0)
@export_group("Gradation")
@export var meter_gradation: bool = true
@export  var start_color: Color = Color(0,1,0)
@export  var end_color: Color = Color(1,0,0)

@onready var game_timer:Timer = $Timer
@onready var time_label: Label = $clock/time
@onready var time_bar: TextureProgressBar = $clock/clockemeter
@onready var meter_bar: TextureProgressBar = $meter/bar
@onready var update_timer: Timer = $update
var ratio_time: float
signal  time_out
func _ready() -> void:
	game_timer.wait_time = time_limit
	game_timer.start()
	update_timer.start()
	ratio_time = 100.0/time_limit
func _on_update_timeout() -> void:
	var remaining_time: float = game_timer.time_left
	var ratio_now_time: float = remaining_time/time_limit
	
	#カラー
	if meter_gradation ==  true:
		meter_bar.tint_progress = get_meter_color((remaining_time-1)*ratio_time)	
	elif meter_gradation == false:
		meter_bar.tint_progress = meter_color
	
	if change_value_color == false:
		time_label.add_theme_color_override("font_color",Color(0,0,0))
	elif change_value_color == true:
		if ratio_now_time >= 0.5:
			time_label.add_theme_color_override("font_color",Color(0,0,0))
		elif ratio_now_time < 0.5 and ratio_now_time >= 0.25:
			time_label.add_theme_color_override("font_color",Color(1,0.5,0))
		elif ratio_now_time < 0.25:
			time_label.add_theme_color_override("font_color",Color(1,0,0))
	
	#メーター操作
	time_bar.value = (remaining_time-1)*ratio_time
	meter_bar.value = (remaining_time-1)*ratio_time
	time_label.text =str(int(remaining_time))
	
func get_meter_color(value: float) -> Color:
	value = clamp(value, 0, 100)
	var h: float = lerp(end_color.h, start_color.h, value / 100.0)
	var s: float = lerp(end_color.s, start_color.s, value / 100.0)
	var v: float = lerp(end_color.v, start_color.v, value / 100.0)
	return Color.from_hsv(h, s, v)
	
	
	


func _on_timer_timeout() -> void:
	emit_signal("time_out")
