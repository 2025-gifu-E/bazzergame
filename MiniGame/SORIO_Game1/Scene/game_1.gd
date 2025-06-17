extends Node2D
@onready var ufo: CharacterBody2D = $UFO
@onready var left_arm: CharacterBody2D = $UFO/CollisionShape2D/left_arm
@onready var right_arm: CharacterBody2D = $UFO/CollisionShape2D/right_arm
@onready var rigid_body_2d: RigidBody2D = $RigidBody2D




const arm_max_angle:float = -45
const arm_min_angle:float = -30
var Crane_Pos:Vector2
var Mover:float = 20

enum Crane {
	Move,Down,Close,Up,Go,Open,End
}

var GameFlow:Crane = Crane.Move

func _ready() -> void:
	left_arm.rotation_degrees = arm_min_angle
	right_arm.rotation_degrees = arm_min_angle * -1
	ufo.position = Vector2(0,-250)

func _physics_process(delta: float) -> void:
	match GameFlow:
		Crane.Move:
			if(Crane_Pos.x <= -400):
				Mover = 20
			if(Crane_Pos.x >= 400):
				Mover = -20
			Crane_Pos.x += Mover
			if(Input.is_action_just_pressed("enter")):
				GameFlow = Crane.Down
		
		Crane.Down:
			Crane_Pos.y += 5
			if(Crane_Pos.y >= 400):
				GameFlow = Crane.Close
		
		Crane.Close:
			create_tween().tween_property(left_arm,"rotation_degrees",arm_max_angle,0.4)
			create_tween().tween_property(right_arm,"rotation_degrees",arm_max_angle * -1,0.4)
			await get_tree().create_timer(1).timeout
			GameFlow = Crane.Up
		
		Crane.Up:
			Crane_Pos.y -= 5
			if(Crane_Pos.y <= 0):
				GameFlow = Crane.Go
		
		Crane.Go:
			Crane_Pos.x += 5
			if(Crane_Pos.x >= 400):
				GameFlow = Crane.Open
		
		Crane.Open:
			create_tween().tween_property(left_arm,"rotation_degrees",arm_min_angle,0.4)
			create_tween().tween_property(right_arm,"rotation_degrees",arm_min_angle * -1,0.4)
			await get_tree().create_timer(1).timeout
			GameFlow = Crane.Move
		
	ufo.position = Crane_Pos
