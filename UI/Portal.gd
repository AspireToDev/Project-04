extends Area2D


func _ready():
	pass


func _on_Portal_body_entered(body):
	if body.name == "Player":
		var scene = get_tree().change_scene("res://UI/WinOne.tscn")
