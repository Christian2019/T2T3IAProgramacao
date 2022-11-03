extends Camera2D

var cameraClampX=0
var cameraExtendsX=513
var BackgroundWidth=10307
var FpsAjustPosition =13

func _ready() -> void:
	pass 


func _physics_process(delta: float) -> void:
	var playerPositionX = get_parent().get_node("Player").global_position.x
	if (cameraClampX<playerPositionX-cameraExtendsX):
		cameraClampX=playerPositionX-cameraExtendsX
		global_position.x=playerPositionX
		
	if (global_position.x>-cameraExtendsX+FpsAjustPosition):
		Fps.global_position.x=global_position.x-cameraExtendsX+FpsAjustPosition
	#Limita extremos da fase	
	global_position.x = clamp(position.x,0+cameraExtendsX,BackgroundWidth- cameraExtendsX)
