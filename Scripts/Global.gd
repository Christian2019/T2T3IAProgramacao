extends Node
var Inverse_MAX_FPS
func _ready() -> void:
	Inverse_MAX_FPS= 1.0/ProjectSettings.get_setting("physics/common/physics_fps")



