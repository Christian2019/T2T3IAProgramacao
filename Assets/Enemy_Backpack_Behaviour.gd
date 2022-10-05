extends KinematicBody2D

export (int) var speed = 250
export var rotation_speed = 1.5
export var gravity = 2500
export var jump_speed = 1000
export var  cont_jump=2		 
  
var velocity = Vector2()
var rotation_dir = 0 # ang. inicial de rotação
var state= actions.RUN
onready var target := position # alvo inicial é a própria posição
onready var player := $Animation
var rng = RandomNumberGenerator.new()

enum actions{RUN,JUMP,TURN}
func _ready() -> void:
	player.rotation_degrees = 0 
	rng.randomize()
	player.stop()
	#target = position
 
func run(delta):
	velocity.x-=speed*delta

func jump(delta):
	if(is_on_floor()):
		velocity.y = -jump_speed
		velocity.x-=speed*delta

func turn(delta): 
	velocity.x+=speed*delta

func changeState():
	if(state==actions.RUN and not $RayCast2D.is_colliding()):
		state=actions.JUMP
	elif(state==actions.JUMP and $RayCast2D.is_colliding()):  
		state=actions.RUN
		
func _physics_process(delta): 
	changeState()
	if(state==actions.RUN):
		run(delta) 
	else: 
		var percentage=rng.randi_range(0,10)
		if(percentage > 0 and percentage <2):
			turn(delta)
		else:
			jump(delta) 
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)

