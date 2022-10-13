extends Node2D

export var DetectionDistance = 450
var player
var state = "Idle"
var state_in_process=false
var bullet = preload("res://Scenes/Enemies/WallTurret/Bullet.tscn")
var shoot_cd=false
var RotationCD=false



func _ready() -> void:
	player = get_parent().get_node("Player")
	pass 
	
func _physics_process(delta: float) -> void:
	drawLine()
	chageState()



func drawLine():
	var linha = get_parent().get_node("Line2D")
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
		if (position.distance_to(player.position)<DetectionDistance):
			state_in_process=true
			state = "Active"
			$Transition.start()
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
	#print ("playerAverageIntervalAngle: ",playerAverageIntervalAngle)
	#print ("cannonAverageIntervalAngle: ",cannonAverageIntervalAngle)
	if (playerAverageIntervalAngle!=cannonAverageIntervalAngle):
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
	if (!shoot_cd):
		shoot_cd=true
		$BulletCD.start()
		var newbullet = bullet.instance()
		newbullet.position = position
		var bulletDistanceFromCenter=50
		newbullet.angle= $Cannon.rotation_degrees
		newbullet.position.x+=bulletDistanceFromCenter*cos(deg2rad($Cannon.rotation_degrees))
		newbullet.position.y+=bulletDistanceFromCenter*sin(deg2rad($Cannon.rotation_degrees))
		get_tree().current_scene.add_child(newbullet)
	

func _on_Transition_timeout() -> void:
	state_in_process=false
	


func _on_BulletCD_timeout() -> void:
		shoot_cd=false

func _on_RotationCD_timeout() -> void:
	RotationCD=false

func _on_Teste_timeout() -> void:
	pass

