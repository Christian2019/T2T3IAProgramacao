extends Node2D

export var DetectionDistance = 200
var player
var state = "Idle"
var state_in_process=false
var bullet = preload("res://Scenes/Enemies/WallTurret/Bullet.tscn")
var shoot_cd=false
var RotationCD=false



func _ready() -> void:
	pass 
	
func _physics_process(delta: float) -> void:
	updatePlayer()
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

			
func updatePlayer():
	player = get_parent().get_node("Player")
		

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
	var playerQuadrant = getQuadrant(angleToPlayer)
	var cannonQuadrant = getQuadrant($Cannon.rotation_degrees)
	if (playerQuadrant!=cannonQuadrant):
		var rotationAngle =getRotationAngle(playerQuadrant,cannonQuadrant)
		$Cannon.rotation_degrees = rotationAngle

func getRotationAngle(playerQuadrant,cannonQuadrant):
	var clockwise = [6,3,2,1,4,7,8,9]
	var counter_clockwise = [6,9,8,7,4,1,2,3]
	var steps_clockwise=0
	var steps_counter_clockwise=0 
	
	var clockwise_Position = clockwise.find(cannonQuadrant,0)
	while (clockwise[clockwise_Position]!=playerQuadrant):
		steps_clockwise+=1
		if (clockwise_Position+1>clockwise.size()-1):
			clockwise_Position=0
		else:
			clockwise_Position+=1
			
	var counter_clockwise_Position = counter_clockwise.find(cannonQuadrant,0)
	while (counter_clockwise[counter_clockwise_Position]!=playerQuadrant):
		steps_counter_clockwise+=1
		if (counter_clockwise_Position+1>counter_clockwise.size()-1):
			counter_clockwise_Position=0
		else:
			counter_clockwise_Position+=1

	var angle
	if (steps_clockwise<steps_counter_clockwise):
			var p = clockwise.find(cannonQuadrant,0)
			if (p+1>clockwise.size()-1):
				p=0
			else:
				p+=1
			angle= getAngle(clockwise[p])
		
	else:
			var p = counter_clockwise.find(cannonQuadrant,0)
			if (p+1>counter_clockwise.size()-1):
				p=0
			else:
				p+=1
			angle= getAngle(counter_clockwise[p])
	return angle

func getAngle(quadrant):
		if (quadrant==6):
			return 0
		elif(quadrant ==9):
			return -45
		elif(quadrant ==8):
			return -90
		elif(quadrant ==7):
			return -135
		elif(quadrant ==4):
			return -180
		elif(quadrant ==1):
			return 135
		elif(quadrant ==2):
			return 90
		elif(quadrant ==3):
			return 45
	
func getQuadrant(angle):
	var quadAngle=0
	if (angle>=(quadAngle-22.5) and angle<quadAngle+22.5):
		return 6
	quadAngle-=45
	if (angle>=(quadAngle-22.5) and angle<quadAngle+22.5):
		return 9
	quadAngle-=45
	if (angle>=(quadAngle-22.5) and angle<quadAngle+22.5):
		return 8
	quadAngle-=45
	if (angle>=(quadAngle-22.5) and angle<quadAngle+22.5):
		return 7 
	quadAngle=45
	if (angle>=(quadAngle-22.5) and angle<quadAngle+22.5):
		return 3
	quadAngle+=45
	if (angle>=(quadAngle-22.5) and angle<quadAngle+22.5):
		return 2
	quadAngle+=45
	if (angle>=(quadAngle-22.5) and angle<quadAngle+22.5):
		return 1
	else:
		return 4
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


func _on_Teste_timeout() -> void:
	pass



	
		







func _on_RotationCD_timeout() -> void:
	RotationCD=false
