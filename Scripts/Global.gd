extends Node
var Inverse_MAX_FPS
var players=1
var MainScene
func _ready() -> void:
	MainScene=get_node("/root").get_children()[1]
	Inverse_MAX_FPS= 1.0/ProjectSettings.get_setting("physics/common/physics_fps")

func _process(delta: float) -> void:
	MainScene=get_node("/root").get_children()[1]

