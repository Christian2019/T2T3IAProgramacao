extends KinematicBody2D

export (int) var speed = 250
export var rotation_speed = 1.5
export var gravity = 2500
export var jump_speed = 1000
export var  cont_jump=2		 
var side=-1
var life=1

var velocity = Vector2()
#var maxVelocityY=480
var maxVelocityY=600
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

var Tile_Floor_Colider

var Collision_With_Tile_Floor
var Collision_With_Tile_Water
var Collision_With_Tile_DeathZone

var RightFootOnTileFloor=false
var LeftFootOnTileFloor=false



func _ready() -> void:
	z_index=1
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
		if (!isJumping and Collision_With_Tile_Floor): 
			velocity.y = -jump_speed
			isJumping=true

func changeState():
	if(state==actions.RUN and ((RightFootOnTileFloor and !LeftFootOnTileFloor) or (!RightFootOnTileFloor and LeftFootOnTileFloor))):
		rng.randomize()
		var rand_chance=rng.randi_range(0,10) 
		if(rand_chance >= 0 and rand_chance<=5):
			if ($Animation.flip_h):
				run_right()
			else:
				run_left()
		else:
			state=actions.JUMP
			jump()
	elif(state==actions.JUMP and Collision_With_Tile_Floor and !isJumping):  
		state=actions.RUN 
		$Animation.play("Run")
		velocity.y=0
		fit()
		
	if (Collision_With_Tile_Water or Collision_With_Tile_DeathZone):
		#print("morteChangeState")
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

	if (velocity.y>0):
		isJumping=false
		
	if  (state==actions.DEAD or (!Collision_With_Tile_Floor or state==actions.JUMP)):	
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
	
	if (velocity.y>maxVelocityY):
		velocity.y=maxVelocityY
	velocity = move_and_slide(velocity, Vector2.UP)


func fit ():
	if(Tile_Floor_Colider==null):
		return
	var distanceToFoot= $FootPoint.global_position.y - global_position.y
	var fitPosition = Tile_Floor_Colider.global_position.y-Tile_Floor_Colider.shape.extents.y
	fitPosition+=1
	global_position.y=fitPosition-distanceToFoot
	

func destroy():
	if (state==actions.DEAD):
		return
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
	
func insideScreen():
	var camera = Global.MainScene.get_node("Camera2D")
	var cameraPosition = camera.global_position
	var cameraWidth = camera.cameraExtendsX*2
	var maxDistance =cameraWidth*2

	if (global_position.x<-300 or global_position.x>10307 or global_position.y>965):
		print("fora da tela")
		destroy()
	#elif (global_position.x<cameraPosition.x-cameraExt*4 or global_position.x>cameraPosition.x+cameraExt*4 ):
	elif (global_position.distance_to(cameraPosition)>maxDistance):
		#print("destrui por longe da camera")
		destroy()

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
		
func _on_Timer_timeout() -> void:
	#print(global_position)
	pass

func _on_SoldierColision_area_entered(area: Area2D) -> void:
	if (area.get_parent().is_in_group("Player")):
		var player = area.get_parent()
		if (player.contactCollision==area.get_children()[0]):
			#print(area.name)
			player.dead=true
	

		
	

func _on_RightFoot_area_entered(area: Area2D) -> void:
	if (area.name=="Floor"):
		RightFootOnTileFloor=true


func _on_RightFoot_area_exited(area: Area2D) -> void:
	if (area.name=="Floor"):
		RightFootOnTileFloor=false


func _on_LeftFoot_area_entered(area: Area2D) -> void:
	if (area.name=="Floor"):
		LeftFootOnTileFloor=true


func _on_LeftFoot_area_exited(area: Area2D) -> void:
	if (area.name=="Floor"):
		LeftFootOnTileFloor=false




func _on_FootCollision_area_entered(area: Area2D) -> void:
	if (area.name=="Floor"):
		Collision_With_Tile_Floor=true
	elif (area.name=="DeathZone"):
		Collision_With_Tile_DeathZone=true
	elif (area.name=="Water"):
		Collision_With_Tile_Water=true


func _on_FootCollision_area_exited(area: Area2D) -> void:
		if (area.name=="Floor"):
			Collision_With_Tile_Floor=false
			
		elif (area.name=="DeathZone"):
			Collision_With_Tile_DeathZone=false
		elif (area.name=="Water"):
			Collision_With_Tile_Water=false


func _on_FootCollision_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if (area==null):
		return
	if (area.name=="Floor"):
		Tile_Floor_Colider=area.get_children()[area_shape_index]


func _on_FootCollision_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if (area==null):
		return
	if (area.name=="Floor"):
		if (area.get_children()[area_shape_index]==Tile_Floor_Colider):
			Tile_Floor_Colider=null
