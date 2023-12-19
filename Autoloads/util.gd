extends Node

var rng = RandomNumberGenerator.new()

func _ready():
	rng.seed = 12

func shuffle(array):
	for i in array.size():
		var rand_idx = rng.randi_range(0,array.size()-1)
		if rand_idx == i:
			pass
		else:
			var temp = array[rand_idx]
			array[rand_idx] = array[i]
			array[i] = temp
	return array
