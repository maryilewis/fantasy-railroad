class_name JobList extends Control

@onready var list_container = get_node("ScrollContainer/MarginContainer/VBoxContainer")

var jobs

func set_jobs(_jobs):
	jobs = _jobs

# Called when the node enters the scene tree for the first time.
func _ready():
	populate_job_list()

func populate_job_list():
	for j in list_container.get_children():
		list_container.remove_child(j)
		j.queue_free()
	for job in jobs:
		var hbc = HBoxContainer.new()
		list_container.add_child(hbc)
		var label = Label.new()
		label.text = "$" + str(job.payment) + ": " + job.cargo + " to "
		hbc.add_child(label)
		var link = LinkButton.new()
		link.text = job.town.display_name
		# change to calling the camera and sending the town in "bind"
		link.pressed.connect(job.town.zoom_to_town.bind())
		hbc.add_child(link)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
