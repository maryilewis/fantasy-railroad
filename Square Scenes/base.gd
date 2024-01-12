class_name SquareBaseNode extends Node3D

var discovered = true
var discovery_effect_distance = 30;
var tween: Tween

#region build info
@onready var flat_mesh = get_node("Flat/CollisionShape3D/MeshInstance3D")
var hover_material = preload("res://Square Scenes/materials/light.tres")
var path_scene = preload("res://Square Scenes/road/paths.tscn")
var visible_road_scene = preload("res://Square Scenes/road/visible_roads.tscn")
var build_preview_scene = preload("res://Menus/Hovers/base hover.tscn")
var map_x: int
var map_y: int
var map_elevation = 0
var road_cost = 4
var holding_mouse_click = false
#endregion

#region traversal info
var path_progress = 0
var speed = .05
var path_refs = {}
var paths: PathNode
var visible_roads: VisibleRoads
var preview_roads: VisibleRoads
#endregion

#region state
var _is_traversible = false
var _is_buildable = true

func is_traversible():
	return _is_traversible;

func is_buildable():
	return _is_buildable;
	
func build_road():
	if (_is_buildable):
		hide_build_cost_preview()
		# todo: add a little number that rises and fades
		_is_buildable = false
		_is_traversible = true
		paths = path_scene.instantiate()
		add_child(paths)
		visible_roads = visible_road_scene.instantiate()
		visible_roads.init(map_x, map_y)
		add_child(visible_roads)

func evaluate_visible_roads():
	if (visible_roads != null):
		visible_roads.evaluate_visible_roads(true)
#endregion state

# custom initialize function
func initialize(_map_x, _map_y, _position, _discovered):
	map_x = _map_x
	map_y = _map_y
	position = _position
	discovered = _discovered
	if !discovered:
		self.visible = false

func discover():
	if (!discovered):
		var actual_position = Vector3(position)
		position.y -= discovery_effect_distance
		discovered = true
		visible = true
		tween = get_tree().create_tween() # of self.create_tween()
		var tween_length = 3 + Util.rng.randf_range(-1, 1)
		tween.tween_property(self, "position", actual_position, tween_length).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_IN_OUT)

func _on_click():
	if (is_traversible()):
		CursorService.set_train_destination(self)
	else:
		check_and_build_road()

func check_and_build_road():
	# TODO: road previews instead of actual roads
	if (is_buildable()):
		GameData.build_road(map_x, map_y)
		JobService.pay_for_road(road_cost)

func add_path_child(key, node):
	return paths.add_path_child(key, node)
	
func remove_path_child(key):
	return paths.remove_path_child(key)

func _on_hover():
	MenuService.update_location(map_x, map_y)
	if (is_buildable()):
		if(Input.is_mouse_button_pressed( MOUSE_BUTTON_LEFT )):
			check_and_build_road()
		# show road preview
		preview_roads = visible_road_scene.instantiate()
		preview_roads.init(map_x, map_y)
		add_child(preview_roads)
		preview_roads.set_custom_material(hover_material)
		# show price
		show_build_cost_preview()

func _on_unhover():
	if (preview_roads != null):
		remove_child(preview_roads)
		preview_roads.queue_free()
		# hide build price
		hide_build_cost_preview()

# todo click and drag to build
func _on_flat_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT):
			if (event.is_pressed()):
				_on_click()

var build_cost_preview
func show_build_cost_preview():
	build_cost_preview = build_preview_scene.instantiate()
	build_cost_preview.global_position = GameData.world_camera.unproject_position(self.global_position)
	build_cost_preview.set_text("Build: -" + str(road_cost))
	add_child(build_cost_preview)

func hide_build_cost_preview():
	if (build_cost_preview != null):
		remove_child(build_cost_preview)
		build_cost_preview.queue_free()

func _process(_delta):
	pass
