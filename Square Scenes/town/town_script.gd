class_name TownNode extends SquareBaseNode

var display_name = "Cool Town Name"
var products = [] # array of type CargoType value
var wants = [] # array of type CargoType value
var jobs = [] # array of jobs
var town_type: GameData.TownType

func zoom_to_town():
	print("zoom to ", display_name)
	GameData.world_camera.set_follow_ref(self)

func _ready():
	build_road()
	display_name = _random_town_name()
	# TODO show building based on type

func set_town_type(new_town_type):
	town_type = new_town_type
	match town_type:
		GameData.TownType.GRAIN_FARM:
			$Silo.show()
			$Inn.hide()

func add_product(new_product):
	if not products.has(new_product):
		products.append(new_product)

func add_want(new_want):
	if not wants.has(new_want):
		wants.append(new_want)

func evaluate_visible_roads():
	if (visible_roads != null):
		visible_roads.evaluate_visible_roads(false)

func _random_town_name():
	var ends = ["burg", "ton", " Town", " City", "ville", "sville", "town", " Place"]
	var starts = ["Place", "Where", "Here", "There", "Okay", "Well"]
	return starts[randi() % starts.size()] + ends[randi() % ends.size()]

func _on_click():
	if CursorService.cursor_state != CursorService.CursorState.SELECTING_TRAIN_DESTINATION:
		MenuService.show_town_menu(self)
	else:
		super()

