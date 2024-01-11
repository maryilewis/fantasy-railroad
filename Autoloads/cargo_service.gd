extends Node
enum CargoType {
	GRAIN = 1,
	FLOUR = 2,
	WOOL = 3,
	BREAD = 4,
	CLOTHING = 5
}
var cargo_defs

func _ready():
	cargo_defs = {
		CargoType.GRAIN: {
			"display_name": "Grain",
		},
		CargoType.FLOUR: {
			"display_name": "Flour",
		},
		CargoType.WOOL: {
			"display_name": "Wool",
		},
		CargoType.BREAD: {
			"display_name": "Bread",
		},
		CargoType.CLOTHING: {
			"display_name": "Clothing",
		}
	}

func get_display_name(value):
	return cargo_defs[value].display_name
