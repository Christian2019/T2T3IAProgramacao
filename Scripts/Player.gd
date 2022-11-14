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
var lives= 2
var invincible=false
var dead = false
var endGame=false
var invincibleVisibilityCD=false

var contactCollision

var animationsPlayer1= preload("res://Scenes/AnimatedSpritePlayer1.tscn")
var animationsPlayer2= preload("res://Scenes/AnimatedSpritePlayer2.tscn")

#Shoot
var blockShootTurn=false
var bullet = preload("res://Scenes/BulletPlayer.tscn")
var laser = preload("res://Scenes/Laser.tscn")
var bullet_type = 2
# 0->normal 1->machinegun 2->spread 3->flamethrower 4->laser

var is_jumping = false
var is_shooting = false

var can_shoot = true
var shoot_Animation=false

var shootCDTimerStart=0.3
var shootCDTimerItem=0.2
var shootCDTimer=shootCDTimerStart

var bullet_rotation := 0.0
var bullet_adjacent_1 := 0.0
var bullet_adjacent_2 := 0.0
var bullet_adjacent_3 := 0.0
var bullet_adjacent_4 := 0.0

var bullet_position_node
var shoot_audio_node
export (Array, AudioStream) var gun_shoot_audio

enum states{DEATH,FALLING_INTO_THE_WATER,INTO_THE_WATER,JUMP,LOWERED,RUNNING,IDLE,DROP_FALLING,DIVE}
enum sides{RIGHT,LEFT}
var state = states.JUMP
var side= sides.RIGHT
var inputsExtra=""
var startEndGame=false
var startGame=false

#Ajuste de animacao
var fix_Y_FALLING_INTO_THE_WATER=30

var gameOver=false

func _ready() -> void:
	screen_size= get_viewport_rect().size
	loadTiles()
	
	#Shoot
	bullet_position_node = $BulletPosition
	shoot_audio_node = $ShootAudio
	
	#Start

	#global_position.x=200
	#global_position.y=100
	visible=false

	
	print(name)
	if (name=="Player2"):
		global_position.x+=50
		inputsExtra="2"
		scale.x=4.24
		scale.y=2.69
		remove_child($AnimatedSprite)
		var p2= animationsPlayer2.instance()
		p2.name="AnimatedSprite"
		add_child(p2)

	
	#Test
	#global_position.x=6783
	#global_position.y=232

func loadTiles():
		Tile_Floor= get_parent().get_node("Tiles/Floor").get_children()
		Tile_Floor.append(get_parent().get_node("Bridges/Ponte/Ponte0/Area2D/CollisionShape2D"))
		Tile_Floor.append(get_parent().get_node("Bridges/Ponte/Ponte1/Area2D/CollisionShape2D"))
		Tile_Floor.append(get_parent().get_node("Bridges/Ponte/Ponte2/Area2D/CollisionShape2D"))
		Tile_Floor.append(get_parent().get_node("Bridges/Ponte/Ponte3/Area2D/CollisionShape2D"))
		Tile_Floor.append(get_parent().get_node("Bridges/Ponte2/Ponte0/Area2D/CollisionShape2D"))
		Tile_Floor.append(get_parent().get_node("Bridges/Ponte2/Ponte1/Area2D/CollisionShape2D"))
		Tile_Floor.append(get_parent().get_node("Bridges/Ponte2/Ponte2/Area2D/CollisionShape2D"))
		Tile_Floor.append(get_parent().get_node("Bridges/Ponte2/Ponte3/Area2D/CollisionShape2D"))


		Tile_Water= get_parent().get_node("Tiles/Water").get_children()
		Tile_DeathZone= get_parent().get_node("Tiles/DeathZone").get_children()

func getFootPosition():
		var center= {"x":(position.x+$FootBoxCollision.position.x*scale.x),"y":(position.y+$FootBoxCollision.position.y*scale.y)}
		var extents= {"x":$FootBoxCollision.shape.extents.x*scale.x,"y":$FootBoxCollision.shape.extents.y*scale.y}
		return {"center":center,"extents":extents}

