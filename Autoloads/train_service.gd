extends Node

#region direct trains
@onready var train_ref = preload("res://Vehicles/train.tscn")
var target_train: Train
var train: TrainParent

func init_trains():
	train = train_ref.instantiate()
	add_child(train)
	print("train", train)
	target_train = train.get_engine()
	print("engine", train)

func set_target_train(node):
	target_train = node

func set_target_train_destination(node):
	target_train.set_destination(node.map_x, node.map_y)

#endregion

func disable_train_click():
	train.disable_click()
	
func enable_train_click():
	train.enable_click()

func is_train_at_node(node: SquareBaseNode):
	return train.get_engine().current_road == node

# Called when the node enters the scene tree for the first time.
func _ready():
	print("placing trains...")
	init_trains()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

