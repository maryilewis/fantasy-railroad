class_name JobList extends Control

func set_jobs(jobs):
	for j in $ScrollContainer/VBoxContainer.get_children():
		$ScrollContainer/VBoxContainer.remove_child(j)
		j.queue_free()
	for job in jobs:
		var hbc = HBoxContainer.new()
		$ScrollContainer/VBoxContainer.add_child(hbc)
		var label = Label.new()
		label.text = "Bring " + job.cargo + " to "
		hbc.add_child(label)
		var link = LinkButton.new()
		link.text = job.town.display_name
		# change to calling the camera and sending the town in "bind"
		link.pressed.connect(job.town.zoom_to_town.bind())
		hbc.add_child(link)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
