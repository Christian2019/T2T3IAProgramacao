extends Node2D

enum states{WAIT,ACTIVE,DEATH}
var state=states.WAIT
var bullet = preload("res://Scenes/BulletEnemy.tscn")
var shoot_now=false;
var vertical_speed  = -8

var life =1
var stop=false
var player1
var player2
var player
var firstTime=true
var camera

var canShoot=true

func _ready() -> void:   
	$AnimatedSprite.flip_h=true 

func _physics_process(delta: float) -> void:
	
	if (stop):
		return 
	if (state==states.DEATH):
		global_position.y+=vertical_speed
		return  
	firstLoad()
	closePlayer()
	insideScreen()
	
	if(state==states.ACTIVE):
		changeAnimation()
		shoot_bullet()

func closePlayer():
	if (Global.players==2):
		if (global_position.distance_to(player2.global_position)<global_position.distance_to(player1.global_position)):
				 player = player2
		else:
			player = player1

func firstLoad():
	if (firstTime):
		firstTime=false	
		camera = Global.MainScene.get_node("Camera2D")
		player1 = Global.MainScene.get_node("Player")
		player = player1
		if (Global.players==2):
			player2 = Global.MainScene.get_node("Player2")

func changeAnimation(): 
	if((player.position.x-position.x) < 0):
		$AnimatedSprite.flip_h=true; 
	else: 
		$AnimatedSprite.flip_h=false     
		
	var angle= rad2deg(player.position.angle_to_point(global_position))
	
	if(angle>20 and angle<160):
		$AnimatedSprite.animation="Down"
	elif(angle<-20 and angle>-160):
		$AnimatedSprite.animation="Up"
	else:
		$AnimatedSprite.animation="Normal"
	
func shootinPosition():
		if($AnimatedSprite.animation=="Down"):
			return createVector2(-16,12)
		elif($AnimatedSprite.animation=="Up"):
			return createVector2(-10,-15)
		else:
			return createVector2(-17,-2)

		
func createVector2(x,y):
	if(!$AnimatedSprite.flip_h):
		x*=-1
	return Vector2(position.x+x*scale.x,position.y+y*scale.x)
	
func shoot_bullet():
	if (!canShoot):
		return 
	canShoot=false
	timerCreator("changeCanShoot",1,null,true)
	var newbullet = bullet.instance()  
	newbullet.position=shootinPosition()
	newbullet.angle= rad2deg(player.position.angle_to_point(newbullet.position))
	#print(newbullet.angle)
	Global.MainScene.add_child(newbullet)

func changeCanShoot():
	canShoot=true

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
 
func destroy():
	if (state!=states.DEATH):
		state=states.DEATH
		$AnimatedSprite.animation="Death"
		$Area2D.queue_free()
		timerCreator("death",0.2,null,true)
	
func death():
		stop=true
		$AnimatedSprite.animation="Explode"
		timerCreator("queue_free",0.5,null,true)

func insideScreen():
	var distance = camera.cameraExtendsX
	
	if (Vector2(global_position.x,0).distance_to(Vector2(camera.global_position.x,0))<distance):
		state=states.ACTIVE
	else:
		state=states.WAIT

func _on_Area2D_area_entered(area: Area2D) -> void:
	if (area.get_parent().is_in_group("Player")):
		var player = area.get_parent()
		if (player.contactCollision==area.get_children()[0]):
			#print(area.name)
			player.dead=true
