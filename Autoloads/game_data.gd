extends Node

#region camera
var world_camera: Camera3D
#endregion

#region map
@onready var flat = preload("res://Square Scenes/flat.tscn")
@onready var forest = preload("res://Square Scenes/forest/forest.tscn")
@onready var water = preload("res://Square Scenes/water.tscn")
@onready var town = preload("res://Square Scenes/town.tscn")
@onready var road = preload("res://Square Scenes/road.tscn")
#@onready var road = preload("res://Square Scenes/road.tscn")
var map_plan = []
var map_nodes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	init_map_data()
	create_map()

func init_map_data():
	map_plan.append(['.', '.', '.', '.', 'w', '.', '.', '.', '.', '.'])
	map_plan.append(['.', '.', '.', '.', 'w', 'w', '.', '.', '.', '.'])
	map_plan.append(['.', '.', '.', 'f', 'f', 'w', 'w', '.', '.', '.'])
	map_plan.append(['.', '.', 'f', 'f', 'f', 'f', 'w', '.', '.', '.'])
	map_plan.append(['.', '.', '.', 'f', 'f', 'f', 'w', '.', '.', '.'])
	map_plan.append(['.', '.', '.', '.', 'f', '.', 'w', '.', '.', '.'])
	map_plan.append(['.', 't', 'r', 'r', 'r', 'r', 'r', 'r', 't', '.'])
	map_plan.append(['.', '.', '.', '.', '.', 'f', 'w', '.', '.', '.'])
	map_plan.append(['w', 'w', '.', '.', '.', '.', 'w', 'w', 'f', '.'])
	map_plan.append(['w', 'w', '.', '.', '.', '.', '.', 'w', '.', '.'])

func create_map():
	for i in range(10):
		GameData.map_nodes.append([])
		for j in range(10):
			var key = GameData.map_plan[i][j]
			var new_square
			match key:
				'.':
					new_square = flat.instantiate()
				'w':
					new_square = water.instantiate()
				'f':
					new_square = forest.instantiate()
				't':
					new_square = town.instantiate()
				'r':
					new_square = road.instantiate()
			new_square.position = Vector3(i, 0, j)
			new_square.map_x = i
			new_square.map_y = j
			add_child(new_square)
			print(i, ", ", j, new_square.isTraversible)
			GameData.map_nodes[i].append(new_square)

#endregion

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
