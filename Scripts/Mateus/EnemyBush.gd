extends Area2D


enum states {STAND,SHOOT,WAIT}

export(NodePath) var player;
var timer=3
var player_node;
var status:int 
var bullet = preload("res://Scenes/Mateus/Bullet.tscn")

var is_up=false
# Called when the node enters the scene tree for the first time.

signal killPlayer()
func _ready(): 
	status=states.WAIT  
	$StandingUp.disabled=true
	pass # Replace with function body.

func shoot(): 
	player_node=get_node(player) 
	var distance=position.x-player_node.position.x;
	if(distance >= 0):  
		shoot_bullet(-180)
	elif(distance < 0):  
		shoot_bullet(0)
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
	if(is_up==false):
		$SpriteSoldadoArbusto.play("Levanta")
		yield(get_tree().create_timer(0.35),"timeout"); 
		$SpriteSoldadoArbusto.stop()
		$SpriteSoldadoArbusto.animation="Levanta"
		$SpriteSoldadoArbusto.frame=2 
		is_up=true

func lower(): 
		$SpriteSoldadoArbusto.play("Abaixa")
		yield(get_tree().create_timer(0.35),"timeout"); 
		$SpriteSoldadoArbusto.play("default") 
		$StandingUp.disabled=true   
		is_up=false 
	
func _process(delta):
	timer-=Fps.MAX_FPS
	player_node=get_node(player) 
	var distance=position.x-player_node.position.x;
	
	if(distance >= 0):  
		$SpriteSoldadoArbusto.flip_h=true
	elif(distance < 0):   
		$SpriteSoldadoArbusto.flip_h=false
		
	 
	if(timer<=0 and status==states.WAIT):  
		stand()    
		$StandingUp.disabled=false
		yield(get_tree().create_timer(0.5),"timeout");  
		shoot()     
		status=states.SHOOT 
		timer=3 
	elif(timer<=0 and status == states.SHOOT):
		
		if(is_up):
			lower()
		$StandingUp.disabled=true
		timer=3 
		status=states.WAIT   
		

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
