extends Node2D

var node_shoot_cannon_1
var node_shoot_cannon_2
var ready_cannon = false

var has_node_1 = true
var has_node_2 = true

func _ready():
	node_shoot_cannon_1 = get_node("Cannon1/ShootBullet")
	node_shoot_cannon_2 = get_node("Cannon2/ShootBullet")
	node_shoot_cannon_1.shoot()
	$Timer.start()

func _on_Timer_timeout():
	if not ready_cannon:
		if get_node_or_null("Cannon1"):
			node_shoot_cannon_1.shoot()
		ready_cannon = true
	else:
		if get_node_or_null("Cannon2"):
			node_shoot_cannon_2.shoot()
		ready_cannon = false

func _on_Door_tree_exited():
	print("acabou a fase!")
