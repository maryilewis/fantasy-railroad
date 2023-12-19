class_name DetailsMenu extends Control

var selecting_destination = false

func _ready():
	update_cargo_list()
	
func add_job_menu(job_menu):
	$TabContainer/Jobs.add_child(job_menu)

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
	$"TabContainer/Trains/VBoxContainer/Cargo Label".text = text

func update_money(money):
	$"TabContainer/Trains/VBoxContainer/Money Label".text = "Money: " + str(money)

func _on_follow_train_pressed():
	GameData.world_camera.set_follow_ref(TrainService.train.get_engine())
