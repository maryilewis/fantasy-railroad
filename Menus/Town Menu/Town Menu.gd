class_name TownMenu extends Control

var town: TownNode

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_town(_town):
	town = _town
	$Panel/VBoxContainer/RichTextLabel.text = "Welcome to " + town.display_name

	#add_button ( String text, bool right=false, String action="" )
	#for job in list, is it this town and do you have the cargo? if so, add a button (hide when the job is complete)
	#for export in this town, add a button to pick some up (disabled if you have no room)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_close_pressed():
	MenuService.close_town_menu()
