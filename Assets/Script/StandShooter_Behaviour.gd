extends StaticBody2D


enum states{SHOOT,STOP}
export(NodePath) var player;
var state
var player_position
func _ready() -> void:  
	 
	pass # Replace with function body.
	
	
func choose_state():   
	player_position=get_node(player).position
	var distancia_horizontal=player_position.normalized().x-position.normalized().x
	var distancia_vertical=player_position.normalized().y-position.normalized().y 
	if(distancia_horizontal>=0 and distancia_horizontal < 0.6
		or
		distancia_vertical>=0 and distancia_vertical < 0.6):
		state=states.SHOOT
	else:
		state=states.STOP

func _physics_process(delta: float) -> void:
	choose_state()
	if(states.SHOOT==state):
		print("BRRRRR at", player_position)
	else:
		print(player_position)
