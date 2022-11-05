extends Area2D

var speed
var max_speed = 5
var vertical_force = -1
export var gravityForce=10

func _ready():
	randomize()
	speed = randi() % max_speed + 2

func _process(delta):
	gravity()
	horizontal_velocity()

func gravity():
	position.y+=vertical_force
	vertical_force+=gravityForce*Fps.MAX_FPS

func horizontal_velocity():
	position.x-=speed
