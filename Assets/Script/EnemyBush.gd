extends StaticBody2D


enum states {STAND,SHOOT,WAIT}

export(NodePath) var player;
var timer=3
var player_node;
var status:int
# Called when the node enters the scene tree for the first time.
func _ready(): 
	status=states.WAIT
	pass # Replace with function body.

func shoot(): 
	player_node=get_node(player) 
	var distance=position.x-player_node.position.x;
	if(distance >= 0):
		print("SHOOT")
	elif(distance < 0):
		print("SHOOT 2") 
	return 

func stand():
	print("STAND")
	 
func _process(delta):
	timer-=delta
	if(timer<=0 and status==states.WAIT):
		status=states.SHOOT
		timer=3
		shoot()
	elif(timer<=0 and status == states.SHOOT):
		timer=3
		status=states.WAIT
		print("WAIT") 
