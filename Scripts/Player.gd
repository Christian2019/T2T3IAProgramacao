extends KinematicBody2D
var speed = 265
var screen_size
var gravity=0
var gravityForce=13
var jumpForce=8
var onTheTile=false
var Tile_Floor
var Tile_Water
var Tile_DeathZone
var wait=false
var inWater=false
var lives
var invincible=false

enum states{DEATH,FALLING_INTO_THE_WATER,INTO_THE_WATER,JUMP,LOWERED,RUNNING,IDLE,DROP_FALLING,DIVE}
enum sides{RIGHT,LEFT}
var state = states.IDLE
var side= sides.RIGHT
var inputsExtra=""

#Ajuste de animacao
var fix_Y_FALLING_INTO_THE_WATER=30



func _ready() -> void:
	screen_size= get_viewport_rect().size
	loadTiles()
	
	#Start
	lives = 3
	global_position.x=255
	global_position.y=232
	
	print(name)
	if (name=="Player2"):
		global_position.x+=50
		inputsExtra="2"
		scale.x=4.24
		scale.y=2.69
	
	#Test
	#global_position.x=6783
	#global_position.y=232
	
func loadTiles():
		Tile_Floor= get_parent().get_node("Tiles/Floor").get_children()
		Tile_Water= get_parent().get_node("Tiles/Water").get_children()
		Tile_DeathZone= get_parent().get_node("Tiles/DeathZone").get_children()

func getFootPosition():
		var center= {"x":(position.x+$FootBoxCollision.position.x*scale.x),"y":(position.y+$FootBoxCollision.position.y*scale.y)}
		var extents= {"x":$FootBoxCollision.shape.extents.x*scale.x,"y":$FootBoxCollision.shape.extents.y*scale.y}
		return {"center":center,"extents":extents}

func getBodyPosition():
		var center= {"x":(position.x+$BodyBoxCollision.position.x*scale.x),"y":(position.y+$BodyBoxCollision.position.y*scale.y)}
		var extents= {"x":$BodyBoxCollision.shape.extents.x*scale.x,"y":$BodyBoxCollision.shape.extents.y*scale.y}
		return {"center":center,"extents":extents}
	
func gravityF():

	if (gravity>=0):
		var footPosition= getFootPosition()
		for index in gravity:
			footPosition.center.y+=1
			if (tileCollision(footPosition,Tile_Floor)||tileCollision(footPosition,Tile_Water)):
				if (!inWater and tileCollision(footPosition,Tile_Water)):
					inWater=true
					wait=true
					timerCreator("removeWait",0.7,null,true)
					state=states.FALLING_INTO_THE_WATER
					$AnimatedSprite.frame=0
					$AnimatedSprite.global_position.y+=fix_Y_FALLING_INTO_THE_WATER
				elif(!tileCollision(footPosition,Tile_Water)):
					state=states.IDLE
				gravity =0
				fit(footPosition)
				onTheTile=true
				return
	onTheTile=false
	position.y+=gravity
	gravity+=gravityForce*Global.Inverse_MAX_FPS

func tileCollision(objectCollisionShape,tileColissionShapes):
	var center
	var extents
	for index in range(tileColissionShapes.size()):
		center= {"x":tileColissionShapes[index].position.x,"y":tileColissionShapes[index].position.y}
		extents={"x":tileColissionShapes[index].shape.extents.x,"y":tileColissionShapes[index].shape.extents.y}
		if squareCollision(objectCollisionShape.center,objectCollisionShape.extents,center,extents):
			return true
	return false

func squareCollision(centerA,extentsA,centerB,extentsB):
	if (insideInterval((centerA.x-extentsA.x),(centerB.x-extentsB.x),(centerB.x+extentsB.x)) or 
	insideInterval((centerA.x+extentsA.x) ,(centerB.x-extentsB.x),(centerB.x+extentsB.x)) or
	insideInterval((centerB.x-extentsB.x), (centerA.x-extentsA.x),(centerA.x+extentsA.x)) or
	insideInterval((centerB.x+extentsB.x) ,(centerA.x-extentsA.x),(centerA.x+extentsA.x)) 
	):
		if (insideInterval((centerA.y-extentsA.y), (centerB.y-extentsB.y),(centerB.y+extentsB.y)) or 
		insideInterval((centerA.y+extentsA.y), (centerB.y-extentsB.y),(centerB.y+extentsB.y)) or
		insideInterval((centerB.y-extentsB.y), (centerA.y-extentsA.y),(centerA.y+extentsA.y)) or
		insideInterval((centerB.y+extentsB.y), (centerA.y-extentsA.y),(centerA.y+extentsA.y)) 
		):
			return true
	return false

