class_name DetailsMenu extends Control
## Menu on the left hand side

func _ready():
	update_cargo_list()

## called when job service is ready
func add_job_menu(job_menu):
	$TabContainer/Jobs.add_child(job_menu)

#  TODO Maybe trainservice should call to add this to stay consistent with Job Service?
func update_cargo_list():
	var text = "Cargo: "
	if TrainService.train.cargo_list.size():
		text += ", ".join(TrainService.train.cargo_list)
	else:
		text += "none"
	$"TabContainer/Trains/VBoxContainer/Cargo Label".text = text

func update_money(money):
	$"TabContainer/Trains/VBoxContainer/Money Label".text = "Money: " + str(money)

func _on_follow_train_pressed():
	GameData.world_camera.set_follow_ref(TrainService.train.get_engine())