func getBodyPosition():
		var center= {"x":(position.x+$BodyBoxCollision.get_children()[0].position.x*scale.x),"y":(position.y+$BodyBoxCollision.get_children()[0].position.y*scale.y)}
		var extents= {"x":$BodyBoxCollision.get_children()[0].shape.extents.x*scale.x,"y":$BodyBoxCollision.get_children()[0].shape.extents.y*scale.y}
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
		if !is_instance_valid(tileColissionShapes[index]):
			tileColissionShapes[index]=null
			continue
		center= {"x":tileColissionShapes[index].global_position.x,"y":tileColissionShapes[index].global_position.y}
		extents={"x":tileColissionShapes[index].shape.extents.x*tileColissionShapes[index].global_scale.x,"y":tileColissionShapes[index].shape.extents.y*tileColissionShapes[index].global_scale.y}
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
	if (!startGame):
		if Global.MainScene.startGame:
			visible=true
			startGame=true
		else:
			return
		
	if (gameOver):
		return
	if !endGame and Input.is_action_just_pressed("Imortal"):
		invincible=!invincible
		#Global.MainScene.get_node("DefenseWall").queue_free()
		

	if !endGame and Input.is_action_just_pressed("ChangeBullet"):
		bullet_type+=1
		if (bullet_type>4):
			bullet_type=0
		print(bullet_type)
	#if !endGame and Input.is_action_pressed("Escape"+inputsExtra):
		#get_tree().change_scene("res://Scenes/Prototypes/PrototypeMenu.tscn")

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
	if (state!=states.DIVE and !endGame and Input.is_action_pressed("Shoot"+inputsExtra)):
		shoot()
	if (!endGame):
		death()
		if(gameOver):
			return
	
	if (endGame):
		endGameFunc()
	
	#Mantem o personagem dentro da tela
	insideScreen()

func gameOver():
	gameOver=true
	if(Global.players==1):
		if name=="Player":
			Global.MainScene.get_node("Camera2D").get_node("HUD/Sprite").visible=true
		else:
			Global.MainScene.get_node("Camera2D").get_node("HUD/Sprite2").visible=true
		
		if(Global.MainScene.get_node_or_null("Player2")!=null):
			Global.players=2
		
		visible=false	
		timerCreator("goToGameOverScreen",2,null,true)
		
	else:
		for n in get_children():
			n.queue_free()
		global_position = Vector2(0,0)
		Global.players=1
		if name=="Player":
			Global.MainScene.get_node("Camera2D").playerName="Player2"
			Global.MainScene.get_node("Camera2D").get_node("HUD/Sprite").visible=true
		else:
			Global.MainScene.get_node("Camera2D").get_node("HUD/Sprite2").visible=true
			
		
func goToGameOverScreen():
	get_tree().change_scene("res://Scenes/RootScenes/GameOver.tscn")
	
func endGameFunc():
	if (!startEndGame):
		$AnimatedSprite.animation="Idle"
		if ($FootBoxCollision.global_position.y>621 or global_position.x<9198.001):
			global_position=Vector2(9198.001,369)
		return
	invincible=false
	$AnimatedSprite.flip_h=false
	if (global_position.x>10022 and global_position.x<10073 and onTheTile):
		gravity-=jumpForce
		$AnimatedSprite.animation="Jump"
		speed=100
	elif onTheTile:
		$AnimatedSprite.animation="Running"
		speed=200
	if (global_position.x==10289.5):
		if (visible):
			timerCreator("goToFinalScene",2,null,true)
		visible=false

	position.x += speed*Global.Inverse_MAX_FPS
func goToFinalScene():
	get_tree().change_scene("res://Scenes/RootScenes/StartScreen.tscn")
	
func invincibleVisibilityChange():
	if (!invincibleVisibilityCD):
		$AnimatedSprite.visible=!$AnimatedSprite.visible
		invincibleVisibilityCD=true
		timerCreator("changeVisibilityCD",0.1,null,true)
		return

func changeVisibilityCD():
	invincibleVisibilityCD=false

func lowered():
	
	if (state==states.IDLE):
		if !endGame and Input.is_action_pressed("Arrow_DOWN"+inputsExtra):
			state=states.LOWERED
	if (state==states.LOWERED):
		if !!endGame and Input.is_action_pressed("Arrow_DOWN"+inputsExtra) or gravity>=1:
			state=states.IDLE

