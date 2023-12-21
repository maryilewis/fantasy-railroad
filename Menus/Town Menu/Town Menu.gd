class_name TownMenu extends Control
## What town produces, what active jobs they have
## and TODO set as destination (if you aren't there already)

var town: TownNode
var jobs = []

@onready var list_container = get_node("Panel/MarginContainer/VBoxContainer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_town(_town):
	#remove all old buttons!!
	for child in list_container.get_children():
		if child.is_class("Button"):
			list_container.remove_child(child)
			child.queue_free()
	
	town = _town
	$Panel/MarginContainer/VBoxContainer/RichTextLabel.text = "Welcome to " + town.display_name
	#add new butons
	jobs = JobService.get_jobs_by_town(town)
	for job in jobs:
		var button = Button.new()
		button.text = "Deliver " + job.cargo + " " + str(job.payment)
		button.pressed.connect(complete_job.bind(job))
		list_container.add_child(button)
		button.set_meta("type", "job")
		button.set_meta("job", job)
	for product in town.products:
		var button = Button.new()
		button.text = "Pick up " + product
		button.pressed.connect(pick_up_cargo.bind(product))
		list_container.add_child(button)
		button.set_meta("type", "cargo")
		button.set_meta("cargo", product)
	var button = Button.new()
	button.text = "Set Destination"
	button.set_meta("type", "destination")
	button.pressed.connect(set_destination)
	list_container.add_child(button)
	evaluate_buttonability()

func set_destination():
	TrainService.set_target_train_destination(town)
	MenuService.close_town_menu()

func evaluate_buttonability():
	var train_is_here = TrainService.is_train_at_node(town)
	var the_train = TrainService.train
	for child in list_container.get_children():
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
				"destination":
					if (TrainService.is_train_at_node(town)):
						# TODO check for path
						(child as Button).disabled = true
					else:
						(child as Button).disabled = false

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
