extends Node2D

enum states {Wait,Crouching,Lower,Rise,Standing}
var bullet = preload("res://Scenes/BulletEnemy.tscn")
var life=1
var stop=false
var player1
var player2
var player
var firstTime=true
var state

var canShoot=true

func _ready(): 
	state=states.Wait
	player = Global.MainScene.get_node("Player") 

func shoot(): 
	if ($SpriteSoldadoArbusto.flip_h):
		shoot_bullet(-180)
	else:  
		shoot_bullet(0)


func shoot_bullet(dir):
	var newbullet = bullet.instance()
	newbullet.position = position
	var bulletDistanceFromCenter=50
	newbullet.angle= dir
	newbullet.position.x+=bulletDistanceFromCenter*cos(deg2rad(dir))
	newbullet.position.y+=bulletDistanceFromCenter*sin(deg2rad(dir))
	get_tree().current_scene.add_child(newbullet)

func _process(delta):
	if (stop):
		return

	if (Global.players==2):
		if (firstTime):
			firstTime=false
			player1 = Global.MainScene.get_node("Player")
			player2 = Global.MainScene.get_node("Player2")
			
		if (global_position.distance_to(player2.global_position)<global_position.distance_to(player1.global_position)):
			 player = player2
		else:
			player = player1

	statesController()

		
func statesController():
	var distance=global_position.x-player.global_position.x
	if(distance >= 0):  
		$SpriteSoldadoArbusto.flip_h=true
	else:   
		$SpriteSoldadoArbusto.flip_h=false
	
	if (state==states.Wait):
		$SpriteSoldadoArbusto.animation="Crouching"
		if (!playersClose()):
			return
		state=states.Rise
	elif (state==states.Rise):
		$SpriteSoldadoArbusto.animation="Rise"
		if ($SpriteSoldadoArbusto.frame==2):
			state=states.Standing
			timerCreator("changeStateToLower",5,null,true)
			canShoot=true
	elif (state==states.Standing):
		$SpriteSoldadoArbusto.animation="Standing"
		if (canShoot):
			canShoot=false
			timerCreator("changeCanShoot",1,null,true)
			shoot()
	elif (state==states.Lower):
		$SpriteSoldadoArbusto.animation="Lower"
		if ($SpriteSoldadoArbusto.frame==2):
			state=states.Crouching
			timerCreator("changeStateToRise",5,null,true)
	elif (state==states.Crouching):
		$SpriteSoldadoArbusto.animation="Crouching"
		

func changeStateToLower():
	state=states.Lower

func changeStateToRise():
	state=states.Rise
	
func changeCanShoot():
	canShoot=true

func playersClose():
	var camera =Global.MainScene.get_node("Camera2D")
	var cameraWidth = camera.cameraExtendsX*2
	var distanceToCamera = global_position.distance_to(camera.global_position)
	var minDistanceX = cameraWidth/2

	if (distanceToCamera<minDistanceX):
		return true
		
	return false

func destroy():
	if (!stop):
		stop=true
		$SpriteSoldadoArbusto.animation="Explode"
		$SpriteSoldadoArbusto.playing=true
		timerCreator("queue_free",0.5,null,true)

func timerCreator(functionName,time,parameters,create):
	if (create):
		var timer = Timer.new()
		if (parameters==null):
			timer.connect("timeout",self,functionName)
		else:
			timer.connect("timeout",self,functionName,parameters)
		timer.set_wait_time(time)
		add_child(timer)
		timer.one_shot=true
		timer.start()
	
		var timer2 = Timer.new()
		timer2.connect("timeout",self,"timerCreator",["",0,[timer,timer2],false])
		timer2.set_wait_time(time+1)
		add_child(timer2)
		timer2.one_shot=true
		timer2.start()
	else:
		remove_child(parameters[0])
		remove_child(parameters[1])


func _on_Area2D_area_entered(area: Area2D) -> void:
	if (area.get_parent().is_in_group("Player")):
		var player = area.get_parent()
		if (player.contactCollision==area.get_children()[0]):
			#print(area.name)
			player.dead=true