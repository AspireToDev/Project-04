extends Node

onready var SM = get_parent()
onready var player = get_node("../..")

func _ready():
	yield(player, "ready")

func start():
	player.set_animation("Heavy")

func physics_process(_delta):
	if not player.animating:
		var heavy = player.get_node("Attack/Slash")
		if heavy.is_colliding():
			var enemy = heavy.get_collider()
			if enemy.has_method("damage"):
				enemy.damage(player.heavy_attack)
		SM.set_state("Idle")
