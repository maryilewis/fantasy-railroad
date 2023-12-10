class_name TraversibleNode
extends SquareBaseNode

var path_progress = 0
var speed = .01

var path_refs = {}

# TODO set up variables to avoid lots of $ and typing
# TODO set loop to false?

func is_traversible():
	return true

func _init():
	isTraversible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	_init_path_refs()
	_init_visible_road()

func _init_visible_road():
	$"Visible Roads".map_x = map_x
	$"Visible Roads".map_y = map_y
	
func evaluate_visible_roads():
	$"Visible Roads".evaluate_visible_roads()

func _init_path_refs():
	path_refs = {
		"ew": {
			"follow": $Paths/PathEW/PathFollow3D,
			"transform": $Paths/PathEW/PathFollow3D/RemoteTransform3D
		},
		"we": {
			"follow": $Paths/PathWE/PathFollow3D,
			"transform": $Paths/PathWE/PathFollow3D/RemoteTransform3D
		},
		"sn": {
			"follow": $Paths/PathSN/PathFollow3D,
			"transform": $Paths/PathSN/PathFollow3D/RemoteTransform3D
		},
		"ns": {
			"follow": $Paths/PathNS/PathFollow3D,
			"transform": $Paths/PathNS/PathFollow3D/RemoteTransform3D
		},
		"es": {
			"follow": $Paths/PathES/PathFollow3D,
			"transform": $Paths/PathES/PathFollow3D/RemoteTransform3D
		},
		"en": {
			"follow": $Paths/PathEN/PathFollow3D,
			"transform": $Paths/PathEN/PathFollow3D/RemoteTransform3D
		},
		"ws": {
			"follow": $Paths/PathWS/PathFollow3D,
			"transform": $Paths/PathWS/PathFollow3D/RemoteTransform3D
		},
		"wn": {
			"follow": $Paths/PathWN/PathFollow3D,
			"transform": $Paths/PathWN/PathFollow3D/RemoteTransform3D
		},
		"se": {
			"follow": $Paths/PathSE/PathFollow3D,
			"transform": $Paths/PathSE/PathFollow3D/RemoteTransform3D
		},
		"ne": {
			"follow": $Paths/PathNE/PathFollow3D,
			"transform": $Paths/PathNE/PathFollow3D/RemoteTransform3D
		},
		"sw": {
			"follow": $Paths/PathSW/PathFollow3D,
			"transform": $Paths/PathSW/PathFollow3D/RemoteTransform3D
		},
		"nw": {
			"follow": $Paths/PathNW/PathFollow3D,
			"transform": $Paths/PathNW/PathFollow3D/RemoteTransform3D
		},
	}
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	for key in path_refs:
		var current = path_refs[key]
		if (current["transform"].remote_path):
			current["follow"].progress += speed

func remove_path_child(key):
	path_refs[key]["transform"].remote_path = ""
	path_refs[key]["follow"].progress = 0

func add_path_child(key, node):
	path_refs[key]["transform"].remote_path = node.get_path()
	return path_refs[key]["follow"]

