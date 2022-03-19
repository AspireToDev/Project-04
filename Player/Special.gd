extends Node

onready var SM = get_parent()
onready var player = get_node("../..")

func _ready():
	yield(player, "ready")

func start():
	player.set_animation("Special")

func physics_process(_delta):
	if not player.animating:
		var special = player.get_node("Attack/Special")
		var specialB = player.get_node("Attack/Special_behind")
		if special.is_colliding():
			var enemy = special.get_collider()
			if enemy.has_method("damage"):
				enemy.damage(player.special)
		elif specialB.is_colliding():
			var enemyB = specialB.get_collider()
			if enemyB.has_method("damage"):
				enemyB.damage(player.special)
		SM.set_state("Idle")
