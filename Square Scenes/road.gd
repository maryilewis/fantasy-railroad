extends Node3D

var path_progress = 0
var speed = .01

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Path3D/PathFollowEW.progress += speed

func _add_child_ew(node):
	$Path3D/PathFollowEW.add_child(node)
	$Path3D/PathFollowEW.progress = 0

