extends Area2D

export var angle = 0
export var speed = 200
var stop = false

func _physics_process(delta: float) -> void:
	if stop:
		return
	
	position.x += speed*Fps.MAX_FPS*cos(deg2rad(angle))
	position.y += speed*Fps.MAX_FPS*sin(deg2rad(angle))

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_BulletEnemy_body_entered(body):
	if body.is_in_group("Player"):
		$AnimatedSprite.play("pop")
		stop = true
		$Timer.start()
		print("F")


func _on_Timer_timeout():
	queue_free()
