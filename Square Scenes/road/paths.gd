class_name PathNode extends Node3D
## Paths for vehicles to remotely follow

var path_progress = 0
var speed = .01
var path_refs = {}

func _ready():
	_init_path_refs()

func _init_path_refs():
	path_refs = {
		"ew": {
			"follow": $PathEW/PathFollow3D,
			"transform": $PathEW/PathFollow3D/RemoteTransform3D
		},
		"we": {
			"follow": $PathWE/PathFollow3D,
			"transform": $PathWE/PathFollow3D/RemoteTransform3D
		},
		"sn": {
			"follow": $PathSN/PathFollow3D,
			"transform": $PathSN/PathFollow3D/RemoteTransform3D
		},
		"ns": {
			"follow": $PathNS/PathFollow3D,
			"transform": $PathNS/PathFollow3D/RemoteTransform3D
		},
		"es": {
			"follow": $PathES/PathFollow3D,
			"transform": $PathES/PathFollow3D/RemoteTransform3D
		},
		"en": {
			"follow": $PathEN/PathFollow3D,
			"transform": $PathEN/PathFollow3D/RemoteTransform3D
		},
		"ws": {
			"follow": $PathWS/PathFollow3D,
			"transform": $PathWS/PathFollow3D/RemoteTransform3D
		},
		"wn": {
			"follow": $PathWN/PathFollow3D,
			"transform": $PathWN/PathFollow3D/RemoteTransform3D
		},
		"se": {
			"follow": $PathSE/PathFollow3D,
			"transform": $PathSE/PathFollow3D/RemoteTransform3D
		},
		"ne": {
			"follow": $PathNE/PathFollow3D,
			"transform": $PathNE/PathFollow3D/RemoteTransform3D
		},
		"sw": {
			"follow": $PathSW/PathFollow3D,
			"transform": $PathSW/PathFollow3D/RemoteTransform3D
		},
		"nw": {
			"follow": $PathNW/PathFollow3D,
			"transform": $PathNW/PathFollow3D/RemoteTransform3D
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

func add_path_child(key, node):
	path_refs[key]["transform"].remote_path = node.get_path()
	path_refs[key]["follow"].progress = 0
	return path_refs[key]["follow"]

