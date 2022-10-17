extends KinematicBody2D


enum states{SHOOT,STOP}
export(NodePath) var player;
var state=states.STOP
var player_position
var tiros=3
var segundos=3
var positions:Array

var shoot_now=false;
func _ready() -> void:   
	$ChangeState.start() 
	pass # Replace with function body.
	 
 
func _physics_process(delta: float) -> void:    
	player_position=get_node(player).position     


	
func _on_ChangeState_timeout() -> void:
	if(state==states.SHOOT):  
			print(" STOP")
			state=states.STOP 
			$ChangeState.start() 
	else:   
			state=states.SHOOT
			print(player_position.normalized())   
			$ShootBullet.start()
	 
	
func _on_ShootBullet_timeout() -> void:
	if(state==states.SHOOT): 
		print(player_position.normalized())
	pass # Replace with function body.
