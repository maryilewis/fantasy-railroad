class_name TownNode extends SquareBaseNode

var display_name ="Cool Town Name"
var trains_in_station = []
var products = [] # array of type CargoType value
var jobs = [] # array of jobs

# TODO this will need to change for multiplayer
func train_arrives(train):
	trains_in_station.append(train)
	
func train_departs(train):
	trains_in_station.erase(train)

func zoom_to_town():
	print("zoom to ", display_name)

func _ready():
	build_road()
	_pick_random_cargo()
	display_name = _random_town_name()

func evaluate_visible_roads():
	if (visible_roads != null):
		visible_roads.evaluate_visible_roads(false)

func _pick_random_cargo():
	var cargoArray = []
	for c in Cargo.CargoType:
		cargoArray.append(c)
	products.append(cargoArray[randi_range(0, cargoArray.size() - 1)])

func _random_town_name():
	var ends = ["burg", "ton", " Town", " City", "ville", "sville", "town", " Place"]
	var starts = ["Place", "Where", "Here", "There", "Okay", "Well"]
	return starts[randi() % starts.size()] + ends[randi() % ends.size()]
	
