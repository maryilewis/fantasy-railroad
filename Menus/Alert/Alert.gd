class_name AlertMenu extends Control


func show_alert(text):
	$Panel/MarginContainer/Text.text = text
	visible = true

func _on_ok_pressed():
	visible = false
