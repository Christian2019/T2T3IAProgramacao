extends Area2D

export var angle = 0
export var speed = 200
var stop = false
var camera =  Global.MainScene.get_node("Camera2D")

func _ready() -> void:
	var new_parent = Global.MainScene.get_node("BulletsEnemy")
	get_parent().remove_child(self)
	new_parent.add_child(self)

func _physics_process(delta: float) -> void:
	outOfScreen()
	if stop:
		return
	position.x += speed*Global.Inverse_MAX_FPS*cos(deg2rad(angle))
	position.y += speed*Global.Inverse_MAX_FPS*sin(deg2rad(angle))

func destroy():
	$AnimatedSprite.play("pop")
	stop = true
	timerCreator("queue_free",1,null,true)


func _on_BulletEnemy_area_entered(area: Area2D) -> void:
	if (area.get_parent().is_in_group("Player")):
		var player = area.get_parent()
		if (player.contactCollision==area.get_children()[0]):
			destroy()
			player.dead=true
			
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
		
func outOfScreen():
	var ext=600
	if (camera.global_position.x-ext>global_position.x or camera.global_position.x+ext<global_position.x
	or camera.global_position.y-ext>global_position.y or camera.global_position.y+ext<global_position.y):
		queue_free()