func animationController():
	if (invincible):
		invincibleVisibilityChange()
	else:
		$AnimatedSprite.visible=true
	if (endGame):
		return
	contactCollision=$BodyBoxCollision.get_children()[0]
	if (!blockShootTurn):
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
		contactCollision=$HeadOnTheWaterCollision.get_children()[0]
		if !endGame and Input.is_action_pressed("Arrow_UP"+inputsExtra) and (!endGame and Input.is_action_pressed("Arrow_RIGHT"+inputsExtra) or !endGame and Input.is_action_pressed("Arrow_LEFT"+inputsExtra)):
			$AnimatedSprite.animation="Aiming_on_water_Diagonal"
		elif !endGame and Input.is_action_pressed("Arrow_UP"+inputsExtra) :
			$AnimatedSprite.animation="Aiming_on_water_Up"
		elif shoot_Animation:
			$AnimatedSprite.animation="Aiming_on_water_Front"
		else:
			$AnimatedSprite.animation="Into_The_Water"

	elif (state==states.JUMP):
		contactCollision=$JumpBoxCollision.get_children()[0]
		$AnimatedSprite.animation="Jump"
		
	elif (state==states.LOWERED):
		contactCollision=$LoweredBoxCollision.get_children()[0]
		if !endGame and Input.is_action_pressed("Shoot"+inputsExtra):
			$AnimatedSprite.animation="Lowered_shoot"
		else:
			$AnimatedSprite.animation="Lowered"
			
	elif (state==states.RUNNING):
		if !endGame and Input.is_action_pressed("Arrow_DOWN"+inputsExtra) :
			$AnimatedSprite.animation="Running_aiming_down"
		elif !endGame and Input.is_action_pressed("Arrow_UP"+inputsExtra):
			$AnimatedSprite.animation="Running_aiming_up"
		elif shoot_Animation:
			$AnimatedSprite.animation="Running_aiming_front"
		else:
			$AnimatedSprite.animation="Running"

	elif (state==states.IDLE):
		if !endGame and Input.is_action_pressed("Arrow_UP"+inputsExtra) :
			if !endGame and Input.is_action_pressed("Shoot"+inputsExtra):
				$AnimatedSprite.animation="Look_up_shoot"
			else:
				$AnimatedSprite.animation="Look_up"
		else:
			if !endGame and Input.is_action_pressed("Shoot"+inputsExtra) and can_shoot:
				$AnimatedSprite.animation="Idle_shoot"
			else:
				$AnimatedSprite.animation="Idle"
			
	elif (state==states.DROP_FALLING):
		$AnimatedSprite.animation="Drop_Falling"
	elif (state==states.DIVE):
		$AnimatedSprite.animation="Dive"
		contactCollision=null

func death():
	
	#Morte por queda
	if (tileCollision(getBodyPosition(),Tile_DeathZone)):
		dead=true
		
	#Morte por colisao com bala
	#Morte por colisao com inimigo
	
	if (dead):
		dead=false
		if invincible and !tileCollision(getBodyPosition(),Tile_DeathZone):
			return
		gravity=0
		shootCDTimer=shootCDTimerStart
		bullet_type=0
		if (state==states.INTO_THE_WATER):
			$AnimatedSprite.global_position.y-=fix_Y_FALLING_INTO_THE_WATER
			inWater=false
		if (lives>0):
			lives-=1
		else:
			gameOver()
			return
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
					if !is_instance_valid(Tile_Floor[index]):
						Tile_Floor[index]=null
						continue
					var tile = Tile_Floor[index]
					if (tile.global_position.x-tile.shape.extents.x*tile.global_scale.x<respawnPositionX and
					tile.global_position.x+tile.shape.extents.x*tile.global_scale.x>respawnPositionX ):
						canDrop=true
						#respawnPositionX+=$BodyBoxCollision.get_children()[0].shape.extents.x*$BodyBoxCollision.get_children()[0].scale.x+20
						break
				respawnPositionX+=1
		timerCreator("respawn",1,[respawnPositionX,respawnPositionY],true)

	
