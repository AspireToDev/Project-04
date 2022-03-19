extends Node

onready var SM = get_parent()
onready var player = get_node("../..")

func _ready():
	yield(player, "ready")

func start():
	player.set_animation("Medium")

func physics_process(_delta):
	if not player.animating:
		var medium = player.get_node("Attack/Slash")
		if medium.is_colliding():
			var enemy = medium.get_collider()
			if enemy.has_method("damage"):
				enemy.damage(player.medium_attack)
		SM.set_state("Idle")
