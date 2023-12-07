extends Node3D

# terrain
@onready var flat = preload("res://Square Scenes/flat.tscn")
@onready var forest = preload("res://Square Scenes/forest.tscn")
@onready var water = preload("res://Square Scenes/water.tscn")
@onready var town = preload("res://Square Scenes/town.tscn")
@onready var road = preload("res://Square Scenes/road.tscn")
# train
@onready var train = preload("res://Vehicles/train.tscn")

var train_instance
var train_progress: PathFollow3D
var current_road: RoadNode
var current_j = 2
var direction = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	create_map()
	train_instance = $Train
	move_train_along()

func create_map():
	for i in range(10):
		for j in range(10):
			var key = WorldMapData.map_plan[i][j]
			var new_square
			if (i == 7):
				new_square = road.instantiate()
			else:
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
			add_child(new_square)
			WorldMapData.map_nodes[i].append(new_square)


func move_train_along():
	if (current_road != null):
		current_road.remove_path_child()
	current_road = WorldMapData.map_nodes[7][current_j]
	if (direction == -1):
		train_progress = current_road.add_path_child_ew(train_instance)
	elif (direction == 1):
		train_progress = current_road.add_path_child_we(train_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (train_progress.progress_ratio >= .99):
		if (current_j == 9 and direction == 1):
			direction = -1
		elif (current_j == 0 and direction == -1):
			direction = 1
		else:
			current_j += direction
		move_train_along()
		
