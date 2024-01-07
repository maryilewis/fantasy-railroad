class_name VisibleRoads extends MeshInstance3D

var map_x
var map_y
@onready var west = get_node("West") # TODO try out
@onready var south = get_node("South")
@onready var east = get_node("East")
@onready var north = get_node("North")
@onready var pole = get_node("Pole")
var all_meshes = []

func _ready():
	all_meshes.append(west)
	all_meshes.append(south)
	all_meshes.append(east)
	all_meshes.append(north)
	all_meshes.append(pole)

func init(x,y):
	map_x = x
	map_y = y

func evaluate_visible_roads(show_if_no_connectors):
	var visible_count = 0
	if(map_x > 0 and GameData.map_nodes[map_x - 1][map_y].is_traversible()):
		west.show()
		visible_count += 1
	else:
		west.hide()
	if(map_x + 1 < GameData.map_nodes.size() and GameData.map_nodes[map_x + 1][map_y].is_traversible()):
		east.show()
		visible_count += 1
	else:
		east.hide()
	if(map_y > 0 and GameData.map_nodes[map_x][map_y - 1].is_traversible()):
		north.show()
		visible_count += 1
	else:
		north.hide()
	if(map_y + 1 < GameData.map_nodes[map_x].size() and GameData.map_nodes[map_x][map_y + 1].is_traversible()):
		south.show()
		visible_count += 1
	else:
		south.hide()
	if (show_if_no_connectors and visible_count == 0):
		for dir in all_meshes:
			dir.show()

func hide_roads():
	for dir in all_meshes:
		dir.hide()

func set_custom_material(mat):
	for dir in all_meshes:
		dir.set_surface_override_material(0, mat)

func clear_custom_material():
	for dir in all_meshes:
		dir.set_surface_override_material(0, null)

