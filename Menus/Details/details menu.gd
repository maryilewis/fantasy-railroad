class_name DetailsMenu extends Control

var selecting_destination = false
var target_train

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_destination_button_pressed():
	GameData.set_selecting_train_destination()
	# TODO THESE CAN BE DIFFERENT
	GameData.set_target_train(GameData.train_camera.get_follow_ref())
