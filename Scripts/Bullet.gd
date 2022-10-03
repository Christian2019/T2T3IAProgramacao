extends Area2D

var speed = 500
var velocity : Vector2

func _ready():
	velocity.x = 1
	velocity.y = 0

func _process(delta):
	position += velocity * speed * delta

func set_speed(speed):
	self.speed = speed

func set_direction(dir):
	velocity.x = dir.x
	velocity.y = dir.y 

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
