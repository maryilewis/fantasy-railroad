extends Node
## Create and change world map grid

# TODO rename to map service, make a new script for save/load data

#region camera
var world_camera: MaryWorldCamera
var train_camera: TrainCamera
#endregion

#region rng
var rng = RandomNumberGenerator.new() # TODO move to util
#endregion

#region map
signal map_updated

@onready var flat = preload("res://Square Scenes/flat/flat.tscn")
@onready var wheat = preload("res://Square Scenes/wheat/wheat.tscn")
@onready var sheep = preload("res://Square Scenes/sheep/sheep.tscn")
@onready var forest = preload("res://Square Scenes/forest/forest.tscn")
@onready var water = preload("res://Square Scenes/water/water.tscn")
@onready var town = preload("res://Square Scenes/town/town.tscn")
var map_plan = []
var map_nodes = []
var map_size = 24
var towns = []

enum SquareType {
	FLAT = 1,
	TOWN = 2,
	WATER = 3,
	FOREST = 4,
	WHEAT = 5,
	SHEEP = 6
}

class SquareDetails:
	var display_name: String
	var square_type: SquareType
	
	

# Called when the node enters the scene tree for the first time.
func _ready():
	print("planning map...")
	rng.seed = 12
	init_map_data2(map_size)
	print("creating map...")
	create_map()


func init_map_data2(size):
	for i in size:
		map_plan.append([])
	for i in size:
		for j in size:
			var dice_roll = rng.randi_range(1, 100)
			print("i: ", i, ", j: ", j, ", roll: ", dice_roll)
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
			elif (dice_roll >= 90):
				map_plan[i].append({
					"key": SquareType.WATER
				})
			elif (dice_roll >= 80):
				map_plan[i].append({
					"key": SquareType.FOREST
				})
			elif (dice_roll >= 75):
				map_plan[i].append({
					"key": SquareType.TOWN
				})
			elif (dice_roll >= 70):
				map_plan[i].append({
					"key": SquareType.WHEAT
				})
			elif (dice_roll >= 65):
				map_plan[i].append({
					"key": SquareType.SHEEP
				})
			else:
				map_plan[i].append({
					"key": SquareType.FLAT
				})
	map_plan[size/2][size/2] = {
		"key": SquareType.TOWN
	}

func create_map():
	var size = GameData.map_plan.size()
	for i in range(size):
		GameData.map_nodes.append([])
		for j in range(size): #assumes a square
			var key = GameData.map_plan[i][j].key
			var new_square
			match key:
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
			new_square.position = Vector3(i - size/2, 0, j - size/2)
			new_square.map_x = i
			new_square.map_y = j
			connect("map_updated", new_square.evaluate_visible_roads)
			GameData.map_nodes[i].append(new_square)
			add_child(new_square)
	# send signal that map is initialized
	emit_signal("map_updated")

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
