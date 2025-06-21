extends Node2D

#idousokudo
const MOVE_SPEED = 1000

#gamennsize
var _screen = Rect2()

#idouryou
var _velocity = Vector2()

func _ready() -> void:
	#gamennzizesyutiku
	_screen = get_viewport_rect()
	
	#idouhoukouurandamu
	_velocity.x = randf_range(-1,1)
	_velocity.y = randf_range(-1,1)
#kousinnsyori
func _process(delta: float) -> void:
	#idoushori
	position += _velocity * MOVE_SPEED * delta
	
	#hanekaeru
	if position.x < 0:
		position.x = 0
		_velocity.x *= -1
	if position.y < 0:
		position.y = 0
		_velocity.y *= -1
	if position.x > _screen.size.x:
		position.x = _screen.size.x
		_velocity.x *= -1
	if position.y > _screen.size.y:
		position.y = _screen.size.y
		_velocity.y *= -1
	
	
	
