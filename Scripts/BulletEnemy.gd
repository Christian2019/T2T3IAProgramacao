extends Area2D

export var angle = 0
export var speed = 200
var stop = false

func _physics_process(delta: float) -> void:
	if stop:
		return
	
	position.x += speed*Global.Inverse_MAX_FPS*cos(deg2rad(angle))
	position.y += speed*Global.Inverse_MAX_FPS*sin(deg2rad(angle))

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Timer_timeout():
	queue_free()


func _on_BulletEnemy_area_entered(area: Area2D) -> void:
	if (area.get_parent().is_in_group("Player")):
		var player = area.get_parent()
		if (player.contactCollision==area.get_children()[0]):
			#print(area.name)
			$AnimatedSprite.play("pop")
			stop = true
			$Timer.start()
			player.dead=true
			
	
