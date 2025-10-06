extends Node2D
@onready var ufo: CharacterBody2D = $UFO
@onready var left_arm: CharacterBody2D = $UFO/CollisionShape2D/left_arm
@onready var right_arm: CharacterBody2D = $UFO/CollisionShape2D/right_arm
@onready var rigid_body_2d: RigidBody2D = $RigidBody2D
@onready var start_countdown: Control = $CanvasLayer/start_countdown
@onready var gameoveroverlay: Control = $CanvasLayer/gameoveroverlay
@onready var clearoverlay: Control = $CanvasLayer/clearoverlay




const arm_max_angle:float = -40
const arm_min_angle:float = -10
const Hit:int = 25
var Crane_Pos:Vector2
var Mover:float = 20
var Random:int
var can_play:bool = false
var gameover:bool = false
var gameclear:bool = false
enum Crane {
	Move,Down,Close,Up,Go,Open,End
}

var GameFlow:Crane = Crane.Move

func _ready() -> void:
	left_arm.rotation_degrees = arm_min_angle
	right_arm.rotation_degrees = arm_min_angle * -1
	ufo.position = Vector2(0,-250)
	start_countdown.start_countdown()

func _physics_process(delta: float) -> void:
	match GameFlow:
		Crane.Move:
			if(Crane_Pos.x <= -400):
				Mover = 20
			if(Crane_Pos.x >= 400):
				Mover = -20
			Crane_Pos.x += Mover
			if(Input.is_action_just_pressed("enter") and can_play):
				GameFlow = Crane.Down
		
		Crane.Down:
			if(Crane_Pos.y >= 420):
				await get_tree().create_timer(0.5).timeout
				GameFlow = Crane.Close
			else:
				Crane_Pos.y += 5
		
		Crane.Close:
			create_tween().tween_property(left_arm,"rotation_degrees",arm_max_angle,0.2)
			create_tween().tween_property(right_arm,"rotation_degrees",arm_max_angle * -1,0.2)
			await get_tree().create_timer(1).timeout
			GameFlow = Crane.Up
		
		Crane.Up:
			if(Crane_Pos.y <= 0):
				Random = randi_range(1,100)
				GameFlow = Crane.Go
			else:
				Crane_Pos.y -= 5
		
		Crane.Go:
			if(Random>Hit):
				left_arm.rotation_degrees = (arm_max_angle +1)
				right_arm.rotation_degrees = (arm_max_angle +1) * -1
			if(Crane_Pos.x >= 400):
				await get_tree().create_timer(0.5).timeout
				GameFlow = Crane.Open
			else:
				Crane_Pos.x += 5
		
		Crane.Open:
			create_tween().tween_property(left_arm,"rotation_degrees",arm_min_angle,0.4)
			create_tween().tween_property(right_arm,"rotation_degrees",arm_min_angle * -1,0.4)
			await get_tree().create_timer(1).timeout
			GameFlow = Crane.End
		Crane.End:
			await get_tree().create_timer(1.5).timeout
			if gameclear: return
			if not gameover:_game_over()
			gameover = true
		
			
		
	ufo.position = Crane_Pos


func _on_start_countdown_game_start() -> void:
	can_play = true

func _game_over() -> void:
	gameoveroverlay.gameover_view()
	await get_tree().create_timer(5.0).timeout
	SceneManager.change_scene("res://TitleMenu/title.tscn",{"skip_fade_out":true,"skip_fade_in":true})


func _on_goal_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		gameclear = true
		await get_tree().create_timer(0.5).timeout
		clearoverlay.clear_view()
