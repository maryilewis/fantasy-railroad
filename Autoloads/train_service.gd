extends Node

#region direct trains
@onready var train_ref = preload("res://Vehicles/train.tscn")
var target_train: Train
var trains = []

func init_trains():
	var first_train = train_ref.instantiate()
	trains.append(first_train)
	for train in trains:
		add_child(train)
		print("train", train)
		target_train = train.get_engine()
		print("engine", train)

func set_target_train(node):
	target_train = node

func set_train_destination(node):
	if (GameData.cursor_state == GameData.CursorState.SELECTING_TRAIN_DESTINATION):
		GameData.cursor_state = GameData.CursorState.FREE
		target_train.set_destination(node.map_x, node.map_y)

#endregion

# Called when the node enters the scene tree for the first time.
func _ready():
	print("placing trains...")
	init_trains()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

