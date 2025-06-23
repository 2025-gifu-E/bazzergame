extends Node3D
@onready var power_bar: ProgressBar = $power_bar
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var rotation_pivot: Node3D = $rotation_pivot
@onready var rotation_pivot2: Node3D = $rotation_pivot2
@onready var arrow: MeshInstance3D = $rotation_pivot/arrow
@onready var arrow2: MeshInstance3D = $rotation_pivot2/arrow2
@onready var ball: RigidBody3D = $ball

@onready var camera: Camera3D = $Camera
@onready var power_cam: PhantomCamera3D = $power_cam
@onready var rotate_1_cam: PhantomCamera3D = $rotate1_cam
@onready var rotate_2_cam: PhantomCamera3D = $rotate2_cam
@onready var result_cam: PhantomCamera3D = $result_cam


@onready var goal: Area3D = $goal
@onready var goal_2: Area3D = $goal2
@onready var goal_3: Area3D = $goal3

@onready var clear: RichTextLabel = $ui/clear
@onready var gameover: RichTextLabel = $ui/gameover
@onready var color_rect: ColorRect = $ui/ColorRect
@onready var count: Label = $ui/count

enum state{
	power,
	rotate,
	rotate2,
	shoot,
	finish
}

var states:int

var power:float
var rotate:Vector3

var enter:bool = true
var impulse:bool

var ok:bool


func _ready() -> void:
	impulse = false
	ok = false
	count.show()
	clear.hide()
	gameover.hide()
	color_rect.hide()
	color_rect.color = Color("#00000000")
	power_bar.show()
	rotation_pivot.hide()
	rotation_pivot2.hide()
	states = state.power
	animation_player.play("power_bar_value")

	var host:Node = PhantomCameraHost.new()
	#camera.add_child(host)
	power_cam.priority = 1
	rotate_1_cam.priority = 0
	rotate_2_cam.priority = 0
	result_cam.priority = 0

	goal_set()
	
	await SceneManager.transition_finished
	count.text = "3"
	await get_tree().create_timer(1.0).timeout
	count.text = "2"
	await get_tree().create_timer(1.0).timeout
	count.text = "1"
	await get_tree().create_timer(1.0).timeout
	count.text = "START"
	await get_tree().create_timer(1.0).timeout
	ok = true
	count.hide()

func goal_set() -> void:
	# 各ゴールのランダムな移動範囲を定義
	var x_min: float = -7.5
	var x_max: float = 7.5
	var z_min: float = -7.5 # Z軸の最大値を調整し、より前方に配置できるようにしました。
	var z_max: float = -2.0 # Z軸の最小値を調整し、同じ理由で。
	var y_min: float = -1.5
	var y_max: float = 2.5
	var fixed_y: float = 0.5 # ゴールのY座標（高さ）を固定する場合

	var goal_radius: float = 1.0 # ゴールの半径（1メートル）
	var min_distance: float = goal_radius * 2.0 # ゴール間の最小距離（直径分）

	var positions: PackedVector3Array = [] # 配置済みのゴールの位置を格納する配列

	# ゴール1の位置を設定
	var random_pos_goal1: Vector3
	while true: # 有効な位置が見つかるまでループ
		random_pos_goal1 = Vector3(
			randf_range(x_min, x_max),
			randf_range(y_min, y_max),
			randf_range(z_min, z_max)
		)
		# 円柱状のゴールの場合、主にXZ平面での重なりが問題になるため、Y座標を固定します。
		# ゴールがY軸で大幅に異なる高さになり、それでもXYZ全体での重なりを避けたい場合は、
		# 以下の距離チェックがそのまま適用されます。
		random_pos_goal1.y = fixed_y # 必要に応じてY座標を固定

		var valid_position = true
		for existing_pos in positions: # 既に配置されたゴールとの距離をチェック
			if random_pos_goal1.distance_to(existing_pos) < min_distance:
				valid_position = false # 重なっている場合は無効
				break
		if valid_position:
			goal.position = random_pos_goal1
			positions.append(random_pos_goal1) # 有効な位置であれば追加
			break # ループを抜ける

	# ゴール2の位置を設定
	var random_pos_goal2: Vector3
	while true:
		random_pos_goal2 = Vector3(
			randf_range(x_min, x_max),
			randf_range(y_min, y_max),
			randf_range(z_min, z_max)
		)
		random_pos_goal2.y = fixed_y

		var valid_position = true
		for existing_pos in positions:
			if random_pos_goal2.distance_to(existing_pos) < min_distance:
				valid_position = false
				break
		if valid_position:
			goal_2.position = random_pos_goal2
			positions.append(random_pos_goal2)
			break

	# ゴール3の位置を設定
	var random_pos_goal3: Vector3
	while true:
		random_pos_goal3 = Vector3(
			randf_range(x_min, x_max),
			randf_range(y_min, y_max),
			randf_range(z_min, z_max)
		)
		random_pos_goal3.y = fixed_y

		var valid_position = true
		for existing_pos in positions:
			if random_pos_goal3.distance_to(existing_pos) < min_distance:
				valid_position = false
				break
		if valid_position:
			goal_3.position = random_pos_goal3
			positions.append(random_pos_goal3)
			break

