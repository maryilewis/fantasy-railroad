class_name VisibleRoads extends MeshInstance3D

var map_x
var map_y

func evaluate_visible_roads():
	if(map_x > 0 and GameData.map_nodes[map_x - 1][map_y].is_traversible()):
		$West.show()
	else:
		$West.hide()
	if(map_x + 1 < GameData.map_nodes.size() and GameData.map_nodes[map_x + 1][map_y].is_traversible()):
		$East.show()
	else:
		$East.hide()
	if(map_y > 0 and GameData.map_nodes[map_x][map_y - 1].is_traversible()):
		$North.show()
	else:
		$North.hide()
	if(map_y + 1 < GameData.map_nodes[map_x].size() and GameData.map_nodes[map_x][map_y + 1].is_traversible()):
		$South.show()
	else:
		$South.hide()

