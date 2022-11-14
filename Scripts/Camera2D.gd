extends Camera2D

var cameraClampX=0
var cameraExtendsX=513
var BackgroundWidth=10307
var FpsAjustPosition =13
var maxX=9800
var onePlayerDead=false
var playerName="Player"
var openingSpeedStart=20
var opening=true

func _ready() -> void:
	$HUD.visible=false
	$ColorRect.visible=true
	$HUD/Sprite.visible=false
	$HUD/Sprite2.visible=false

func _physics_process(delta: float) -> void:
	if opening:
		if ($ColorRect.rect_position.x<513):
			$ColorRect.rect_position.x+=openingSpeedStart
			return
		else:
			$ColorRect.queue_free()
			Global.MainScene.startGame=true
			$HUD.visible=true
			opening=false
			
	if (Global.players==1):
		onePlayer()
	else:
		twoPlayers()
	cameraClampX=global_position.x-cameraExtendsX
	#Limita extremos da fase	
	global_position.x = clamp(position.x,0+cameraExtendsX,BackgroundWidth- cameraExtendsX)

func onePlayer():
	var playerPositionX = get_parent().get_node(playerName).global_position.x
	if (cameraClampX<playerPositionX-cameraExtendsX):
		cameraClampX=playerPositionX-cameraExtendsX
		if (playerPositionX<maxX):
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
		if (global_position.x+further-(global_position.x+cameraExtendsX*0.4)<maxX):
			global_position.x+=further-(global_position.x+cameraExtendsX*0.4)
		