func _process(delta: float) -> void:
	if !ok:
		return
	#if Input.is_action_just_pressed("ui_cancel"):
		#_on_goal_body_entered(ball)
	match states:
		state.power:
			if !enter:
				return
			enter = true
			if Input.is_action_just_pressed("enter"):
				animation_player.pause()
				power = power_bar.value
				enter = false
				power_cam.priority = 0
				rotate_1_cam.priority = 1
				rotate_2_cam.priority = 0
				result_cam.priority = 0
				await get_tree().create_timer(0.3).timeout
				enter = true
				states = state.rotate
				rotation_pivot.rotation_degrees.x = 75
				animation_player.play("rotation")
				rotation_pivot.show()
		state.rotate:
			if !enter:
				return
			enter = true
			if Input.is_action_just_pressed("enter"):
				animation_player.pause()
				rotate.x = rotation_pivot.rotation.x
				enter = false
				power_cam.priority = 0
				rotate_1_cam.priority = 0
				rotate_2_cam.priority = 1
				result_cam.priority = 0
				await get_tree().create_timer(0.3).timeout
				enter = true
				states = state.rotate2
				rotation_pivot2.rotation_degrees.y = 50
				animation_player.play("rotation2")
				rotation_pivot2.show()
		state.rotate2:
			if !enter:
				return
			enter = true
			if Input.is_action_just_pressed("enter"):
				animation_player.pause()
				rotate.y = rotation_pivot2.rotation.y
				power_cam.priority = 0
				rotate_1_cam.priority = 0
				rotate_2_cam.priority = 0
				result_cam.priority = 1
				states = state.shoot
		state.shoot:
				states = state.finish
				await get_tree().create_timer(0.4).timeout
				power_bar.hide()
				rotation_pivot2.hide()
				rotation_pivot.hide()
				power_bar.hide()

				var rotation_quat: Quaternion = Quaternion(Vector3.UP, rotate.y) * Quaternion(Vector3.RIGHT, rotate.x)
				
				# 初期方向は Z軸の負の方向 (前方) と仮定（Godotの3Dでは通常 -Z が前）
				var initial_direction: Vector3 = Vector3.FORWARD # Z軸正方向を基準とする
				# Quaternion を使って方向ベクトルを回転させる
				var shoot_direction: Vector3 = rotation_quat * initial_direction

				var shoot_force: float = power * 0.1 # power の値を適切な係数で調整
				ball.set_sleeping(false)

				# 中心にインパルスを適用してボールを飛ばす
				if !impulse:
					ball.apply_central_impulse(shoot_direction.normalized() * shoot_force)
					impulse = true


func _on_goal_body_entered(body: Node3D) -> void:
	color_rect.show()
	create_tween().tween_property(color_rect,"color",Color("#0000006d"),1.0)
	await get_tree().create_timer(1.0).timeout
	clear.show()
	await get_tree().create_timer(3.0).timeout
	SceneManager.change_scene("res://TitleMenu/title.tscn")

func _on_gameover_body_entered(body: Node3D) -> void:
	color_rect.show()
	create_tween().tween_property(color_rect,"color",Color("#0000006d"),1.0)
	await get_tree().create_timer(1.0).timeout
	gameover.show()
	var tween = create_tween()
	tween.tween_property(gameover, "position:y", 251, 1.0).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	tween.tween_interval(0.1)
	tween.tween_property(gameover, "rotation", 0.1, 0.1).set_ease(Tween.EASE_OUT)
	await get_tree().create_timer(3.0).timeout
	SceneManager.change_scene("res://TitleMenu/title.tscn")
