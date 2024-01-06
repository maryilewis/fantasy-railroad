extends Node
## updates Details menu and Town Menu. Need to rethink how these all talk.

@onready var town_menu_ref = preload("res://Menus/Town Menu/Town Menu.tscn")
@onready var details_menu_ref = preload("res://Menus/Details/details menu.tscn")
@onready var debug_menu_ref = preload("res://Menus/Debug/Debug Menu.tscn")
@onready var alert_ref = preload("res://Menus/Alert/Alert.tscn")
var town_menu: TownMenu
var details_menu: DetailsMenu
var debug_menu: DebugMenu
var alert: AlertMenu

# Called when the node enters the scene tree for the first time.
func _ready():
	print("menus...")
	town_menu = town_menu_ref.instantiate()
	add_child(town_menu)
	close_town_menu()
	
	details_menu = details_menu_ref.instantiate()
	add_child(details_menu)
	
	debug_menu = debug_menu_ref.instantiate()
	add_child(debug_menu)
	
	alert = alert_ref.instantiate()
	add_child(alert)

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
#endregion

#region alert
func show_alert(text):
	alert.show_alert(text)
#endregion

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

#region location
func update_location(x, y):
	debug_menu.update_location(x, y)
#endregion
