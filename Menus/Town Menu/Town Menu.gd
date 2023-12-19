class_name TownMenu extends Control

var town: TownNode
var jobs = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_town(_town):
	#remove all old buttons!!
	for child in $Panel/VBoxContainer.get_children():
		if child.is_class("Button"):
			$Panel/VBoxContainer.remove_child(child)
			child.queue_free()
	
	town = _town
	$Panel/VBoxContainer/RichTextLabel.text = "Welcome to " + town.display_name
	#add new butons
	jobs = JobService.get_jobs_by_town(town)
	for job in jobs:
		var button = Button.new()
		button.text = "Deliver " + job.cargo + " " + str(job.payment)
		button.pressed.connect(complete_job.bind(job))
		$Panel/VBoxContainer.add_child(button)
		button.set_meta("type", "job")
		button.set_meta("job", job)
	for product in town.products:
		var button = Button.new()
		button.text = "Pick up " + product
		button.pressed.connect(pick_up_cargo.bind(product))
		$Panel/VBoxContainer.add_child(button)
		button.set_meta("type", "cargo")
		button.set_meta("cargo", product)
	evaluate_buttonability()

func evaluate_buttonability():
	var train_is_here = TrainService.is_train_at_node(town)
	var the_train = TrainService.train
	for child in $Panel/VBoxContainer.get_children():
		if child.is_class("Button"):
			match child.get_meta("type"):
				"job":
					# if the train in town has the appropriate the cargo, you can complete a job
					if train_is_here and the_train.has_cargo(child.get_meta("job").cargo):
						(child as Button).disabled = false
					else:
						(child as Button).disabled = true
				"cargo":
					if train_is_here and the_train.has_room_for_cargo():
						(child as Button).disabled = false
					else:
						(child as Button).disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_close_pressed():
	MenuService.close_town_menu()
	
func complete_job(job):
	var the_train = TrainService.train
	the_train.drop_off_cargo(job.cargo)
	JobService.complete_job(job)
	# TODO disable the button, add a lil checkmark or something
	# TODO redo buttons entirely to see if there is a new job in town!
	evaluate_buttonability()

func pick_up_cargo(cargo):
	TrainService.train.pick_up_cargo(cargo)
	evaluate_buttonability()
