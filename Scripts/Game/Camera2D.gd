extends Camera2D

var cameraClampX=0
var cameraExtendsX=513
var BackgroundWidth=10307
var FpsAjustPosition =13


func _ready() -> void:
	pass 


func _physics_process(delta: float) -> void:
	if (Global.players==1):
		onePlayer()
	else:
		twoPlayers()

	#Limita extremos da fase	
	global_position.x = clamp(position.x,0+cameraExtendsX,BackgroundWidth- cameraExtendsX)

func onePlayer():
	var playerPositionX = get_parent().get_node("Player").global_position.x
	if (cameraClampX<playerPositionX-cameraExtendsX):
		cameraClampX=playerPositionX-cameraExtendsX
		global_position.x=playerPositionX
		
func twoPlayers():
	var player1PositionX = get_parent().get_node("Player").global_position.x
	var player2PositionX = get_parent().get_node("Player2").global_position.x
	var further
	if (player1PositionX>player2PositionX):
		further=player1PositionX
	else:
		further=player2PositionX
	if (further>global_position.x+cameraExtendsX*0.4):
		global_position.x+=further-(global_position.x+cameraExtendsX*0.4)
		cameraClampX=global_position.x-cameraExtendsX

