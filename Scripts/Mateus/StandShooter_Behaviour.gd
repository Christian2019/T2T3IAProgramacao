extends KinematicBody2D


enum states{SHOOT,STOP}
export(NodePath) var player;
var state=states.STOP

var angulo=-180
var player_position
var tiros=3
var segundos=3
var positions:Array
export var DetectionDistance = 450
var bullet = preload("res://Scenes/Mateus/Bullet.tscn")
var shoot_now=false;
var player_;
func _ready() -> void:   
	$ChangeState.start() 
	pass # Replace with function body.
	 
 
func _physics_process(delta: float) -> void:    
	player_position=get_node(player).position      
	player_=get_node(player)
	drawLine()
 
func drawLine():
	var linha = get_parent().get_node("Line2D")
	if (position.distance_to(player_.position)<2):
		linha.default_color= Color.red
	else:
		linha.default_color= Color("6680ff")
	linha.clear_points()
	linha.add_point(Vector2(position.x,position.y))
	linha.add_point(Vector2(player_.position.x,player_.position.y))
		
func _onhang_CeState_timeout() -> void: 
	if(state==states.SHOOT):   
			state=states.STOP 
			$ChangeState.start() 
	else:   
			state=states.SHOOT       
			shoot_bullet()
			timerCreator("shoot_bullet",1) 
			timerCreator("shoot_bullet",2) 
		 
func shoot_bullet():  
	var newbullet = bullet.instance()
	newbullet.position = position
	var bulletDistanceFromCenter=50 
	newbullet.angle= rad2deg((player_position-position).angle())
	newbullet.position.x+=bulletDistanceFromCenter*cos(deg2rad(rad2deg(player_position.angle())))
	newbullet.position.y+=bulletDistanceFromCenter*sin(deg2rad(rad2deg(player_position.angle())))
	get_tree().current_scene.add_child(newbullet)
	
func timerCreator(functionName,time):
	var timer = Timer.new()
	timer.connect("timeout",self,functionName)
	timer.set_wait_time(time)
	add_child(timer)
	timer.one_shot=true
	timer.start()
	
	var timer2 = Timer.new()
	timer2.connect("timeout",self,"timerDestroyer",[timer,timer2])
	timer2.set_wait_time(time+1)
	add_child(timer2)
	timer2.one_shot=true
	timer2.start()  
	
func timerDestroyer(timer,timer2):
	remove_child(timer)
	remove_child(timer2) 
 
