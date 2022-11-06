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
var isJumping=false 
var run:Vector2 


signal killPlayer()

func _ready() -> void:
	player.rotation_degrees = 0 
	rng.randomize()
	player.stop()
	$Animation.flip_h=true;
	#target = position
 
func run_left(delta):
	$Animation.flip_h=true;  
	velocity.x=-1
	side=-1
	velocity.x = velocity.x * speed # = velocity.normalized() * speed

func run_right(delta): 
	$Animation.flip_h=false;
	velocity.x=1  
	velocity.x = velocity.x * speed # = velocity.normalized() * speed
	
func jump(delta):
		if (!isJumping and ($RayCast2D.is_colliding() or $RayCast2D2.is_colliding())): 
			velocity.y = -jump_speed
			isJumping=true
		
		
 

func changeState():
	if(state==actions.RUN and not $RayCast2D.is_colliding()):
		rng.randomize()
		var rand_chance=rng.randi_range(0,10) 
		if(rand_chance >= 0 and rand_chance<=2):
			state=actions.TURN
		else:
			state=actions.JUMP
	elif(state==actions.JUMP and $RayCast2D.is_colliding()):  
		state=actions.RUN  
	elif(state==actions.TURN and not $RayCast2D2.is_colliding()):  
		state=actions.RUN 

func _process(delta: float) -> void:
	if Input.is_action_pressed("Escape"):
		get_tree().change_scene("res://Scenes/Prototypes/PrototypeMenu.tscn")
	#if ($RayCast2D.is_colliding()):
		#print("true")

func _physics_process(delta): 
	changeState()  
	if(state==actions.RUN):  
		run_left(Fps.MAX_FPS) 
	elif(state==actions.TURN):      
		run_right(Fps.MAX_FPS) 
	elif(state==actions.JUMP):
		jump(Fps.MAX_FPS)
		
	if (velocity.y>0):
		isJumping=false
	if (!$RayCast2D.is_colliding() and !$RayCast2D2.is_colliding()):	
		velocity.y += gravity * Fps.MAX_FPS
		$Animation.play("Jump")
	elif(!isJumping): 
		$Animation.play("Run")
		velocity.y=0
		
	velocity = move_and_slide(velocity, Vector2.UP)


func _on_DeathZone_area_entered(area):
	if(area.is_in_group("Player")):
		emit_signal("killPlayer")
	pass # Replace with function body.
