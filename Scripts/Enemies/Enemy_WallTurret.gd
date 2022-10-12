extends Node2D

export var DetectionDistance = 200
var player
var state = "Idle"
var state_in_process=false



func _ready() -> void:
	pass 
	
func _physics_process(delta: float) -> void:
	updatePlayer()
	drawLine()
	chageState()


func drawLine():
	get_parent().get_node("Line2D").clear_points()
	get_parent().get_node("Line2D").add_point(Vector2(position.x,position.y))
	get_parent().get_node("Line2D").add_point(Vector2(player.position.x,player.position.y))

			
func updatePlayer():
	player = get_parent().get_node("Player")
		

func chageState():
	if (state_in_process):
		return
		
	match state:
		"Idle":
			f_idle()
		"Transition":
			print("a")
		"Active":
			print("b")
		_:
			print("default")
		
	
func f_idle():
	
	if (position.distance_to(player.position)<DetectionDistance):
		get_parent().get_node("Line2D").default_color= Color.red
	else:
		get_parent().get_node("Line2D").default_color= Color("6680ff")


	
	

func _on_Teste_timeout() -> void:
	pass



	
		
