extends Node3D
@onready var power_bar: ProgressBar = $power_bar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rotation_pivot: Node3D = $rotation_pivot
@onready var rotation_pivot2: Node3D = $rotation_pivot2
@onready var arrow: MeshInstance3D = $rotation_pivot/arrow
@onready var arrow2: MeshInstance3D = $rotation_pivot2/arrow2
@onready var ball: RigidBody3D = $ball

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
				
				# --- ここからボールを飛ばす処理 ---
				# 回転を Quaternion (クォータニオン) に変換して方向ベクトルを生成
				# Godotの rotation_degrees はオイラー角ですが、内部的にはラジアンで扱われるため、
				# rotation_pivot.rotation.x や rotation_pivot2.rotation.y はラジアン値です。
				# また、回転の適用順序が重要です。通常、Y軸→X軸→Z軸の順で適用されます。
				# ここでは Y軸回転 (rotate.y) を先に適用し、次に X軸回転 (rotate.x) を適用します。
				var rotation_quat: Quaternion = Quaternion(Vector3.UP, rotate.y) * Quaternion(Vector3.RIGHT, rotate.x)
				
				# 初期方向は Z軸の負の方向 (前方) と仮定（Godotの3Dでは通常 -Z が前）
				var initial_direction: Vector3 = Vector3.FORWARD # Z軸正方向を基準とする
				# Quaternion を使って方向ベクトルを回転させる
				var shoot_direction: Vector3 = rotation_quat * initial_direction
				
				# 力を適用
				# power の値に、適切な乗数を掛けて調整する必要があるかもしれません
				# 例: power_multiplier = 100 
				var shoot_force: float = power * 0.1 # power の値を適切な係数で調整
				
				# ball の RigidBody3D モードをアクティブにする
				ball.set_sleeping(false) # もしスリープ状態なら起こす

				# 中心にインパルスを適用してボールを飛ばす
				ball.apply_central_impulse(shoot_direction.normalized() * shoot_force)
				
