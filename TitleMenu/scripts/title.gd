extends Control
@onready var curtain_l: ColorRect = $curtain_L
@onready var curtain_r: ColorRect = $curtain_R
@onready var start_text: RichTextLabel = $start_text

@onready var bgm: AudioStreamPlayer = $BGM

var curtain_time:float = 0.5

func _ready() -> void:
	bgm.play()
	start_text.show()
	curtain_l.scale = Vector2(1,1)
	curtain_r.scale = Vector2(1,1)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("enter"):
		start_text.hide()
		print("aaaaaa")
		create_tween().tween_property(curtain_l,"scale",Vector2(0.15,1),curtain_time).set_ease(Tween.EASE_OUT)
		create_tween().tween_property(curtain_r,"scale",Vector2(0.15,1),curtain_time).set_ease(Tween.EASE_OUT)
		await get_tree().create_timer(curtain_time).timeout
		SceneManager.change_scene("res://TitleMenu/select.tscn",{"color":Color("#ffffff"),"speed":2.5})
