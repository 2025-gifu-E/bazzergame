extends Node3D
@onready var power_bar: ProgressBar = $power_bar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rotation_pivot: Node3D = $rotation_pivot
@onready var rotation_pivot2: Node3D = $rotation_pivot2
@onready var arrow: MeshInstance3D = $rotation_pivot/arrow
@onready var arrow2: MeshInstance3D = $rotation_pivot2/arrow2
@onready var ball: RigidBody3D = $ball

@onready var camera: Camera3D = $Camera
@onready var phantom_1: PhantomCamera3D = $phantom1
@onready var phantom_2: PhantomCamera3D = $phantom2

@onready var arrow_3: MeshInstance3D = $StaticBody3D/arrow3

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

	var host:Node = PhantomCameraHost.new()
	await get_tree().process_frame
	camera.add_child(host)
	phantom_1.priority = 1
	phantom_2.priority = 0

func _process(delta: float) -> void:
	match states:
		state.power:
			if Input.is_action_just_pressed("enter"):
				animation_player.pause()
				power = power_bar.value
				await get_tree().create_timer(0.3).timeout
				states = state.rotate
				rotation_pivot.rotation_degrees.x = 50
				animation_player.play("rotation")
				rotation_pivot.show()
				print(power)
		state.rotate:
			if Input.is_action_just_pressed("enter"):
				animation_player.pause()
				rotate.x = rotation_pivot.rotation.x
				await get_tree().create_timer(0.3).timeout
				states = state.rotate2
				rotation_pivot2.rotation_degrees.y = 50
				animation_player.play("rotation2")
				rotation_pivot2.show()
		state.rotate2:
			if Input.is_action_just_pressed("enter"):
				animation_player.pause()
				rotate.y = rotation_pivot2.rotation.y
				phantom_1.priority = 0
				phantom_2.priority = 1
				await get_tree().create_timer(0.4).timeout
				states = state.shoot
				rotation_pivot2.hide()
				rotation_pivot.hide()
				power_bar.hide()

				var rotation_quat: Quaternion = Quaternion(Vector3.UP, rotate.y) * Quaternion(Vector3.RIGHT, rotate.x)
				
				# 初期方向は Z軸の負の方向 (前方) と仮定（Godotの3Dでは通常 -Z が前）
				var initial_direction: Vector3 = Vector3.FORWARD # Z軸正方向を基準とする
				# Quaternion を使って方向ベクトルを回転させる
				var shoot_direction: Vector3 = rotation_quat * initial_direction
				print(shoot_direction.normalized())

				var shoot_force: float = power * 0.1 # power の値を適切な係数で調整
				ball.set_sleeping(false)

				# 中心にインパルスを適用してボールを飛ばす
				ball.apply_central_impulse(shoot_direction.normalized() * shoot_force)

				
