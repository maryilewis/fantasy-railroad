extends Control

#TODO: I think this should be a log and a tooltip

var town: TownNode

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show_menu(_town):
	town = _town
	#$PanelContainer/Panel/MarginContainer/RichTextLabel.text = "You have arrived in " + town.display_name
	#add_button ( String text, bool right=false, String action="" )
	#for job in list, is it this town and do you have the cargo? if so, add a button (hide when the job is complete)
	#for export in this town, add a button to pick some up (disabled if you have no room)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
