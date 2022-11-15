extends Node2D

export var DetectionDistance = 450

var state = -180
var state_in_process=false
var bullet = preload("res://Scenes/BulletEnemy.tscn")
var shoot_cd=false
var RotationCD=false
var life =7
var player1
var player2
var player
var stop=false
var firstTime=true

func _ready() -> void:
	pass

	
func _physics_process(delta: float) -> void:
	
	if (stop):
		return
			
	firstLoad()
	closePlayer()		
	drawLine()
	stateController()
	if (global_position.distance_to(Global.MainScene.get_node("Camera2D").global_position)<Global.MainScene.get_node("Camera2D").cameraExtendsX):
		fire()
func closePlayer():
	if (Global.players==2):
		if (global_position.distance_to(player2.global_position)<global_position.distance_to(player1.global_position)):
				 player = player2
		else:
			player = player1
func firstLoad():
	if (firstTime):
		firstTime=false	
		player1 = Global.MainScene.get_node("Player")
		player = player1
		if (Global.players==2):
			player2 = Global.MainScene.get_node("Player2")
			
		

func drawLine():
	var linha = Global.MainScene.get_node("Line2D")
	if (position.distance_to(player.position)<DetectionDistance):
		linha.default_color= Color.red
	else:
		linha.default_color= Color("6680ff")
	linha.clear_points()
	linha.add_point(Vector2(position.x,position.y))
	linha.add_point(Vector2(player.position.x,player.position.y))

			
func changeState():
	if (RotationCD):
		return
	var angleToPlayer= rad2deg(player.position.angle_to_point(position))
	var playerSliceAngle = getSliceAngle(angleToPlayer)
	var cannonSliceAngle = state
	if (playerSliceAngle!=cannonSliceAngle):
		RotationCD=true
		timerCreator("setRotationCD",1,null,true)
		if (playerSliceAngle>cannonSliceAngle):
			state+=30
		else:
			state-=30		

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

func setRotationCD():
	RotationCD=false
	
func setShootCD():
	shoot_cd=false

func shoot():
	var newbullet = bullet.instance()
	newbullet.position = position
	var bulletDistanceFromCenter=50
	newbullet.angle= state
	newbullet.position.x+=bulletDistanceFromCenter*cos(deg2rad(state))
	newbullet.position.y+=bulletDistanceFromCenter*sin(deg2rad(state))
	get_tree().current_scene.add_child(newbullet)

func getSliceAngle(angle):
	#print("angle: ",angle)
	if (angle>180):
		angle = -180+(angle-180)
	elif(angle<-180):
		angle = 180+(angle+180)

	if (angle<=(-150+15) and angle>(-150-15)):
		return -150
	elif ((angle<=(-150-15)) or angle>=30):
		return -180
	else:
		return -120
			

func stateController():
	
	changeState()
	
	match state:
		-120:
			$Structure.animation="120"
		-150:
			$Structure.animation="150"
		-180:
			$Structure.animation="180"
		_:
			print("default")

	
func fire():
	if (!shoot_cd):
		if (outOfRange()):
			return
			
		shoot_cd=true
		shoot()
		timerCreator("shoot",0.5,null,true)
		timerCreator("shoot",1,null,true)
		timerCreator("setShootCD",3,null,true)
		

func outOfRange():
	var angle= rad2deg(player.position.angle_to_point(position))
	if (angle>180):
		angle = -180+(angle-180)
	elif(angle<-180):
		angle = 180+(angle+180)
	
	if ((angle>-90 and angle <0) or (angle>0 and angle<135)):
		return true
	else:
		return false

func destroy():
	if (!stop):
		stop=true
		$Explosion.visible=true
		$Structure.visible=false
		$Area2D.queue_free()
		timerCreator("queue_free",2,null,true)

func _on_Teste_timeout() -> void:
	pass
