class_name DetailsMenu extends Control
## Menu on the left hand side

func _ready():
	update_cargo_list()

## called when job service is ready
func add_job_menu(job_menu):
	$TabContainer/Jobs.add_child(job_menu)

#  TODO Maybe trainservice should call to add this to stay consistent with Job Service?
func update_cargo_list():
	var cargo_list = $"TabContainer/Trains/VBoxContainer/Cargo"
	for cargo_ui_child in cargo_list.get_children():
		cargo_list.remove_child(cargo_ui_child)
		cargo_ui_child.queue_free()
	
	var text = "Cargo: "
	if TrainService.train.cargo_list.size():
		for cargo_item in TrainService.train.cargo_list:
			var cargo_row = HBoxContainer.new()
			var cargo_label = Label.new()
			cargo_label.text = CargoService.get_display_name(cargo_item)
			var remove_cargo_button = Button.new()
			remove_cargo_button.text = "drop"
			remove_cargo_button.pressed.connect(TrainService.train.drop_off_cargo.bind(cargo_item))
			cargo_row.add_child(cargo_label)
			cargo_row.add_child(remove_cargo_button)
			cargo_list.add_child(cargo_row)
	else:
		var cargo_label = Label.new()
		cargo_label.text = "None"
		cargo_list.add_child(cargo_label)
	#$"TabContainer/Trains/VBoxContainer/Cargo Label".text = text

func update_money(money):
	$"TabContainer/Trains/VBoxContainer/Money Label".text = "Money: " + str(money)

func _on_follow_train_pressed():
	GameData.world_camera.set_follow_ref(TrainService.train.get_engine())
