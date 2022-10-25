extends KinematicBody2D

export (int) var speed = 250 
export var gravity = 2500
export var jump_speed = 1000 
export (PackedScene) var box2 : PackedScene 
var velocity = Vector2()
var rotation_dir = 0 # ang. inicial de rotação

onready var target := position # alvo inicial é a própria posição
onready var player := $Player

#ESTADOS DA IA
enum estados_IA{RUN_RIGHT,RUN_LEFT}

#ESTOU BATENDO EM UMA PAREDE OU NAO HA MAIS CHAO? 
var hitting_left_wall=false
var hitting_right_wall=false
var hittin_right_floor=false
var hittin_left_floor=false

var state=estados_IA.RUN_LEFT
var side=0

func get_side_input(): 
	var speed_ajust : int = speed
	var jump_ajust: float = jump_speed 
	if Input.is_key_pressed(KEY_SHIFT):
		#print("Shift")
		speed_ajust *= 2
		jump_ajust *= 1.3		 
	velocity.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	velocity.x = velocity.x * speed_ajust # = velocity.normalized() * speed
	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y = -jump_ajust
		 
 
	 
func run_left(delta):  
	velocity.x=-1
	side=-1
	velocity.x = velocity.x * speed # = velocity.normalized() * speed

func run_right(delta): 
	velocity.x=1 
	print(velocity.x)
	velocity.x = velocity.x * speed # = velocity.normalized() * speed
	
func detect_floor():
	#Detecção de chao a esquerda
	if($LeftDetectionDown.is_colliding()):
		hittin_left_floor=true
	elif(not $LeftDetectionDown.is_colliding()):
		hittin_left_floor=false
	#Detecção de chao a direita
	if($RightDetectionDown.is_colliding()):
		hittin_right_floor=true
	elif(not $RightDetectionDown.is_colliding()): 
		hittin_right_floor=false
	#detectando se tem uma parede a esquerda
	if($LeftWallDetection.is_colliding()):
		hitting_left_wall=true
	elif(not $LeftWallDetection.is_colliding()): 
		hitting_left_wall=false
	#detectando se tem uma parede a direita
	if($RightWallDetection.is_colliding()):
		hitting_right_wall=true
	elif(not $RightWallDetection.is_colliding()):
		hitting_right_wall=false
	
func change_state():
	if(not hittin_left_floor or hitting_left_wall): 
			state=estados_IA.RUN_RIGHT
	elif(not hittin_right_floor or hitting_right_wall):
			state=estados_IA.RUN_LEFT 


func _physics_process(delta):  
	detect_floor()
	change_state()
	if(state==estados_IA.RUN_LEFT):
		run_left(delta)
	elif(state==estados_IA.RUN_RIGHT):
		run_right(delta)
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_DeathZoneArea_area_entered(area: Area2D) -> void:
	
	print("MORRE")
	print("IMPULSE X")
	pass # Replace with function body.


func _on_DamageZoneArea_area_entered(area: Area2D) -> void:
	print("DA DANO AO PLAYER")
	pass # Replace with function body.
