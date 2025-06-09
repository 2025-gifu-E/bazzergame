extends Control
@onready var curtain_l: ColorRect = $curtain_L
@onready var curtain_r: ColorRect = $curtain_R

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		print("aaaaaa")
		create_tween().tween_property(curtain_l,"scale",Vector2(0.15,1),0.3)
