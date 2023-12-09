extends Node

var map_plan = []
var map_nodes = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(10):
		map_plan.append(['.', '.', '.', 'w', '.', 'f', '.', '.', 't', '.'])
		map_nodes.append([])
	for i in range(10):
		for j in range(10):
			if i == 7:
				map_plan[i][j] = 'r'

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
