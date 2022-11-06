extends Area2D


enum states{SHOOT,STOP}
export(NodePath) var player;
var state=states.STOP

var angulo=-180
var player_position
var tiros=3
var segundos=3
var positions:Array
export var DetectionDistance = 450
var bullet = preload("res://Scenes/Mateus/Bullet.tscn")
var shoot_now=false;
var player_;

var rotation_direction;
signal killPlayer()
func _ready() -> void:   
	$ChangeState.start() 
	$AnimatedSprite.flip_h=true 
	pass # Replace with function body.
	 
 
func _physics_process(delta: float) -> void:    
	player_position=get_node(player).position      
	player_=get_node(player)  
	changeAnimation()
	rotation_direction=rotation_dir()

func rotation_dir():  
	var angle=rad2deg((player_position-position).normalized().angle()) 
	if((angle >= -180 and angle<=-160)  or (angle >=-20 and angle <=0)):
		return "CENTER"
	elif(angle< -160 or angle < 0):
		return "UP"
	return "DOWN"
	
func changeAnimation(): 
	if((player_position.x-position.x) < 0):
		$AnimatedSprite.flip_h=true; 
	else: 
		$AnimatedSprite.flip_h=false     
	
	if(rotation_direction=="CENTER"):
		$AnimatedSprite.animation="AimNormalShoot"
	elif(rotation_direction=="UP"):
		$AnimatedSprite.animation="AimUpShoot"
	else:
		$AnimatedSprite.animation="AimShootDown"
	
func shootinAngle():
	if((player_position.x-position.x) < 0):
		if(rotation_direction=="DOWN"):
			return Vector2(position.x-60,position.y-40)
		elif(rotation_direction=="UP"):
			return Vector2(position.x-60,position.y-110) 
		else:
			return Vector2(position.x-60,position.y-90) 
			
	else: 
		if(rotation_direction=="DOWN"):
			return Vector2(position.x+20,position.y-30)
		elif(rotation_direction=="UP"):
			return Vector2(position.x,position.y-120) 
		else:
			return Vector2(position.x+20,position.y-70) 
		
func shoot_bullet():  
	var newbullet = bullet.instance()  
	newbullet.position=shootinAngle() 
	var bulletDistanceFromCenter=50 
	newbullet.angle= rad2deg((player_position-position).angle()) 
	newbullet.position.x+=bulletDistanceFromCenter*cos(deg2rad(rad2deg(player_position.angle())))
	newbullet.position.y+=bulletDistanceFromCenter*sin(deg2rad(rad2deg(player_position.angle())))
	
	if(rotation_direction=="CENTER"):
		$AnimatedSprite.play("AimNormalShoot")
	elif(rotation_direction=="UP"):
		$AnimatedSprite.play("AimUpShoot")
	else:
		$AnimatedSprite.play("AimShootDown")
	get_tree().current_scene.add_child(newbullet) 
	
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
 


func _on_StandEnemy_area_entered(area):
	emit_signal("killPlayer")
	pass # Replace with function body.

 
func _on_ChangeState_timeout() -> void: 
	if(state==states.SHOOT):   
			state=states.STOP  
			$AnimatedSprite.stop()
			$AnimatedSprite.frame=0
			$ChangeState.start() 
	else:   
			state=states.SHOOT     
			shoot_bullet()
			timerCreator("shoot_bullet",1) 
			timerCreator("shoot_bullet",2) 
