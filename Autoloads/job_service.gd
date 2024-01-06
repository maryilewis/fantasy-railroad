extends Node
## List of jobs in the word

var _job_list = []
var visible_job_list = []
var job_menu
var money = 200
@onready var job_menu_ref = preload("res://Menus/Job List/Job List.tscn")

func _generate_job_list():
	for town in GameData.towns:
		for cargo_type in CargoService.CargoType:
			if (!town.products.has(cargo_type)):
				_job_list.append({
					"town": town,
					"cargo": cargo_type,
					"payment": _calculate_payment(town, cargo_type)
				})
	_job_list = Util.shuffle(_job_list)

func _calculate_payment(town: TownNode, cargo_type):
	var shortest_distance = GameData.map_size * 2 + 1
	#var closest_source = null
	for source_town in GameData.towns:
		if source_town.products.has(cargo_type):
			var dist = abs(source_town.map_x - town.map_x) + abs(source_town.map_y - town.map_y)
			if dist < shortest_distance:
				shortest_distance = dist
				#closest_source = source_town
	return shortest_distance

func _init_visible_job_list():
	for i in range(0, 3):
		visible_job_list.append(_job_list.pop_front())

# Called when the node enters the scene tree for the first time.
func _ready():
	print("generating jobs...")
	_generate_job_list()
	_init_visible_job_list()
	job_menu = job_menu_ref.instantiate()
	job_menu.set_jobs(visible_job_list)
	MenuService.add_job_menu(job_menu)
	update_menu_money()

func get_jobs_by_town(town):
	return visible_job_list.filter(func(job): return job.town == town)
	
func complete_job(job):
	money += job.payment
	update_menu_money()
	visible_job_list.erase(job)
	visible_job_list.append(_job_list.pop_front())
	job_menu.set_jobs(visible_job_list)
	
func pay_for_road(amount):
	money -= amount
	update_menu_money()

func can_afford(amount):
	return money >= amount
	
func update_menu_money():
	MenuService.update_money(money)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
