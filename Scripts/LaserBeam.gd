extends Area2D

export (Texture) var pop_sprite
var speed = 800
var stop=false


var hit_enemy = true

func _process(delta):
	if (!stop):
		position.x += speed * Global.Inverse_MAX_FPS


func _on_VisibilityNotifier2D_screen_exited():
		queue_free()

func _on_LaserBeam_area_entered(area: Area2D) -> void:
	if (area.get_parent().is_in_group("Enemy")):
		var enemy = area.get_parent()
		enemy.life-=1
		if (enemy.life<=0):
			enemy.destroy()
		destroy()

	if area.get_parent().is_in_group("Capsule"):
		area.get_parent().explode()
		destroy()

	elif area.is_in_group("Turret"):
		area.loose_life()
		destroy()
		
func destroy():
		stop=true
		$CollisionShape2D.queue_free()
		$Sprite.texture=pop_sprite
		timerCreator("queue_free",0.2,null,true)
		
func timerCreator(functionName,time,parameters,create):
	if (create):
		var timer = Timer.new()
		if (parameters==null):
			timer.connect("timeout",self,functionName)
		else:
			timer.connect("timeout",self,functionName,parameters)
		timer.set_wait_time(time)
		timer.one_shot=true
		timer.autostart=true
		call_deferred("add_child",timer)
		
	
		var timer2 = Timer.new()
		timer2.connect("timeout",self,"timerCreator",["",0,[timer,timer2],false])
		timer2.set_wait_time(time+1)
		timer2.one_shot=true
		timer2.autostart=true
		call_deferred("add_child",timer2)
	else:
		remove_child(parameters[0])
		remove_child(parameters[1])

