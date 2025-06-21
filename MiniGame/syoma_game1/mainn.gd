extends Node2D

@onready var timer =$time
@onready var _label = $gameclear
@onready var _lavel2 = $gameover
@onready var target = $target
var gameover:bool = false
var gameclear:bool = false
var game_cleared:bool = false 
func _ready() -> void:		
	timer.time_start()
func _process(delta: float) -> void:
	var cnt = 0
	for child in get_children():
		if "Tamakun" in child.name:
			cnt += 1
	if gameover==false and gameclear==false and cnt == 0:
		gameclear = true
		_label.visible = true
		timer.time_stop()
		for enemy in get_tree().get_nodes_in_group("tamas"):
			enemy.queue_free()
		await get_tree().create_timer(5.0).timeout
		SceneManager.change_scene("res://TitleMenu/title.tscn",{"color":Color("#ffffff"),"speed":2.5})

func _on_time_time_out() -> void:
	if gameclear == false:
		_lavel2.visible = true
		gameover = true
		for enemy in get_tree().get_nodes_in_group("tamas"):
				enemy.queue_free()
		get_tree().call_group("tamas","hide")
		get_tree().call_group("ozyamato-kunns","queue_free")
		timer.time_stop()
		await get_tree().create_timer(5.0).timeout
		SceneManager.change_scene("res://TitleMenu/title.tscn",{"color":Color("#ffffff"),"speed":2.5})
