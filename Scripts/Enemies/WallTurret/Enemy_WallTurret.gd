extends Node2D

export var DetectionDistance = 200
var player
var state = "Idle"
var state_in_process=false
var bullet = preload("res://Scenes/Enemies/WallTurret/Bullet.tscn")
var shoot_cd=false



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
	$Cannon.rotation_degrees= rad2deg(player.position.angle_to_point(position))
	print(cos(deg2rad($Cannon.rotation_degrees)))


func fire():
	if (!shoot_cd):
		shoot_cd=true
		var newbullet = bullet.instance()
		newbullet.position = position
		var bulletDistanceFromCenter=50
		newbullet.angle= $Cannon.rotation_degrees
		newbullet.position.x+=bulletDistanceFromCenter*cos(deg2rad($Cannon.rotation_degrees))
		newbullet.position.y+=bulletDistanceFromCenter*sin(deg2rad($Cannon.rotation_degrees))
		get_tree().current_scene.add_child(newbullet)
	

func _on_Transition_timeout() -> void:
	state_in_process=false
	

func _on_Teste_timeout() -> void:
	shoot_cd=false
	pass



	
		



