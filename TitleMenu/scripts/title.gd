extends Control
@onready var curtain_l: ColorRect = $curtain_L
@onready var curtain_r: ColorRect = $curtain_R
@onready var start_text: Label = $start_text


func _ready() -> void:
	start_text.show()
	curtain_l.scale = Vector2(1,1)
	curtain_r.scale = Vector2(1,1)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		start_text.hide()
		print("aaaaaa")
		create_tween().tween_property(curtain_l,"scale",Vector2(0.15,1),0.5).set_ease(Tween.EASE_OUT)
		create_tween().tween_property(curtain_r,"scale",Vector2(0.15,1),0.5).set_ease(Tween.EASE_OUT)