func insideInterval(a,b,c):
	if a>=b and a<=c:
		return true
	else:
		return false

func fit(footPosition):
	footPosition.center.y-=1
	while(tileCollision(footPosition,Tile_Floor)||tileCollision(footPosition,Tile_Water)):
		footPosition.center.y-=1
	position.y= footPosition.center.y+1-$FootBoxCollision.position.y*scale.y

func _process(delta: float) -> void:
	
	if Input.is_action_pressed("Escape"+inputsExtra):
		get_tree().change_scene("res://Scenes/Prototypes/PrototypeMenu.tscn")
	
	animationController()
	
	if (wait):
		return
	
	#Funcao de gravidade	
	gravityF()
		
	#Pulo
	jump()
	
	#Movimento Lateral
	horizontal_Move()
	
	lowered()
	
	death()
	
	
	#Mantem o personagem dentro da tela
	insideScreen()

func lowered():
	if (invincible):
		$AnimatedSprite.visible=!$AnimatedSprite.visible
	else:
		$AnimatedSprite.visible=true
	if (state==states.IDLE):
		if Input.is_action_pressed("Arrow_DOWN"+inputsExtra):
			state=states.LOWERED
	if (state==states.LOWERED):
		if !Input.is_action_pressed("Arrow_DOWN"+inputsExtra) or gravity>=1:
			state=states.IDLE

func animationController():
	if (side==sides.LEFT):
		$AnimatedSprite.flip_h=true
	else:
		$AnimatedSprite.flip_h=false
		
	if (state==states.DEATH):
		$AnimatedSprite.animation="Death"
		if ($AnimatedSprite.frame==5):
			$AnimatedSprite.playing=false
	elif (state==states.FALLING_INTO_THE_WATER):
		$AnimatedSprite.animation="Falling_Into_The_Water"
		if ($AnimatedSprite.frame==3):
			state=states.INTO_THE_WATER
			
	elif (state==states.INTO_THE_WATER):
		$AnimatedSprite.animation="Into_The_Water"
	elif (state==states.JUMP):
		$AnimatedSprite.animation="Jump"
	elif (state==states.LOWERED):
		$AnimatedSprite.animation="Lowered"
	elif (state==states.RUNNING):
		$AnimatedSprite.animation="Running"
	elif (state==states.IDLE):
		$AnimatedSprite.animation="Idle"
	elif (state==states.DROP_FALLING):
		$AnimatedSprite.animation="Drop_Falling"
	elif (state==states.DIVE):
		$AnimatedSprite.animation="Dive"

func death():
	var dead = false
	#Morte por queda
	if (tileCollision(getBodyPosition(),Tile_DeathZone)):
		dead=true
		
	#Morte por colisao com bala
	#Morte por colisao com inimigo
	
	if (dead):
		if (lives>0):
			lives-=1
		state=states.DEATH
		$AnimatedSprite.frame=0
		wait=true
		get_parent().get_node("Sounds/DeathSound").play()
		#Revive num ponto safe
		var respawnPositionX = get_parent().get_node("Camera2D").global_position.x-360
		var respawnPositionY = 20
		
		#DeathZone
		if (respawnPositionX>5725):
			var canDrop=false
			while(!canDrop):
				for index in range(0,Tile_Floor.size(),1):
					var tile = Tile_Floor[index]
					if (tile.global_position.x-tile.shape.extents.x*tile.scale.x<respawnPositionX and
					tile.global_position.x+tile.shape.extents.x*tile.scale.x>respawnPositionX ):
						canDrop=true
						respawnPositionX+=$BodyBoxCollision.shape.extents.x*$BodyBoxCollision.scale.x+20
						break
				respawnPositionX+=1
		timerCreator("respawn",1,[respawnPositionX,respawnPositionY],true)

	
