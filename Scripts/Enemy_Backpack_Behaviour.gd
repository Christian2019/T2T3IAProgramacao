extends KinematicBody2D

export (int) var speed = 250
export var rotation_speed = 1.5
export var gravity = 2500
export var jump_speed = 1000
export var  cont_jump=2		 
var side=-1
var life=1

var velocity = Vector2()
var rotation_dir = 0 # ang. inicial de rotação
var state= actions.RUN
onready var target := position # alvo inicial é a própria posição
onready var player := $Animation
var rng = RandomNumberGenerator.new() 
enum actions{RUN,JUMP,TURN,DEAD} 
var isJumping=false 
var run:Vector2 
var dead=false
var stop=false



func _ready() -> void:
	player.rotation_degrees = 0 
	rng.randomize()
	player.stop()
	$Animation.flip_h=true;
	#target = position
 
func run_left():
	if (state==actions.DEAD):
		return
	$Animation.flip_h=true;  
	velocity.x=-1
	side=-1
	velocity.x = velocity.x * speed # = velocity.normalized() * speed

func run_right(): 
	if (state==actions.DEAD):
		return
	$Animation.flip_h=false;
	velocity.x=1  
	velocity.x = velocity.x * speed # = velocity.normalized() * speed
	
func jump():
		if (!isJumping and (isCollidingWithFloor($RayCast2D) or isCollidingWithFloor($RayCast2D2))): 
			velocity.y = -jump_speed
			isJumping=true
		
		
func isCollidingWithFloor(raycast):
	if (raycast.is_colliding()):
		if (raycast.get_collider().name=="Floor"):
			return true
	return false

func isCollidingWithWater(raycast):
	if (raycast.is_colliding()):
		if (raycast.get_collider().name=="Water"):
			return true
	return false

#Buraco
func isCollidingWithDeathZone(raycast):
	if (raycast.is_colliding()):
		if (raycast.get_collider().name=="DeathZone"):
			return true
	return false
	

func changeState():
	if(state==actions.RUN and (!$RayCast2D.is_colliding() and isCollidingWithFloor($RayCast2D2)) or
	(!$RayCast2D2.is_colliding() and isCollidingWithFloor($RayCast2D))):
		rng.randomize()
		var rand_chance=rng.randi_range(0,10) 
		if(rand_chance >= 0 and rand_chance<=5):
			if ($Animation.flip_h):
				run_right()
			else:
				run_left()
		else:
			state=actions.JUMP
	elif(state==actions.JUMP and isCollidingWithFloor($RayCast2D) and isCollidingWithFloor($RayCast2D2) and !isJumping):  
		state=actions.RUN 
		$Animation.play("Run")
		velocity.y=0
		
	if (isCollidingWithWater($RayCast2D) or isCollidingWithDeathZone($RayCast2D2)):
		print("morteChangeState")
		destroy()

func _physics_process(delta):
	
	if (stop):
		if ($Animation.frame==4):
			queue_free()
		return
	if (state!=actions.DEAD):
		insideScreen()
	if (state!=actions.DEAD):
		changeState()  
	
	if ($Animation.flip_h):
		run_left()
	else:
		run_right()
	if(state==actions.JUMP):
		jump()

	if (velocity.y>0):
		isJumping=false
	if  (state==actions.DEAD or (!$RayCast2D.is_colliding() and !$RayCast2D2.is_colliding())):	
		velocity.y += gravity * Global.Inverse_MAX_FPS
		$Animation.play("Jump")
	elif(!isJumping and state==actions.RUN): 
		$Animation.play("Run")
		velocity.y=0 
	if (state==actions.DEAD):
		velocity.x=0
		if $Animation.flip_h:
			velocity.x=100
		else:
			velocity.x=-100
	velocity = move_and_slide(velocity, Vector2.UP)


func destroy():
	
	state=actions.DEAD
	$SoldierColision.queue_free()
	$Animation.animation="Jump"
	velocity.x=0
	velocity.y = -jump_speed/1.2
	isJumping=true
	timerCreator("explode",0.5,null,true)
	"""
	velocity.y += gravity * Global.Inverse_MAX_FPS
	
	yield(get_tree().create_timer(0.5),"timeout") 
	velocity.y=0
	$Animation.animation="Explode"
	yield(get_tree().create_timer(1),"timeout");  
	queue_free()
	"""
	
func explode():
	stop=true
	$Animation.animation="Explode"

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

func _on_SoldierColision_area_entered(area: Area2D) -> void:
	if (area.get_parent().is_in_group("Player")):
		var player = area.get_parent()
		if (player.contactCollision==area.get_children()[0]):
			#print(area.name)
			player.dead=true
	

func insideScreen():
	var cameraPosition = get_parent().get_parent().get_parent().get_node("Camera2D").global_position
	var cameraExt = get_parent().get_parent().get_parent().get_node("Camera2D").cameraExtendsX

	if (global_position.x<-300 or global_position.x>10307 or global_position.y>965):
		destroy()
	elif (global_position.x<cameraPosition.x-cameraExt*4 or global_position.x>cameraPosition.x+cameraExt*4 ):
		#print("destrui por longe da camera")
		destroy()
	
func _on_Timer_timeout() -> void:
	#print(global_position)
	pass








