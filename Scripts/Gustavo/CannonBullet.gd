extends Area2D

var horizontal_speed
var vertical_force = -2
export var gravityForce=5

var stop = false

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	horizontal_speed = rng.randi_range(40,80)

func _process(delta):
	if stop:
		return
	
	gravity()
	horizontal_velocity()
	
	if position.y > 72:
		explode()

func gravity():
	position.y += vertical_force
	vertical_force += gravityForce * Fps.MAX_FPS

func horizontal_velocity():
	position.x -= horizontal_speed * Fps.MAX_FPS

func explode():
	stop = true
	$Sprite.visible = false
	$AnimatedSprite.visible = true
	$AnimatedSprite.play("explosion")
	#queue_free()


func _on_AnimatedSprite_animation_finished():
	queue_free()


func _on_CannonBullet_body_entered(body):
	if body.is_in_group("Player"):
		explode()
		print("F")
