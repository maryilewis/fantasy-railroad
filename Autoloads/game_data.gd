extends Node
## Create and change world map grid

# TODO rename to map service, make a new script for save/load data

#region camera
var world_camera: MaryWorldCamera
var train_camera: TrainCamera
#endregion

#region map
signal map_updated

@onready var flat = preload("res://Square Scenes/flat/flat.tscn")
@onready var wheat = preload("res://Square Scenes/wheat/wheat.tscn")
@onready var sheep = preload("res://Square Scenes/sheep/sheep.tscn")
@onready var forest = preload("res://Square Scenes/forest/forest.tscn")
@onready var water = preload("res://Square Scenes/water/water.tscn")
@onready var town = preload("res://Square Scenes/town/town.tscn")
@onready var incline = preload("res://Square Scenes/incline/incline.tscn")

var map_plan = []
var map_nodes = []
const map_size = 100
const discovery_distance = 10
var towns = []

const ELEVATION_MULTIPLIER = .58

enum SquareType {
	FLAT = 1,
	TOWN = 2,
	WATER = 3,
	FOREST = 4,
	WHEAT = 5,
	SHEEP = 6,
	INCLINE = 7
}


# Called when the node enters the scene tree for the first time.
func _ready():
	print("planning map...")
	Util.rng.seed = 12
	init_map_data2(map_size)
	add_towns()
	#add_inclines()
	print("creating map...")
	create_map()

func add_towns():
	var spacing = 10
	for i in range(map_size/spacing):
		for j in range(map_size/spacing):
			var k = (i * spacing) + Util.rng.randi_range(2, spacing - 2)
			var l = (j * spacing) + Util.rng.randi_range(2, spacing - 2)
			add_town(k, l)

func add_town(x, y):
	if Util.rng.randi_range(0,1) == 0:
		add_wheat_town(x, y)
	else:
		add_sheep_town(x, y)
	
func add_wheat_town(x, y):
	for i in range(x-1, x+2):
		for j in range(y-1, y+2):
			map_plan[i][j] = {
				"key": SquareType.WHEAT
			}
		
	map_plan[x][y] = {
		"key": SquareType.TOWN,
		"products": CargoService.CargoType.GRAIN
	}

func add_sheep_town(x, y):
	for i in range(x-1, x+2):
		for j in range(y-1, y+2):
			map_plan[i][j] = {
				"key": SquareType.SHEEP
			}
		
	map_plan[x][y] = {
		"key": SquareType.TOWN,
		"products": CargoService.CargoType.WOOL
	}
	
			

func init_map_data2(size):
	var train_start = size/2
	for i in size:
		map_plan.append([])
	for i in size:
		for j in size:
			var dice_roll = Util.rng.randi_range(1, 100)
			var node_above
			var node_left
			if (j > 0):
				node_left = map_plan[i][j-1]
			if (i > 0):
				node_above = map_plan[i-1][j]
			if ((node_left && node_left.key == SquareType.WATER or node_above && node_above.key == SquareType.WATER) and dice_roll >= 50):
				map_plan[i].append({
					"key": SquareType.WATER
				})
			elif ((node_left && node_left.key == SquareType.FOREST or node_above && node_above.key == SquareType.FOREST) and dice_roll >= 70):
				map_plan[i].append({
					"key": SquareType.FOREST
				})
			elif (dice_roll >= 93):
				map_plan[i].append({
					"key": SquareType.WATER
				})
			elif (dice_roll >= 80):
				map_plan[i].append({
					"key": SquareType.FOREST
				})
			else:
				map_plan[i].append({
					"key": SquareType.FLAT
				})
	map_plan[train_start][train_start] = {
		"key": SquareType.TOWN
	}
	
func add_inclines():
	for i in range (54,59):
		GameData.map_plan[i][55] = {
			"key": SquareType.INCLINE
		}
		GameData.map_plan[i][54].elevation = 1
		GameData.map_plan[i][53].elevation = 1

func create_map():
	var size = GameData.map_plan.size()
	var train_start = size/2
	for i in range(size):
		GameData.map_nodes.append([])
		for j in range(size): #assumes a square world
			var discovered = true
			var node_def = GameData.map_plan[i][j]
			var new_square
			match node_def.key:
				SquareType.FLAT:
					new_square = flat.instantiate()
				SquareType.WATER:
					new_square = water.instantiate()
				SquareType.FOREST:
					new_square = forest.instantiate()
				SquareType.TOWN:
					new_square = town.instantiate()
					towns.append(new_square)
				SquareType.WHEAT:
					new_square = wheat.instantiate()
				SquareType.SHEEP:
					new_square = sheep.instantiate()
				SquareType.INCLINE:
					new_square = incline.instantiate()
				_:
					new_square = flat.instantiate()
			if (node_def.has("discovered")):
				discovered = node_def.get("discovered")
			elif pow(pow(train_start-i, 2) + pow (train_start-j, 2), .5) > discovery_distance:
				discovered = false
			var y
			if node_def.has("elevation"):
				y = node_def.elevation * ELEVATION_MULTIPLIER
			else:
				y = 0
			new_square.initialize(i, j, Vector3(i - size/2, y, j - size/2), discovered)
			connect("map_updated", new_square.evaluate_visible_roads)
			GameData.map_nodes[i].append(new_square)
			add_child(new_square)
	# send signal that map is initialized
	emit_signal("map_updated") # TODO evaluate inclines in this manner as well

#endregion

func get_traversible_neighbors(x, y):
	var neighbors = []
	for offset in [[-1, 0], [1, 0], [0, -1], [0, 1]]:
		var map_x = x + offset[0]
		var map_y = y + offset[1]
		if (map_y >= 0 \
			and map_x >= 0 \
			and map_x < GameData.map_nodes.size() \
			and map_y < GameData.map_nodes[map_x].size() \
			and GameData.map_nodes[map_x][map_y].is_traversible()):
				neighbors.append(GameData.map_nodes[map_x][map_y])
	return neighbors

func discover_map(x, y):
	for i in range(x - discovery_distance, x + discovery_distance):
		for j in range(y - discovery_distance, y + discovery_distance):
			if pow(pow(x-i, 2) + pow (y-j, 2), .5) <= discovery_distance:
				map_nodes[i][j].discover()

#region building
func build_road(x, y):
	map_nodes[x][y].build_road()
	for friend in get_traversible_neighbors(x, y):
		friend.evaluate_visible_roads()
	map_nodes[x][y].evaluate_visible_roads()
#endregion

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
