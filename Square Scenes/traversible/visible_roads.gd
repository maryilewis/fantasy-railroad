class_name VisibleRoads extends MeshInstance3D

var map_x
var map_y

func evaluate_visible_roads(show_if_no_connectors):
	var visible_count = 0
	if(map_x > 0 and GameData.map_nodes[map_x - 1][map_y].is_traversible()):
		$West.show()
		visible_count += 1
	else:
		$West.hide()
	if(map_x + 1 < GameData.map_nodes.size() and GameData.map_nodes[map_x + 1][map_y].is_traversible()):
		$East.show()
		visible_count += 1
	else:
		$East.hide()
	if(map_y > 0 and GameData.map_nodes[map_x][map_y - 1].is_traversible()):
		$North.show()
		visible_count += 1
	else:
		$North.hide()
	if(map_y + 1 < GameData.map_nodes[map_x].size() and GameData.map_nodes[map_x][map_y + 1].is_traversible()):
		$South.show()
		visible_count += 1
	else:
		$South.hide()
	if (show_if_no_connectors and visible_count == 0):
		$West.show()
		$East.show()
		$North.show()
		$South.show()
