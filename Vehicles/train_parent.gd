class_name TrainParent extends Node3D

var display_name

var cargo_list = []
func _ready():
	display_name = _get_random_train_name()

func get_engine():
	return $Train

func disable_click():
	$Train/CollisionShape3D.disabled = true
func enable_click():
	$Train/CollisionShape3D.disabled = false


# TODO: Remove from list once used
func _get_random_train_name():
		var names = ["Wilhelmina", "Emmaline", "Evangeline", "Elizabeth", "Abigail", "Adelaide", "Bridget", "Charlotte", "Delphine", "Frances", "Geraldine", "Henrietta", "Ingrid", "Jane", "Katherine", "Lisa", "Mary", "Nan", "Opal", "Phillipa", "Regina","Sarah", "Theodora", "Ursula", "Veronica", "Zelda"]
		var rng = RandomNumberGenerator.new()
		var my_random_number = rng.randi_range(0, names.size())
		return names[my_random_number - 1]
