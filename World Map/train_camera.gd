class_name TrainCamera extends Camera3D

var _following = false
var _follow_ref: Node3D

func _ready():
	GameData.train_camera = self

# Updates mouselook and movement every frame
func _process(_delta):
	if (_following):
		_update_follow_movement()

func set_follow_ref(ref):
	_follow_ref = ref
	_following = true
	
func get_follow_ref():
	return _follow_ref

func clear_follow_ref():
	_follow_ref = null
	_following = false

func _update_follow_movement():
	global_position.x = _follow_ref.global_position.x + 5 #TODO better number
	global_position.z = _follow_ref.global_position.z + 5
