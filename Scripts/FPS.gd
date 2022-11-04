extends Node2D
var MAX_FPS

func _ready() -> void:
	MAX_FPS= 1.0/ProjectSettings.get_setting("physics/common/physics_fps")

	


