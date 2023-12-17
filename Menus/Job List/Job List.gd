class_name JobList extends Control

func set_jobs(jobs):
	for job in jobs:
		var label = Label.new()
		label.text = "Bring " + job.cargo + " to " + job.town.display_name
		$Panel/ScrollContainer/VBoxContainer.add_child(label)
		var link = LinkButton.new()
		link.text = job.town.display_name
		# change to calling the camera and sending the town in "bind"
		link.pressed.connect(job.town.zoom_to_town.bind())
		$Panel/ScrollContainer/VBoxContainer.add_child(link)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
