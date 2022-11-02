extends Camera2D



func _ready() -> void:
	pass 


func _physics_process(delta: float) -> void:
	global_position.x = get_parent().get_node("Player").global_position.x
	if (global_position.x>500):
		Fps.global_position.x=global_position.x-500
	position.x = clamp(position.x,0+513,10307-513)
