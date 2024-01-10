class_name SheepNode extends SquareBaseNode

var sheep_array = []

func _init():
	_is_buildable = true
	_is_traversible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	sheep_array = [$Sheep, $Sheep2, $Sheep3]
	for sheepy in sheep_array:
		#random_move(sheepy)
		pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	super(_delta)
	#sheep_wander()

func random_move(sheepy):
	var sheep_tween = get_tree().create_tween()
	sheep_tween.set_ease(tween.EASE_IN_OUT)
	var tween_destination = Vector3(sheepy.global_position.x + Util.rng.randf_range(-.3, .3), sheepy.global_position.y, sheepy.global_position.z + Util.rng.randf_range(-.3, .3))
	sheep_tween.tween_property(sheepy, "global_position", tween_destination, 5).set_delay(Util.rng.randf_range(0, 5))
	sheep_tween.tween_callback(random_move.bind(sheepy))

func sheep_wander():
	for sheepy in sheep_array:
		if (Util.rng.randi_range(0, 100) == 0):
			sheepy.transform = sheepy.transform.rotated_local(Vector3(1, 0, 0), .1)
