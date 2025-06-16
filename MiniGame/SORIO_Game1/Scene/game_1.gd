extends Node2D
@onready var ufo: CharacterBody2D = $UFO
@onready var left_arm: CharacterBody2D = $UFO/CollisionShape2D/left_arm
@onready var right_arm: CharacterBody2D = $UFO/CollisionShape2D/right_arm

var arm_max_angle:float = -56
var arm_min_angle:float = -30

func _ready() -> void:
	left_arm.rotation_degrees = arm_min_angle

func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("enter")):
		print("aaaa")
		create_tween().tween_property(left_arm,"rotation_degrees",arm_max_angle,1)
		create_tween().tween_property(right_arm,"rotation_degrees",arm_max_angle * -1,1)
