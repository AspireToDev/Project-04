extends Control


func _ready():
	pass


func _on_Continue_pressed():
	var _target = get_tree().change_scene("res://Level2.tscn")
	Global._ready()


func _on_Exit_pressed():
	get_tree().quit()


