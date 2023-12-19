class_name DetailsMenu extends Control

var selecting_destination = false
var target_train

func _ready():
	JobService.connect_job_list_scene($TabContainer/Jobs)

func _on_destination_button_pressed():
	GameData.set_selecting_train_destination()
	# TODO camera train and target train CAN BE DIFFERENT
	TrainService.set_target_train(GameData.train_camera.get_follow_ref())


func _on_build_button_pressed():
	GameData.set_building()
