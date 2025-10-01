extends Control

func free() -> void:
	visible = false
func gameover_view() -> void:
	visible = true
	position.y = -self.size.y
	$gameoverlabel.rotation = 0.0
	# Tweenで降りてくる
	var tween = create_tween()
	tween.tween_property(self, "position:y", 0, 1.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_interval(0.1)
	tween.tween_property($gameoverlabel, "rotation", 0.1, 0.1).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	await tween.finished
