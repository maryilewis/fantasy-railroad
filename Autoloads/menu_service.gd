extends Node

# when a train is in a town and the town is clicked, open the town menu with details from that town
# when town menu is closed, hide it

@onready var town_menu_ref = preload("res://Menus/Town Menu/Town Menu.tscn")
@onready var details_menu_ref = preload("res://Menus/Details/details menu.tscn")
var town_menu: TownMenu
var details_menu: DetailsMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	print("menus...")
	town_menu = town_menu_ref.instantiate()
	add_child(town_menu)
	close_town_menu()
	
	details_menu = details_menu_ref.instantiate()
	add_child(details_menu)

#region town menu
func close_town_menu():
	town_menu.visible = false

func show_town_menu(town):
	town_menu.set_town(town)
	town_menu.visible = true
#endregion

#region details menu
func update_cargo_list():
	details_menu.update_cargo_list()
func update_money(money):
	details_menu.update_money(money)
func add_job_menu(job_menu):
	details_menu.add_job_menu(job_menu)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
