extends Node2D

export (PackedScene) var cannon_bullet

func shoot():
	var bullet_instance = cannon_bullet.instance()
	get_parent().get_parent().add_child(bullet_instance)
	bullet_instance.global_position = global_position
	#bullet_instance.set_scale(Vector2(2,2))
