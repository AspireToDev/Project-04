extends KinematicBody2D

var health = 50

func _ready():
	pass 

func damage(d):
	health -= d
	if health <= 0:
		die()
	print(d)


func _on_Area2D_body_entered(body):
	if body.has_method("damage") and body != self:
		print("Collide")
		body.damage(30)
		die()
func die():
	Global.update_score(10)
	queue_free()
