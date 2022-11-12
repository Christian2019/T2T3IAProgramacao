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
var dead = false

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
var state = states.IDLE
var side= sides.RIGHT
var inputsExtra=""

#Ajuste de animacao
var fix_Y_FALLING_INTO_THE_WATER=30

func _ready() -> void:
	screen_size= get_viewport_rect().size
	loadTiles()
	
	#Shoot
	bullet_position_node = $BulletPosition
	shoot_audio_node = $ShootAudio
	
	#Start
	lives = 3
	#global_position.x=255
	#global_position.y=232
	
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

	if Input.is_action_just_pressed("ChangeBullet"):
		bullet_type+=1
		if (bullet_type>4):
			bullet_type=0
		print(bullet_type)
	#if Input.is_action_pressed("Escape"+inputsExtra):
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
	
	if (state!=states.DIVE and Input.is_action_pressed("Shoot"+inputsExtra)):
		shoot()
	
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
	contactCollision=$BodyBoxCollision.get_children()[0]
	if (side==sides.LEFT):
		if ($AnimatedSprite.flip_h==false):
			blockShootTurn=true
			timerCreator("bst",0.1,null,true)
		$AnimatedSprite.flip_h=true
	else:
		if ($AnimatedSprite.flip_h==true):
			blockShootTurn=true
			timerCreator("bst",0.1,null,true)
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
		if Input.is_action_pressed("Arrow_UP"+inputsExtra) and (Input.is_action_pressed("Arrow_RIGHT"+inputsExtra) or Input.is_action_pressed("Arrow_LEFT"+inputsExtra)):
			$AnimatedSprite.animation="Aiming_on_water_Diagonal"
		elif Input.is_action_pressed("Arrow_UP"+inputsExtra) :
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
		if Input.is_action_just_pressed("Shoot"+inputsExtra):
			$AnimatedSprite.animation="Lowered_shoot"
		else:
			$AnimatedSprite.animation="Lowered"
			
	elif (state==states.RUNNING):
		if Input.is_action_pressed("Arrow_DOWN"+inputsExtra) :
			$AnimatedSprite.animation="Running_aiming_down"
		elif Input.is_action_pressed("Arrow_UP"+inputsExtra):
			$AnimatedSprite.animation="Running_aiming_up"
		elif shoot_Animation:
			$AnimatedSprite.animation="Running_aiming_front"
		else:
			$AnimatedSprite.animation="Running"

	elif (state==states.IDLE):
		if Input.is_action_pressed("Arrow_UP"+inputsExtra) :
			if Input.is_action_just_pressed("Shoot"+inputsExtra):
				$AnimatedSprite.animation="Look_up_shoot"
			else:
				$AnimatedSprite.animation="Look_up"
		else:
			if Input.is_action_just_pressed("Shoot"+inputsExtra) and can_shoot:
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
		if invincible:
			return
		if (state==states.INTO_THE_WATER):
			$AnimatedSprite.global_position.y-=fix_Y_FALLING_INTO_THE_WATER
			inWater=false
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
					if !is_instance_valid(Tile_Floor[index]):
						Tile_Floor[index]=null
						continue
					var tile = Tile_Floor[index]
					if (tile.global_position.x-tile.shape.extents.x*tile.scale.x<respawnPositionX and
					tile.global_position.x+tile.shape.extents.x*tile.scale.x>respawnPositionX ):
						canDrop=true
						respawnPositionX+=$BodyBoxCollision.get_children()[0].shape.extents.x*$BodyBoxCollision.get_children()[0].scale.x+20
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
		if (inTwoPlayersLimiteSpace()):
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

#SHOOT
	
func shootCD():
	can_shoot = true
	
func bst():
	blockShootTurn=false
	
func shoot():
	if (blockShootTurn):
		return
	shoot_Animation=true
	$ShootAnimation.start()
	shooting_directions()
	#rint($AnimatedSprite.animation)
	if bullet_type == 1 and Input.is_action_pressed("Shoot"+inputsExtra):
		is_shooting = true
		if can_shoot:
			bullet_shoot(bullet_rotation)
			timerCreator("shootCD",0.2,null,true)
			can_shoot = false
	elif Input.is_action_just_pressed("Shoot"+inputsExtra):
		is_shooting = true
		if can_shoot:
			if bullet_type == 4:
				laser_shoot()
			else:
				bullet_shoot(bullet_rotation)
				if (bullet_type==3):
					var b = bullet_rotation
					timerCreator("bullet_shoot",0.1,[b],true)
			
				if bullet_type == 2:
					spread_bullet()
				#cool_down_timer_node.start()
			
			can_shoot = false
			timerCreator("shootCD",0.5,null,true)
	else:
		is_shooting = false

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
	get_parent().add_child(laser_instance)
	laser_instance.global_position = bullet_position_node.global_position
	laser_instance.set_scale(Vector2(2,2))
	laser_instance.set_rotation(bullet_rotation)

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
		if Input.is_action_pressed("Arrow_UP"+inputsExtra) and (Input.is_action_pressed("Arrow_RIGHT"+inputsExtra) or Input.is_action_pressed("Arrow_LEFT"+inputsExtra)):
			bulletInfo(Vector2(10.613, -15.611),-30)
		elif Input.is_action_pressed("Arrow_DOWN"+inputsExtra) and (Input.is_action_pressed("Arrow_RIGHT"+inputsExtra) or Input.is_action_pressed("Arrow_LEFT"+inputsExtra)):
			bulletInfo(Vector2(13, 6),27)
		elif Input.is_action_pressed("Arrow_UP"+inputsExtra):
			bulletInfo(Vector2(0.236, -14.124),-90)
		elif Input.is_action_pressed("Arrow_DOWN"+inputsExtra):
			bulletInfo(Vector2(0.236, 4.832),90)
		else:
			bulletInfo(Vector2(9.198, -6.69),0)
	

func _on_Timer_timeout() -> void:
	
	pass



func _on_ShootAnimation_timeout() -> void:
	shoot_Animation=false
