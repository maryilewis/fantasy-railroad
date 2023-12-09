class_name RoadNode
extends Node3D

var path_progress = 0
var speed = .01

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if ($PathEW/PathFollowEW/RemoteTransform3D.remote_path):
		$PathEW/PathFollowEW.progress += speed
	if ($PathWE/PathFollowWE/RemoteTransform3D.remote_path):
		$PathWE/PathFollowWE.progress += speed

func remove_path_child():
	$PathEW/PathFollowEW/RemoteTransform3D.remote_path = ""
	$PathEW/PathFollowEW.progress = 0
	$PathWE/PathFollowWE/RemoteTransform3D.remote_path = ""
	$PathWE/PathFollowWE.progress = 0

func remove_path_child_ew():
	$PathEW/PathFollowEW/RemoteTransform3D.remote_path = ""
	$PathEW/PathFollowEW.progress = 0
	
func remove_path_child_we():
	$PathWE/PathFollowWE/RemoteTransform3D.remote_path = ""
	$PathWE/PathFollowWE.progress = 0

func add_path_child_ew(node):
	$PathEW/PathFollowEW/RemoteTransform3D.remote_path = node.get_path()
	return $PathEW/PathFollowEW

func add_path_child_we(node):
	$PathWE/PathFollowWE/RemoteTransform3D.remote_path = node.get_path()
	return $PathWE/PathFollowWE
