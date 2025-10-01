@tool
extends Control
@onready var countdown_label = $start_overlay/countdown_time
@onready var title = $Theme
@export var title_name:String = "タイトル!!!!"
@export var title_color:Color = Color(0,0,1)
@export var outline_color_black:bool = false
@export_group("Title Slide")
@export var title_slide:bool = true
@export var after_position:Vector2 = Vector2(537,103)
@export var after_size:int = 64
@export var after_outline:int = 20
@export var test:bool = false
@onready var thema_moved: Label = $Thema_moved
@onready var start_overlay: Control = $start_overlay

var tite_size:int = 64
var outline:int = 20
signal game_start
func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	visible = true
	title.text = title_name
	title.add_theme_color_override("font_color",title_color)
	if outline_color_black:
		title.add_theme_color_override("font_outline_color",Color(0,0,0))
	else:
		title.add_theme_color_override("font_outline_color",Color(1,1,1))
	countdown_label.visible = true
	countdown_label.text = "3"
func start_countdown()-> void:
	# カウントダウンを順番に実行
	await show_countdown("3",Color(0,1,0))
	await show_countdown("2",Color(1,0.5,0))
	await show_countdown("1",Color(1,0,0))
	await show_countdown("スタート！",Color(1,0,0))

	$start_overlay.visible = false
	if title_slide:
		var tween = create_tween()
		tween.tween_property(title,"position",after_position,0.1).set_ease(Tween.EASE_OUT)
		tween.parallel().tween_property(self,"tite_size",after_size,0.1)
		tween.parallel().tween_property(self,"outline",after_outline,0.1)
		await tween.finished
	else:
		title.visible = false
	emit_signal("game_start")
func show_countdown(text: String,color: Color) -> void:
	countdown_label.text = text
	countdown_label.add_theme_color_override("font_color",color)
	countdown_label.scale = Vector2(0.5, 0.5)
	
	var tween:Tween = create_tween()
	tween.tween_property(countdown_label, "scale", Vector2(1, 1), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	await get_tree().create_timer(0.5).timeout

func _process(delta: float) -> void:
	title.text = title_name
	title.add_theme_color_override("font_color",title_color)
	title.add_theme_color_override("font_outline_color",Color(0,0,0)if outline_color_black else Color(1,1,1))
	if Engine.is_editor_hint():
		thema_moved.visible = true if title_slide else false
		thema_moved.text = title_name
		thema_moved.add_theme_color_override("font_color",title_color)
		thema_moved.add_theme_color_override("font_outline_color",Color(0,0,0)if outline_color_black else Color(1,1,1))
		thema_moved.position = after_position
		thema_moved.add_theme_font_size_override("font_size",after_size)
		thema_moved.add_theme_constant_override("outline_size",after_outline)
		if test:
			start_overlay.visible = false
			title.visible = false
			thema_moved.modulate.a = 1.0
		else:
			start_overlay.visible = true
			title.visible = true
			thema_moved.modulate.a = 0.4
	else:
		thema_moved.visible = false
		title.add_theme_font_size_override("font_size",tite_size)
		title.add_theme_constant_override("outline_size",outline)
