extends Node2D

var speed = 400
var direction := Vector2(1,0)


func set_rotation(rotation):
	rotation_degrees = rotation


func _on_Timer_timeout():
	queue_free()
