extends Node3D
@onready var tama: RigidBody3D = $tama
@onready var mato_1: RigidBody3D = $mato1
@onready var kamera: Node3D = $"kamera-"
@onready var camerahontai: Camera3D = $"kamera-/Camera3D"
@onready var yuka_1: StaticBody3D = $yuka_1
@onready var tama_tex: Node3D = $tama/tama
@onready var tama_basyo: Node3D = $"kamera-/Camera3D/tama_basyo"
@onready var camera_basyo: Node3D = $"kamera-/Camera3D/camera_basyo"
#@onready var suko_cam: Camera3D = $"SubViewport/suko-cam"
@onready var scope: Control = $"scope-image"
@onready var wind_arrow: Control = %"windarrow-imagefile"
@onready var label: Label = $Label

var camera_sayu_sokudo:float = 90.0
var camera_joge_sokudo:float = 90.0
var camera_ue_gen:float = -90.0
var camera_sita_gen:float = 90.0
var camera_joge_kakunin:float
var one_push:bool = bool(0)
var power:float = 100
var x_wind:float = 0
var z_wind:float = 0
var false_trap_dragoongod_professional_ultimate_super_star_string_integer_bool_amaging_strong_promax_iphone17_mac_windows_android_redstar_quatro_double_firster_fast_white_red_blue_green_electronic_tecnorogy_float_single_triple_list:bool = false

func _ready() -> void:
	wind_arrow.set_pivot_offset(wind_arrow.size / 2)
	wind_arrow.global_position = Vector2(30,30)
	tama.freeze = 1
	tama_tex.hide()
	scope.hide()
	var mato_zahyou_x = randi_range(100,120)
	var mato_zahyou_y = randi_range(-10,40)
	var mato_zahyou_z = randi_range(-30,30)
	x_wind = randi_range(-10,10)
	z_wind = randi_range(-10,10)
	wind_arrow.rotation = atan2(z_wind,x_wind)+(PI / 2)
	print(str(x_wind)+str(z_wind))
	yuka_1.position = Vector3(mato_zahyou_x,mato_zahyou_y,mato_zahyou_z)
	mato_1.position = Vector3(mato_zahyou_x,mato_zahyou_y + 1.25,mato_zahyou_z)
	var zettai_husoku:float = int(sqrt(x_wind**2 + z_wind**2)*10)
	label.text = "x:" + str(x_wind) + "m,z:" + str(z_wind) + "m,STR:" + str(zettai_husoku*0.1) + "m"

func _physics_process(delta: float) -> void:
	if(false_trap_dragoongod_professional_ultimate_super_star_string_integer_bool_amaging_strong_promax_iphone17_mac_windows_android_redstar_quatro_double_firster_fast_white_red_blue_green_electronic_tecnorogy_float_single_triple_list==false):
		return
	if one_push == bool(0):
		tama.global_position = tama_basyo.global_position
	if Input.is_action_pressed("ZL"):
		camerahontai.fov = 10.0
		scope.show()
	else:
		camerahontai.fov = 70.0
		scope.hide()
		
	if Input.is_action_just_pressed("ui_accept") and one_push == bool(0):
		tama.rotation.z = camerahontai.rotation.x
		tama.rotation.y = kamera.rotation.y - deg_to_rad(-90)
		tama.freeze = 0
		tama_tex.show()
		var camera_direction = -camerahontai.global_transform.basis.z.normalized()
		tama.apply_central_impulse(camera_direction * power)
		tama.apply_central_impulse(Vector3(x_wind,0,z_wind))
		one_push = 1
	
	if mato_1.position.y < -30:
		get_tree().quit()#clear
	camera(delta)
	#suko_cam.global_position = camera_basyo.global_position
	#suko_cam.rotation.x = camerahontai.rotation.x
	#suko_cam.rotation.y = kamera.rotation.y
	
	
	wind_arrow.rotation = atan2(z_wind,x_wind)+(PI / 2)+kamera.rotation.y
	
		
func camera(delta: float) -> void:
	var camera_sayu_hozon:float = 0.0
	if Input.is_action_pressed("L_left"):
		if Input.is_action_pressed("Y"):
			camera_sayu_hozon += 0.1
		else:
			camera_sayu_hozon += 1.0
	if Input.is_action_pressed("L_right"):
		if Input.is_action_pressed("Y"):
			camera_sayu_hozon -= 0.1
		else:
			camera_sayu_hozon -= 1.0
	kamera.rotate_y(deg_to_rad(camera_sayu_hozon*camera_sayu_sokudo*delta))
	var camera_joge_hozon:float = 0.0
	if Input.is_action_pressed("L_up"):
		if Input.is_action_pressed("Y"):
			camera_joge_hozon += 0.1
		else:
			camera_joge_hozon += 1.0
	if Input.is_action_pressed("L_down"):
		if Input.is_action_pressed("Y"):
			camera_joge_hozon -= 0.1
		else:
			camera_joge_hozon -= 1.0
	camera_joge_kakunin += camera_joge_hozon * camera_joge_sokudo * delta
	camera_joge_kakunin = clamp(camera_joge_kakunin,camera_ue_gen,camera_sita_gen)
	camerahontai.transform.basis = Basis()
	camerahontai.rotate_object_local(Vector3.RIGHT,deg_to_rad(camera_joge_kakunin))
