extends Node2D

#TODO: I think this should be a tooltip

var town: TownNode

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show_menu(_town):
	town = _town
	$RichTextLabel.text = "You have arrived in " + town.display_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
