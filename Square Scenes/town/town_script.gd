class_name TownNode extends TraversibleNode

# TODO: a static menu that just shows info about what you're hovering

# Called when the node enters the scene tree for the first time.
func _ready():
	super()

func _on_click():
	super()
	print("town click")

func evaluate_visible_roads():
	visible_roads_ref.evaluate_visible_roads(false)

func _on_hover():
	#print("hover town ", map_x,", ", map_y)
	pass


func _on_unhover():
	#print("unhover town ", map_x,", ", map_y)
	pass
