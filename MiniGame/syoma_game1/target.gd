extends Area2D

@export var target_speed:float = 500.0
signal shot
var control:float = 1.0
func _ready() -> void:
	for enemy in get_tree().get_nodes_in_group("tamas"):
		self.shot.connect(enemy._on_target_shot)
func _process(delta: float) -> void:
	var input_vecter:Vector2 = Input.get_vector(
		"ui_left","ui_right",
		"ui_up","ui_down"
	)
	position+= input_vecter*target_speed*control*delta
	
	var screen_size:Vector2 = get_viewport().size
	position.x = clamp(position.x,0,screen_size.x)
	position.y = clamp(position.y,0,screen_size.y)
	if Input.is_action_just_pressed("enter"):
		print("shot")
		shot.emit()
	if Input.is_action_pressed("B"):
		control = 0.5
	elif Input.is_action_pressed("Y") or Input.is_action_pressed("L"):
		control = 1.5
	else:
		control = 1.0
func _on_area_entered(area):
	if area.is_in_group("tamas"):
		var tween:Tween = create_tween()
		tween.tween_property(self,"rotation",0.785,0.05)
func _on_area_exited(area):
	if area.is_in_group("tamas"):
		var tween:Tween = create_tween()
		tween.tween_property(self,"rotation",0,0.05)