func respawn(respawnPositionX,respawnPositionY):
	wait=false
	global_position.x=respawnPositionX
	global_position.y=respawnPositionY
	state=states.IDLE
	$AnimatedSprite.playing=true
	invincible=true
	timerCreator("removeInvincible",2,null,true)
	
func removeInvincible():
	invincible=false
	

func removeClimbCD(footPosition):
	removeWait()
	fit(footPosition)
	inWater=false
	state=states.IDLE
	
func removeWait():
	wait=false	
	

func climb():
	var footPosition= getFootPosition()
	var bodyPosition = getBodyPosition()
	if (tileCollision(footPosition,Tile_Water)and
		tileCollision(bodyPosition,Tile_Floor)
	): 
		wait=true
		state=states.DROP_FALLING
		$AnimatedSprite.global_position.y-=fix_Y_FALLING_INTO_THE_WATER
		timerCreator("removeClimbCD",0.1,[footPosition],true)

func horizontal_Move():
	#Dive
	if (state == states.INTO_THE_WATER):
		if Input.is_action_pressed("Arrow_DOWN"+inputsExtra):
			state=states.DIVE
	if (state ==states.DIVE):
		if !Input.is_action_pressed("Arrow_DOWN"+inputsExtra):
			state=states.INTO_THE_WATER
		return
	
	if Input.is_action_pressed("Arrow_RIGHT"+inputsExtra):
		position.x += speed*Global.Inverse_MAX_FPS
		side=sides.RIGHT
		if (state==states.IDLE):
			state=states.RUNNING
			
	elif Input.is_action_pressed("Arrow_LEFT"+inputsExtra):
		position.x -= speed*Global.Inverse_MAX_FPS
		side=sides.LEFT
		if (state==states.IDLE):
			state=states.RUNNING
	
	elif (state==states.RUNNING):
		state=states.IDLE
			
	#Subir na plataforma se estiver na agua
	climb()
		

func jump():
	if (onTheTile and !tileCollision(getFootPosition(),Tile_Water)):
		#Drop
		if Input.is_action_pressed("Arrow_DOWN"+inputsExtra):
			if Input.is_action_pressed("Jump"+inputsExtra):
				state=states.DROP_FALLING
				var footPosition= getFootPosition()
				while(tileCollision(footPosition,Tile_Floor)):
					footPosition.center.y+=1
				if (!tileCollision(footPosition,Tile_Water)):
					position.y= footPosition.center.y+1-$FootBoxCollision.position.y*scale.y
					
		else:
			#Jump
			if Input.is_action_pressed("Jump"+inputsExtra):
				position.y-=1
				gravity-=jumpForce
				state=states.JUMP

func insideScreen():
	var leftWidth= $BodyBoxCollision.shape.extents.x*scale.x
	var rightWidth =$BodyBoxCollision.shape.extents.x*scale.x
	var upHeight= $BodyBoxCollision.shape.extents.y*scale.y
	var downHeight = $BodyBoxCollision.shape.extents.y*scale.y
	
	position.x = clamp(position.x,get_parent().get_node("Camera2D").cameraClampX+leftWidth,10307-rightWidth)
	position.y = clamp(position.y,0+upHeight,665-downHeight)

#Usar create sempre true, e parameters da functionName [v1,v2] ou null
func timerCreator(functionName,time,parameters,create):
	if (create):
		var timer = Timer.new()
		if (parameters==null):
			timer.connect("timeout",self,functionName)
		else:
			timer.connect("timeout",self,functionName,parameters)
		timer.set_wait_time(time)
		add_child(timer)
		timer.one_shot=true
		timer.start()
	
		var timer2 = Timer.new()
		timer2.connect("timeout",self,"timerCreator",["",0,[timer,timer2],false])
		timer2.set_wait_time(time+1)
		add_child(timer2)
		timer2.one_shot=true
		timer2.start()
	else:
		remove_child(parameters[0])
		remove_child(parameters[1])

func _on_Timer_timeout() -> void:
	
	pass

