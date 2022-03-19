extends Node

onready var SM = get_parent()
onready var player = get_node("../..")

func _ready():
	yield(player, "ready")

func start():
	player.set_animation("Light")

func physics_process(_delta):
	if not player.animating:
		var light = player.get_node("Attack/Slash")
		if light.is_colliding():
			var enemy = light.get_collider()
			if enemy.has_method("damage"):
				enemy.damage(player.light_attack)
		SM.set_state("Idle")