func respawn(respawnPositionX,respawnPositionY):
	wait=false
	global_position.x=respawnPositionX
	global_position.y=respawnPositionY
	state=states.JUMP
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
		if !endGame and Input.is_action_pressed("Arrow_DOWN"+inputsExtra):
			state=states.DIVE
	if (state ==states.DIVE):
		if !!endGame and Input.is_action_pressed("Arrow_DOWN"+inputsExtra):
			state=states.INTO_THE_WATER
		return
	
	if !endGame and Input.is_action_pressed("Arrow_RIGHT"+inputsExtra):
		if (inTwoPlayersLimiteSpace()):
			var maxX=10060
			if(global_position.x<maxX):
				position.x += speed*Global.Inverse_MAX_FPS
		side=sides.RIGHT
		if (state==states.IDLE):
			state=states.RUNNING
			
	elif !endGame and Input.is_action_pressed("Arrow_LEFT"+inputsExtra):
		position.x -= speed*Global.Inverse_MAX_FPS
		side=sides.LEFT
		if (state==states.IDLE):
			state=states.RUNNING
	
	elif (state==states.RUNNING):
		state=states.IDLE
			
	#Subir na plataforma se estiver na agua
	climb()
		

func inTwoPlayersLimiteSpace():
	if Global.players==1:
		return true
	var camera60percentwidth=get_parent().get_node("Camera2D").cameraExtendsX*1.2
	if (name=="Player"):
		if (global_position.x>get_parent().get_node("Player2").global_position.x):
			if ((global_position.x-get_parent().get_node("Player2").global_position.x)>camera60percentwidth):
				return false
	else:
		if (global_position.x>get_parent().get_node("Player").global_position.x):
			if ((global_position.x-get_parent().get_node("Player").global_position.x)>camera60percentwidth):
				return false
	return true
	
func jump():
	if (onTheTile and !tileCollision(getFootPosition(),Tile_Water)):
		#Drop
		if !endGame and Input.is_action_pressed("Arrow_DOWN"+inputsExtra):
			if !endGame and Input.is_action_pressed("Jump"+inputsExtra):
				state=states.DROP_FALLING
				var footPosition= getFootPosition()
				while(tileCollision(footPosition,Tile_Floor)):
					footPosition.center.y+=1
				if (!tileCollision(footPosition,Tile_Water)):
					position.y= footPosition.center.y+1-$FootBoxCollision.position.y*scale.y
					
		else:
			#Jump
			if !endGame and Input.is_action_pressed("Jump"+inputsExtra):
				position.y-=1
				gravity-=jumpForce
				state=states.JUMP

func insideScreen():
	var leftWidth= $BodyBoxCollision.get_children()[0].shape.extents.x*scale.x
	var rightWidth =$BodyBoxCollision.get_children()[0].shape.extents.x*scale.x
	var upHeight= $BodyBoxCollision.get_children()[0].shape.extents.y*scale.y
	var downHeight = $BodyBoxCollision.get_children()[0].shape.extents.y*scale.y
	
	
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
		timer.one_shot=true
		timer.autostart=true
		call_deferred("add_child",timer)
		
	
		var timer2 = Timer.new()
		timer2.connect("timeout",self,"timerCreator",["",0,[timer,timer2],false])
		timer2.set_wait_time(time+1)
		timer2.one_shot=true
		timer2.autostart=true
		call_deferred("add_child",timer2)
	else:
		remove_child(parameters[0])
		remove_child(parameters[1])

#SHOOT
	
func shootCD():
	can_shoot = true
	
func bst():
	blockShootTurn=false
	
func shoot():
	if (!blockShootTurn):
		blockShootTurn=true
		timerCreator("bst",0.1,null,true)
	shoot_Animation=true
	$ShootAnimation.start()
	shooting_directions()
	
	if (inputCondition() and can_shoot):
		is_shooting = true
		can_shoot=false
		var timeCD = shootCDTimer
		if (bullet_type == 4):
			laser_shoot()
		else:
			bullet_shoot(bullet_rotation)
			
		if (bullet_type == 3):
			timerCreator("bullet_shoot",0.2,[bullet_rotation],true)
		elif (bullet_type == 2):
			spread_bullet()
		elif (bullet_type == 1):
			timeCD-=0.1

		timerCreator("shootCD",timeCD,null,true)
		
	else:
		is_shooting = false

func inputCondition():
	if (shootCDTimer==shootCDTimerItem or bullet_type == 1):
		if !endGame and Input.is_action_pressed("Shoot"+inputsExtra):
			return true
	else:
		if !endGame and Input.is_action_just_pressed("Shoot"+inputsExtra):
			return true
	return false

func bullet_shoot(dir):
	var bullet_instance = bullet.instance()
	bullet_instance.player=name
	get_parent().add_child(bullet_instance)
	bullet_instance.global_position = bullet_position_node.global_position
	bullet_instance.set_scale(Vector2(2,2))
	bullet_instance.set_bullet(bullet_position_node.global_position, 
		bullet_type, dir, !$AnimatedSprite.flip_h)
	shoot_audio()

