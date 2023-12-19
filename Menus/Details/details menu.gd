class_name DetailsMenu extends Control

var selecting_destination = false

func _ready():
	JobService.connect_job_list_scene($TabContainer/Jobs) # TODO: is this really the direction I want this going in?
	update_cargo_list()

func _on_destination_button_pressed():
	CursorService.set_selecting_train_destination()
	# TODO camera train and target train CAN BE DIFFERENT
	TrainService.set_target_train(GameData.train_camera.get_follow_ref())


func _on_build_button_pressed():
	CursorService.set_building()

func update_cargo_list():
	var text = "Cargo: "
	if TrainService.train.cargo_list.size():
		text += ", ".join(TrainService.train.cargo_list)
	else:
		text += "none"
	$TabContainer/Trains/VBoxContainer/Label.text = text

func _on_follow_train_pressed():
	GameData.world_camera.set_follow_ref(TrainService.train.get_engine())
