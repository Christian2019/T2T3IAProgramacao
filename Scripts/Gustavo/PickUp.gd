extends Area2D

export (Array, Texture) var falcons

export var falcon_index = 0
var speed = 80
var vertical_force = -5
export var gravityForce = 6

var stop = false

func _ready():
	$Sprite.texture = falcons[falcon_index]

func _process(delta):
	if stop:
		return
	
	gravity()
	horizontal_velocity()

func gravity():
	position.y += vertical_force
	vertical_force += gravityForce * Fps.MAX_FPS

func horizontal_velocity():
	position.x += speed * Fps.MAX_FPS

func _on_PickUp_area_entered(area):
	if area.is_in_group("Ground"):
		if vertical_force > 0:
			stop = true


func _on_PickUp_body_entered(body):
	if body.is_in_group("Player"):
		body.bullet_type = falcon_index
		print("Arma player: ", body.bullet_type)
		queue_free()
