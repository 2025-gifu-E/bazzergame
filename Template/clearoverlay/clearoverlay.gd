@tool
extends Control
@onready var titlebutton: Button = $VBoxContainer/MarginContainer/titlebutton
@onready var clearscore: Label = $VBoxContainer/clearscore

@export var use_score:bool = true
@export var score_text:String = "クリアタイム:"
@export var after_score_text:String = "秒"
var score:String = "--"
func clear_view() -> void:
	clearscore.text = score_text + score + after_score_text
	visible = true
	modulate = Color(1, 1, 1, 0)  # 透明にしておく
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1, 1.0)
	var return_button:Button = titlebutton
	return_button.visible = true
	return_button.disabled = true
	await get_tree().process_frame
	return_button.grab_focus()
	start_button_blink()
	await tween.finished
	return_button.disabled = false
func start_button_blink():
	var tween:Tween = create_tween().set_loops()
	tween.tween_property(titlebutton, "modulate:a", 0.3, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(titlebutton, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		clearscore.visible = use_score
		clearscore.text = score_text + score + after_score_text

func _ready() -> void:
	visible = false
	clearscore.visible = use_score

func _on_titlebutton_pressed() -> void:
	SceneManager.change_scene("res://TitleMenu/title.tscn",{"color":Color("#ffffff"),"speed":2.5})
