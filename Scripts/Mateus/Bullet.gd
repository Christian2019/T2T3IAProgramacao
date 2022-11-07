extends AnimatedSprite
export var angle = 0
export var speed = 200

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	position.x += speed*Global.Inverse_MAX_FPS*cos(deg2rad(angle))
	position.y += speed*Global.Inverse_MAX_FPS*sin(deg2rad(angle))



func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
