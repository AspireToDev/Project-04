extends Node2D

onready var Player = load("res://Player/Player.tscn")
var starting_position = Vector2(550,300)


func _ready():
	pass

func spawn(pos):
	if not has_node("Player"):
		var player = Player.instance()
		player.global_position = pos
		add_child(player)
		player.get_node("Camera2D").current = true



func _physics_process(_delta):
	spawn(starting_position)
