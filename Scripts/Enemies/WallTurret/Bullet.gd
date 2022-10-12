extends AnimatedSprite
export var angle = 0
export var speed = 200

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	position.x += speed*delta*cos(deg2rad(angle))
	position.y += speed*delta*sin(deg2rad(angle))
