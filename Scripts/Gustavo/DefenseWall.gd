extends Node2D

export (Texture) var destroyed_wall_sprite

var node_shoot_cannon_1
var node_shoot_cannon_2
var ready_cannon = false

var has_node_1 = true
var has_node_2 = true

func _ready():
	node_shoot_cannon_1 = $Cannon1
	node_shoot_cannon_2 = $Cannon2
	node_shoot_cannon_1.shoot()
	$Timer.start()
	

func _on_Timer_timeout():
	if ready_cannon:
		if not node_shoot_cannon_1.destroyed:
			node_shoot_cannon_1.shoot()
	else:
		if not node_shoot_cannon_2.destroyed:
			node_shoot_cannon_2.shoot()
	ready_cannon = !ready_cannon

func _on_Door_tree_exited():
	#$Wall.texture = destroyed_wall_sprite
	$Wall.visible = false
	#node_shoot_cannon_1.destroy_turret()
	#node_shoot_cannon_2.destroy_turret()
	node_shoot_cannon_1.queue_free()
	node_shoot_cannon_2.queue_free()
	$InFrontPlayerWall.visible = true
	$Timer.stop()
	
	#Chamar a animação final da fase
	print("Fim da fase")
