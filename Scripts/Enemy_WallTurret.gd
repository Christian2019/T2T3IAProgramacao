extends Node2D

export var DetectionDistance = 450

var state = "Idle"
var state_in_process=false
var bullet = preload("res://Scenes/BulletEnemy.tscn")
var shoot_cd=false
var extra_shoot_cd=true
var extra_shoot_cd_time=1
var RotationCD=false
var firstTime=true

var life =3
var stop=false
var player1
var player2
var player

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	if (stop):
		return
	firstLoad()
	closePlayer()
	drawLine()
	chageState()

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
	var linha =	Global.MainScene.get_node("Line2D")
	if (position.distance_to(player.position)<DetectionDistance):
		linha.default_color= Color.red
	else:
		linha.default_color= Color("6680ff")
	linha.clear_points()
	linha.add_point(Vector2(position.x,position.y))
	linha.add_point(Vector2(player.position.x,player.position.y))

func chageState():
	if (state_in_process):
		return
	match state:
		"Idle":
			f_idle()
		"Transition":
			f_transition()
		"Active":
			f_active()
		_:
			print("default")

	
func f_idle():
		$Structure.animation= "Idle"
		if (position.distance_to(player.position)<DetectionDistance):
			state_in_process=true
			state = "Transition"
			$Transition.start()

func f_transition():
		$Structure.animation= "Transition"
		$Cannon.visible=false
		$BulletCD.stop()
		$RotationCD.stop()
		RotationCD=false
		shoot_cd=false
		extra_shoot_cd=true
		if (position.distance_to(player.position)<DetectionDistance):
			state_in_process=true
			state = "Active"
			$Transition.start()
			$ExtraBulletCD.stop()
			$ExtraBulletCD.wait_time=$Transition.wait_time+extra_shoot_cd_time
			$ExtraBulletCD.start()
		else:
			state_in_process=true
			state = "Idle"
			$Transition.start()

func f_active():
		$Structure.animation= "Active"
		$Cannon.visible=true
		if (position.distance_to(player.position)>DetectionDistance):
			state_in_process=true
			state = "Transition"
			$Transition.start()
		else:
			f_rotation()
			fire()

func f_rotation():
	if (RotationCD):
		return
	RotationCD=true
	$RotationCD.start()
	var angleToPlayer= rad2deg(player.position.angle_to_point(position))
	var playerAverageIntervalAngle = getAverageIntervalAngle(angleToPlayer)
	var cannonAverageIntervalAngle = getAverageIntervalAngle($Cannon.rotation_degrees)
	
	#Turn
	if (playerAverageIntervalAngle!=cannonAverageIntervalAngle):
		extra_shoot_cd=true
		$ExtraBulletCD.stop()
		$ExtraBulletCD.wait_time=extra_shoot_cd_time
		$ExtraBulletCD.start()
		var rotationAngle =getRotationAngle(playerAverageIntervalAngle,cannonAverageIntervalAngle)
		$Cannon.rotation_degrees = rotationAngle

func getRotationAngle(playerAverageIntervalAngle,cannonAverageIntervalAngle):
	var steps_clockwise=0
	var steps_counter_clockwise=0 
	
	var clockwise_Position = cannonAverageIntervalAngle
	while (clockwise_Position!=playerAverageIntervalAngle):
		if (clockwise_Position==180):
			clockwise_Position=-180
		else:
			steps_clockwise+=1
			clockwise_Position+=30

	var counter_clockwise_Position = cannonAverageIntervalAngle

	while (counter_clockwise_Position!=playerAverageIntervalAngle):
		if (counter_clockwise_Position==-180):
			counter_clockwise_Position=180
		else:
			steps_counter_clockwise+=1	
			counter_clockwise_Position-=30

	if (steps_clockwise<steps_counter_clockwise):
		return cannonAverageIntervalAngle+30
	else:
		return cannonAverageIntervalAngle-30

func getAverageIntervalAngle(angle):
	#print("angle: ",angle)
	if (angle>180):
		angle = -180+(angle-180)
	elif(angle<-180):
		angle = 180+(angle+180)

	for index in range(0,-181,-30):
		if (angle>=(index-15) and angle<index+15):
			return index
	
	for index in range(0,181,30):
		if (angle>=(index-15) and angle<index+15):
			return index
	
func fire():
	if (!shoot_cd and !extra_shoot_cd):
		shoot_cd=true
		$BulletCD.start()
		var newbullet = bullet.instance()
		newbullet.position = position
		var bulletDistanceFromCenter=50
		newbullet.angle= $Cannon.rotation_degrees
		newbullet.position.x+=bulletDistanceFromCenter*cos(deg2rad($Cannon.rotation_degrees))
		newbullet.position.y+=bulletDistanceFromCenter*sin(deg2rad($Cannon.rotation_degrees))
		get_tree().current_scene.add_child(newbullet)
	
func destroy():
	if (!stop):
		stop=true
		$Explosion.visible=true
		$Structure.visible=false
		$Cannon.visible=false
		$Area2D.queue_free()
		timerCreator("queue_free",2,null,true)
								

func _on_Transition_timeout() -> void:
	state_in_process=false

func _on_BulletCD_timeout() -> void:
		shoot_cd=false

func _on_RotationCD_timeout() -> void:
	RotationCD=false
	
func _on_ExtraBulletCD_timeout() -> void:
	extra_shoot_cd=false

func _on_Teste_timeout() -> void:
	pass

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
