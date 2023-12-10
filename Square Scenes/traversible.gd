class_name TraversibleNode
extends SquareBaseNode

var path_progress = 0
var speed = .01

# TODO set up variables to avoid lots of $ and typing
# TODO set loop to false?

func _init():
	isTraversible = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if ($Paths/PathEW/PathFollowEW/RemoteTransform3D.remote_path):
		$Paths/PathEW/PathFollowEW.progress += speed
	if ($Paths/PathWE/PathFollowWE/RemoteTransform3D.remote_path):
		$Paths/PathWE/PathFollowWE.progress += speed

func remove_path_child():
	$Paths/PathEW/PathFollowEW/RemoteTransform3D.remote_path = ""
	$Paths/PathEW/PathFollowEW.progress = 0
	$Paths/PathWE/PathFollowWE/RemoteTransform3D.remote_path = ""
	$Paths/PathWE/PathFollowWE.progress = 0

func remove_path_child_ew():
	$Paths/PathEW/PathFollowEW/RemoteTransform3D.remote_path = ""
	$Paths/PathEW/PathFollowEW.progress = 0
	
func remove_path_child_we():
	$Paths/PathWE/PathFollowWE/RemoteTransform3D.remote_path = ""
	$Paths/PathWE/PathFollowWE.progress = 0

func add_path_child_ew(node):
	$Paths/PathEW/PathFollowEW/RemoteTransform3D.remote_path = node.get_path()
	return $Paths/PathEW/PathFollowEW

func add_path_child_we(node):
	$Paths/PathWE/PathFollowWE/RemoteTransform3D.remote_path = node.get_path()
	return $Paths/PathWE/PathFollowWE
