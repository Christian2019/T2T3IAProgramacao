extends KinematicBody2D

export (int) var speed = 250
export var rotation_speed = 1.5
export var gravity = 2500
export var jump_speed = 1000
export var  cont_jump=2		 
var side=-1

var velocity = Vector2()
var rotation_dir = 0 # ang. inicial de rotação
var state= actions.RUN
onready var target := position # alvo inicial é a própria posição
onready var player := $Animation
var rng = RandomNumberGenerator.new()

enum actions{RUN,JUMP,TURN}

var run:Vector2 

func _ready() -> void:
	player.rotation_degrees = 0 
	rng.randomize()
	player.stop()
	#target = position
 
func run_left(delta):  
	velocity.x=-1
	side=-1
	velocity.x = velocity.x * speed # = velocity.normalized() * speed

func run_right(delta): 
	velocity.x=1 
	print(velocity.x)
	velocity.x = velocity.x * speed # = velocity.normalized() * speed
	
func jump(delta):
	if(is_on_floor()):
		velocity.y = -jump_speed
		
 

func changeState():
	if(state==actions.RUN and not $RayCast2D.is_colliding()):
		rng.randomize()
		var rand_chance=rng.randi_range(0,10)
		print(rand_chance)
		if(rand_chance >= 0 and rand_chance<=9):
			state=actions.TURN
		else:
			state=actions.JUMP
	elif(state==actions.JUMP and $RayCast2D.is_colliding()):  
		state=actions.RUN  
	elif(state==actions.TURN and not $RayCast2D2.is_colliding()):  
		state=actions.RUN 
			
func _physics_process(delta): 
	changeState()  
	if(state==actions.RUN):  
		run_left(delta) 
	elif(state==actions.TURN):      
		run_right(delta) 
	elif(state==actions.JUMP):
		jump(delta)
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

