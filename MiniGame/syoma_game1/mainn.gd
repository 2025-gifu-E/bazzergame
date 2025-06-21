extends Node2D



@onready var _label = $gameclear
func _process(delta: float) -> void:
	var cnt = 0
	for child in get_children():
		if "Tamakun" in child.name:
			cnt += 1
	if cnt == 0:
		_label.visible = true
