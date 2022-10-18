extends Node2D

func set_rotation(rotation):
	rotation_degrees = rotation


func _on_VisibilityNotifier2D_screen_exited():
	print("saiu")
	queue_free()

