class_name SheepNode extends SquareBaseNode

var sheep_array = []

func _init():
	_is_buildable = true
	_is_traversible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	sheep_array = [$Sheep, $Sheep2, $Sheep3]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	sheep_wander()

func sheep_wander():
	for sheepy in sheep_array:
		if (Util.rng.randi_range(0, 100) == 0):
			sheepy.transform = sheepy.transform.rotated_local(Vector3(1, 0, 0), .1)
