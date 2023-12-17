extends Node

# when a train is in a town and the town is clicked, open the town menu with details from that town
# when town menu is closed, hide it

@onready var town_menu_ref = preload("res://Menus/Town Menu/Town Menu.tscn")
var town_menu: TownMenu

func close_town_menu():
	town_menu.visible = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print("adding town menu...")
	town_menu = town_menu_ref.instantiate()
	add_child(town_menu)
	#hide_town_menu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
