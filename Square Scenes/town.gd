extends Node3D

# TODO: a static menu that just shows info about what you're hovering

# Called when the node enters the scene tree for the first time.
func _ready():
	$"Town Menu".hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_static_body_3d_mouse_entered():
	$"Town Menu".position = get_viewport().get_mouse_position() + Vector2(-100, -50)
	$"Town Menu".show()


func _on_static_body_3d_mouse_exited():
	$"Town Menu".hide()
