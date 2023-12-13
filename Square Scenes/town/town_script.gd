class_name TownNode extends SquareBaseNode

# TODO: a static menu that just shows info about what you're hovering

func _ready():
	build_road()

func evaluate_visible_roads():
	if (visible_roads != null):
		visible_roads.evaluate_visible_roads(false)
