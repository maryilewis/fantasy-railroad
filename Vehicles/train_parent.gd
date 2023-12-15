extends Node3D

func disable_click():
	$Train/CollisionShape3D.disabled = true
func enable_click():
	$Train/CollisionShape3D.disabled = false
