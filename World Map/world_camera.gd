class_name MaryWorldCamera extends Camera3D

var _following = false
var _follow_ref: Node3D

var _click_moving = false
var _mouse_position = Vector2(0.0, 0.0)
var _click_mouse_position = Vector2(0.0, 0.0)
var _click_start_position = Vector3(0.0, 0.0, 0.0)

# Movement state
var _direction = Vector3(0.0, 0.0, 0.0)

# Keyboard state
var _w = false
var _s = false
var _a = false
var _d = false
var _zoom = 0

func _input(event):
	if event is InputEventMouseMotion:
		_mouse_position = event.position

	# Receives mouse button input
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP:
				_zoom = -1
			MOUSE_BUTTON_WHEEL_DOWN:
				_zoom = 1
			MOUSE_BUTTON_MIDDLE:
				if event.pressed:
					_following = false
					_click_moving = true
					_click_mouse_position = _mouse_position
					_click_start_position = global_position
				else:
					_click_moving = false

	# Receives key input
	if event is InputEventKey:
		_following = false
		match event.keycode:
			KEY_W:
				_w = 1 if event.pressed else 0
			KEY_S:
				_s = 1 if event.pressed else 0
			KEY_A:
				_a = 1 if event.pressed else 0
			KEY_D:
				_d = 1 if event.pressed else 0
			_:
				_w = 0
				_a = 0
				_s = 0
				_d = 0
	else:
		_w = 0
		_a = 0
		_s = 0
		_d = 0

# Updates mouselook and movement every frame
func _process(_delta):
	if (_click_moving):
		_follow_mouse()
	elif (!_following):
		_update_movement()
	else:
		_update_follow_movement()
	_update_zoom()

# .1155 -> 5850
# 7   	->	96	.0104	.148
# 9.92	->	68	.0147	.147
# 15  	->	44	.0227	.153
# 20.75	->	30	.0333	.160


func _follow_mouse():
	var mouse_change = (_mouse_position - _click_mouse_position) * size * .00148 #don't ask where the number came from
	#if (not mouse_change.is_zero_approx()):
	#	print("not 0!")
	translate(Vector3(-mouse_change.x, mouse_change.y, 0))
	_click_mouse_position = _mouse_position

func _update_zoom():
	if (_zoom != 0):
		print("size", size)
		size += _zoom * size / 25
		_zoom = 0

# Updates camera movement
func _update_movement():
	# Computes desired direction from key states
	_direction = Vector3((_d as float) - (_a as float), 
						(_w as float) - (_s as float), 0)
	
	# Checks if we should bother translating the camera
	if _direction != Vector3.ZERO:
		var speed = size/20.0
		var _move = _direction * speed
		translate(_move)

func set_follow_ref(ref):
	if (size > 20):
		size = 20
	_follow_ref = ref
	_following = true

func _update_follow_movement():
	global_position.x = _follow_ref.global_position.x +  50
	global_position.y = _follow_ref.global_position.y + 41 # sqrt(2) * 50 / sqrt(3), trust me
	global_position.z = _follow_ref.global_position.z + 50