func shoot_audio():
	if shoot_audio_node.is_playing():
		shoot_audio_node.stop()
	
	var audio
	match bullet_type:
		0:
			audio = gun_shoot_audio[bullet_type]
		1:
			audio = gun_shoot_audio[bullet_type]
		2:
			audio = gun_shoot_audio[bullet_type]
		3:
			audio = gun_shoot_audio[bullet_type]
		4:
			audio = gun_shoot_audio[bullet_type]
	
	shoot_audio_node.set_stream(audio)
	shoot_audio_node.play()

func spread_bullet():
	bullet_shoot(bullet_adjacent_1)
	bullet_shoot(bullet_adjacent_2)
	bullet_shoot(bullet_adjacent_3)
	bullet_shoot(bullet_adjacent_4)

func laser_shoot():
	var laser_instance = laser.instance()
	laser_instance.global_position = bullet_position_node.global_position
	laser_instance.set_scale(Vector2(2,2))
	laser_instance.set_rotation(bullet_rotation)
	get_parent().add_child(laser_instance)

func bulletInfo(bulletPosition,bulletRotation):
		bullet_position_node.position = bulletPosition
		bullet_rotation = bulletRotation
		if ($AnimatedSprite.flip_h):
			bullet_position_node.position=Vector2(-bulletPosition.x, bulletPosition.y)
			bullet_rotation=180-bulletRotation
		bullet_adjacent_1 = bullet_rotation-10
		bullet_adjacent_2 = bullet_rotation-5
		bullet_adjacent_3 = bullet_rotation+5
		bullet_adjacent_4 = bullet_rotation+10
		
func shooting_directions():
	
	if ($AnimatedSprite.animation=="Look_up_shoot"):
		bulletInfo(Vector2(4.481, -28.248),-90)
	elif ($AnimatedSprite.animation=="Running_aiming_up"):
			bulletInfo(Vector2(10.613, -15.611),-30)
	elif ($AnimatedSprite.animation=="Running_aiming_front"):
		bulletInfo(Vector2(16.509, -4.088),0)
	elif ($AnimatedSprite.animation=="Running_aiming_down"):
		bulletInfo(Vector2(13, 6),27)
	elif ($AnimatedSprite.animation=="Lowered_shoot"):
		bulletInfo(Vector2(17, 10),0)
	elif ($AnimatedSprite.animation=="Aiming_on_water_Front" or $AnimatedSprite.animation=="Into_The_Water" ):
		bulletInfo(Vector2(17, 6),0)
	elif ($AnimatedSprite.animation=="Aiming_on_water_Up"):
		bulletInfo(Vector2(5, -18),-90)
	elif ($AnimatedSprite.animation=="Aiming_on_water_Diagonal"):
		bulletInfo(Vector2(11, -7),-32)
	elif ($AnimatedSprite.animation=="Idle" or $AnimatedSprite.animation=="Idle_shoot" ):
		bulletInfo(Vector2(17, -4.832),0)
	elif ($AnimatedSprite.animation=="Jump"):
		if !endGame and Input.is_action_pressed("Arrow_UP"+inputsExtra) and (!endGame and Input.is_action_pressed("Arrow_RIGHT"+inputsExtra) or !endGame and Input.is_action_pressed("Arrow_LEFT"+inputsExtra)):
			bulletInfo(Vector2(10.613, -15.611),-30)
		elif !endGame and Input.is_action_pressed("Arrow_DOWN"+inputsExtra) and (!endGame and Input.is_action_pressed("Arrow_RIGHT"+inputsExtra) or !endGame and Input.is_action_pressed("Arrow_LEFT"+inputsExtra)):
			bulletInfo(Vector2(13, 6),27)
		elif !endGame and Input.is_action_pressed("Arrow_UP"+inputsExtra):
			bulletInfo(Vector2(0.236, -14.124),-90)
		elif !endGame and Input.is_action_pressed("Arrow_DOWN"+inputsExtra):
			bulletInfo(Vector2(0.236, 4.832),90)
		else:
			bulletInfo(Vector2(9.198, -6.69),0)
	

func _on_Timer_timeout() -> void:
	
	pass



func _on_ShootAnimation_timeout() -> void:
	shoot_Animation=false
