extends Area2D


enum states {STAND,SHOOT,WAIT}

export(NodePath) var player;
var timer=3
var player_node;
var status:int 
var bullet = preload("res://Scenes/Mateus/Bullet.tscn")
# Called when the node enters the scene tree for the first time.

signal killPlayer()
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
		$StandingUp.visible=true
	elif(timer<=0 and status == states.SHOOT):
		timer=3
		status=states.WAIT
		print("WAIT") 
		$StandingUp.visible=false

func die():  
	$SpriteSoldadoArbusto.play("Explode")
	yield(get_tree().create_timer(0.35),"timeout");  
	self.queue_free()
	
func _on_InimigoArbusto_area_entered(area):
	if(area.is_in_group("Player")):
		emit_signal("killPlayer")
	pass # Replace with function body.

#Mudar para quando a bala entra no inimigo
func _on_Button_pressed():
	die()
	pass # Replace with function body.
