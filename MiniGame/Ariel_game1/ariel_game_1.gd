extends Node3D
@onready var power_bar: ProgressBar = $power_bar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rotation_pivot: Node3D = $rotation_pivot

enum state{
	power,
	rotate,
	shoot
}

var states:int

var power:float
var rotate:float

func _ready() -> void:
	power_bar.show()
	rotation_pivot.hide()
	states = state.power
	animation_player.play("power_bar_value")

func _process(delta: float) -> void:
	match states:
		state.power:
			if Input.is_action_just_pressed("enter"):
				animation_player.pause()
				power = power_bar.value
				await get_tree().create_timer(0.5).timeout
				states = state.rotate
				rotation_pivot.rotation_degrees.y = 50
				animation_player.play("rotation")
				rotation_pivot.show()
				print(power)
		state.rotate:
			if Input.is_action_just_pressed("enter"):
				animation_player.pause()
				rotate = rotation_pivot.rotation.y
				await get_tree().create_timer(0.5).timeout
				states = state.shoot
				print(rotate)
