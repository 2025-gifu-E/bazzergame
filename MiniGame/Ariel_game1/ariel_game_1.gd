extends Node3D
@onready var power_bar: ProgressBar = $power_bar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rotation_pivot: Node3D = $rotation_pivot
@onready var rotation_pivot2: Node3D = $rotation_pivot2

enum state{
	power,
	rotate,
	rotate2,
	shoot
}

var states:int

var power:float
var rotate:Vector3

func _ready() -> void:
	power_bar.show()
	rotation_pivot.hide()
	rotation_pivot2.hide()
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
				rotation_pivot.rotation_degrees.x = 50
				animation_player.play("rotation")
				rotation_pivot.show()
				print(power)
		state.rotate:
			if Input.is_action_just_pressed("enter"):
				animation_player.pause()
				rotate.x = rotation_pivot.rotation.x
				await get_tree().create_timer(0.5).timeout
				states = state.rotate2
				rotation_pivot2.rotation_degrees.y = 50
				animation_player.play("rotation2")
				rotation_pivot2.show()
				print(rotate)
		state.rotate2:
			if Input.is_action_just_pressed("enter"):
				animation_player.pause()
				rotate.y = rotation_pivot.rotation.y
				await get_tree().create_timer(0.5).timeout
				states = state.shoot
				rotation_pivot2.hide()
				rotation_pivot.hide()
				power_bar.hide()
				print(rotate)
