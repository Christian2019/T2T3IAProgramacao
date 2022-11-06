extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var onTheTile=false 
export var index:int;
export var texture:Texture; 
var velocity = Vector2()
export var gravity = 2500
export var jump_speed = 1500
var isJumping=false 
var times_jumping=1;

signal get_gun(index)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.texture=texture; 
	
func _physics_process(delta):
	jump(delta)
	if (velocity.y>0):
		isJumping=false 
		$RayCast2D.enabled=true;
	if (!$RayCast2D.is_colliding()):	 
		velocity.y += gravity * Fps.MAX_FPS
	elif(!isJumping):
		velocity.y=0
	velocity = move_and_slide(velocity, Vector2.UP)
	
func jump(delta):  
		if (!isJumping and times_jumping>0): 
			velocity.y = -jump_speed
			times_jumping-=1
			isJumping=true

func _on_Area2D_area_entered(area): 
	if(area.is_in_group("Player")):
		emit_signal("get_gun",index)
	pass # Replace with function body.

