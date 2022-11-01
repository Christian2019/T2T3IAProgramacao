extends Node2D
var MAX_FPS

func _ready() -> void:
	MAX_FPS= 1.0/ProjectSettings.get_setting("physics/common/physics_fps")
	var fps = Label.new()
	fps.rect_position =  Vector2(15,15)
	fps.text = ""
	fps.name="FPS"
	z_index=1
	scale.x=2
	scale.y=2
	add_child(fps)
	get_children()[0].set("custom_colors/font_color",Color("#ec0b0b"))

func _process(delta: float) -> void:
	get_node("FPS").text= "FPS: "+str(Engine.get_frames_per_second())
