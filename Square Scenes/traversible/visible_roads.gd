class_name VisibleRoads extends MeshInstance3D

var map_x
var map_y

func evaluate_visible_roads():
	if(GameData.map_nodes[map_x -1][map_y].is_traversible()):
		$West.show()
	else:
		$West.hide()
	if(GameData.map_nodes[map_x + 1][map_y].is_traversible()):
		$East.show()
	else:
		$East.hide()
	if(GameData.map_nodes[map_x][map_y - 1].is_traversible()):
		$North.show()
	else:
		$North.hide()
	if(GameData.map_nodes[map_x][map_y + 1].is_traversible()):
		$South.show()
	else:
		$South.hide()

