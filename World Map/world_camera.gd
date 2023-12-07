class_name MaryWorldCamera extends Camera3D

var _following = false

# Movement state
var _direction = Vector3(0.0, 0.0, 0.0)

# Keyboard state
var _w = false
var _s = false
var _a = false
var _d = false
var _zoom = 0

func _input(event):
	# Receives mouse button input
	if event is InputEventMouseButton:
		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP:
				_zoom = -.5
			MOUSE_BUTTON_WHEEL_DOWN:
				_zoom = .5

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
	if (!_following):
		_update_movement()
		_update_zoom()

func _update_zoom():
	size += _zoom
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
