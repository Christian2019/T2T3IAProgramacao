extends Node2D

export var DetectionDistance = 450
var player
var state = -180
var state_in_process=false
var bullet = preload("res://Scenes/Enemies/Cannon/Bullet.tscn")
var shoot_cd=false
var RotationCD=false

func _ready() -> void:
	player = get_parent().get_node("Player")
	pass 
	
func _physics_process(delta: float) -> void:
	drawLine()
	stateController()
	fire()

func drawLine():
	var linha = get_parent().get_node("Line2D")
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
		timerCreator("setRotationCD",1)
		if (playerSliceAngle>cannonSliceAngle):
			state+=30
		else:
			state-=30		

func timerCreator(functionName,time):
	var timer = Timer.new()
	timer.connect("timeout",self,functionName)
	timer.set_wait_time(time)
	add_child(timer)
	timer.one_shot=true
	timer.start()

	var timer2 = Timer.new()
	timer2.connect("timeout",self,"timerDestroyer",[timer,timer2])
	timer2.set_wait_time(time+1)
	add_child(timer2)
	timer2.one_shot=true
	timer2.start()  
	
func timerDestroyer(timer,timer2):
	remove_child(timer)
	remove_child(timer2)

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
			$AnimatedSprite.animation="120"
		-150:
			$AnimatedSprite.animation="150"
		-180:
			$AnimatedSprite.animation="180"
		_:
			print("default")

	
func fire():
	if (!shoot_cd):
		if (outOfRange()):
			return
			
		shoot_cd=true
		shoot()
		timerCreator("shoot",0.5)
		timerCreator("shoot",1)
		timerCreator("setShootCD",3)
		

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

func _on_Teste_timeout() -> void:
	pass
