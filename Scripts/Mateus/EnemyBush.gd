extends StaticBody2D


enum states {STAND,SHOOT,WAIT}

export(NodePath) var player;
var timer=3
var player_node;
var status:int 
var bullet = preload("res://Scenes/Mateus/Bullet.tscn")
# Called when the node enters the scene tree for the first time.
func _ready(): 
	status=states.WAIT  
	pass # Replace with function body.

func shoot(): 
	player_node=get_node(player) 
	var distance=position.x-player_node.position.x;
	if(distance >= 0): 
		shoot_bullet(-180)
	elif(distance < 0): 
		shoot_bullet(360)
	return 

func shoot_bullet(dir):
	var newbullet = bullet.instance()
	newbullet.position = position
	var bulletDistanceFromCenter=50
	newbullet.angle= dir
	newbullet.position.x+=bulletDistanceFromCenter*cos(deg2rad(dir))
	newbullet.position.y+=bulletDistanceFromCenter*sin(deg2rad(dir))
	get_tree().current_scene.add_child(newbullet)
	
func stand():
	print("STAND")
	 
func _process(delta):
	timer-=Fps.MAX_FPS
	if(timer<=0 and status==states.WAIT):
		status=states.SHOOT
		timer=3
		shoot()
	elif(timer<=0 and status == states.SHOOT):
		timer=3
		status=states.WAIT
		print("WAIT") 
