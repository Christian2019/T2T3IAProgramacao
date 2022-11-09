extends Node2D

export (PackedScene) var bullet
export (PackedScene) var laser
export (Array, AudioStream) var gun_shoot_audio

var bullet_type = 0
# 0->normal 1->machinegun 2->spread 3->flamethrower 4->laser
var facing_right = true
var is_jumping = false
var is_shooting = false

var can_shoot = true

var bullet_rotation := 0.0
var bullet_adjacent_1 := 0.0
var bullet_adjacent_2 := 0.0
var bullet_adjacent_3 := 0.0
var bullet_adjacent_4 := 0.0

export var gravityForce = 6
var vertical_force = 0
var jump_force = 6
var speed = 200

var Tile_Floor
var onTheTile

var animated_sprite_node
var bullet_position_node
var cool_down_timer_node
var shoot_audio_node

func _ready():
	animated_sprite_node = $AnimatedSprite
	bullet_position_node = $BulletPosition
	cool_down_timer_node = $CoolDownTimer
	shoot_audio_node = $ShootAudio
	bullet_type = 0
	Tile_Floor = get_parent().get_node("Tiles/Floor").get_children()

func _process(delta):
	if Input.is_action_pressed("Escape"):
		get_tree().change_scene("res://Scenes/Prototypes/PrototypeMenu.tscn")
	gravity()
	move()
	jump()
	change_shoot()
	shoot()


func getGroundBoxPosition():
		var center= {"x":(position.x+$FootBoxCollision.position.x*scale.x),"y":(position.y+$FootBoxCollision.position.y*scale.y)}
		var extents= {"x":$FootBoxCollision.shape.extents.x*scale.x,"y":$FootBoxCollision.shape.extents.y*scale.y}
		return {"center":center,"extents":extents}

func gravity():
	if (vertical_force>=0):
		var groundPosition= getGroundBoxPosition()
		for index in vertical_force:
			groundPosition.center.y+=1
			if (tileCollision(groundPosition,Tile_Floor)):
				vertical_force = 0
				fit(groundPosition)
				onTheTile=true
				return
	onTheTile=false
	
	position.y += vertical_force
	vertical_force += gravityForce * Fps.MAX_FPS

func tileCollision(objectCollisionShape,tileColissionShapes):
	var center
	var extents
	for index in range(tileColissionShapes.size()):
		center= {"x":tileColissionShapes[index].position.x,"y":tileColissionShapes[index].position.y}
		extents={"x":tileColissionShapes[index].shape.extents.x,"y":tileColissionShapes[index].shape.extents.y}
		if squareCollision(objectCollisionShape.center,objectCollisionShape.extents,center,extents):
			return true
	return false

func fit(footPosition):
	footPosition.center.y-=1
	while(tileCollision(footPosition,Tile_Floor)):
		footPosition.center.y-=1
	position.y= footPosition.center.y+1-$FootBoxCollision.position.y*scale.y

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

func horizontal_velocity():
	var horizontal_speed
	var max_speed
	if Input.is_action_pressed("ui_left"):
		max_speed = -speed
	elif Input.is_action_pressed("ui_right"):
		max_speed = speed
	else:
		max_speed = 0
	horizontal_speed = max_speed * Fps.MAX_FPS
	position.x += horizontal_speed

func move():
	if Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_left"):
		if facing_right:
			flip_player()
		shooting_directions("up_left")
		if not is_jumping:
			animated_sprite_node.play("run_shoot_up")
		
	elif Input.is_action_pressed("ui_up") and Input.is_action_pressed("ui_right"):
		if not facing_right:
			flip_player()
		shooting_directions("up_right")
		if not is_jumping:
			animated_sprite_node.play("run_shoot_up")
		
	elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_left"):
		if facing_right:
			flip_player()
		shooting_directions("down_left")
		if not is_jumping:
			animated_sprite_node.play("run_shoot_down")
		
	elif Input.is_action_pressed("ui_down") and Input.is_action_pressed("ui_right"):
		if not facing_right:
			flip_player()
		shooting_directions("down_right")
		if not is_jumping:
			animated_sprite_node.play("run_shoot_down")
		
	elif Input.is_action_pressed("ui_up"):
		shooting_directions("up")
		if not is_jumping:
			animated_sprite_node.play("idle_look_up")
		#position.y-=1
		
	elif Input.is_action_pressed("ui_down"):
		if is_jumping:
			shooting_directions("down")
		else:
			if facing_right:
				shooting_directions("lowered_right")
			else:
				shooting_directions("lowered_left")
			animated_sprite_node.play("idle_lowered")
		
	elif Input.is_action_pressed("ui_left"):
		if facing_right:
			flip_player()
		shooting_directions("left")
		if not is_jumping:
			if is_shooting:
				animated_sprite_node.play("run_shoot")
			else:
				animated_sprite_node.play("run")
		
	elif Input.is_action_pressed("ui_right"):
		if not facing_right:
			flip_player()
		shooting_directions("right")
		if not is_jumping:
			if is_shooting:
				animated_sprite_node.play("run_shoot")
			else:
				animated_sprite_node.play("run")
		
	else:
		if facing_right:
			shooting_directions("right")
		else:
			shooting_directions("left")
		if onTheTile:
			animated_sprite_node.play("idle")
	horizontal_velocity()

func jump():
	if Input.is_action_just_pressed("Jump"):
		print(get_node("/root").get_children()[1].name)
		if onTheTile:
			vertical_force = -jump_force
			animated_sprite_node.play("jump")

func change_shoot():
	if Input.is_action_just_pressed("ui_accept"):
		if bullet_type == 4:
			bullet_type = 0
		else:
			bullet_type += 1
		print("bullet changed: " , bullet_type)

func shoot():
	if bullet_type == 1 and Input.is_action_pressed("Shoot"):
		is_shooting = true
		if can_shoot:
			bullet_shoot(bullet_rotation)
			cool_down_timer_node.start()
			can_shoot = false
	elif Input.is_action_just_pressed("Shoot"):
		is_shooting = true
		if can_shoot:
			if bullet_type == 4:
				laser_shoot()
			else:
				bullet_shoot(bullet_rotation)
			
				if bullet_type == 2:
					spread_bullet()
	else:
		is_shooting = false

func bullet_shoot(dir):
	var bullet_instance = bullet.instance()
	get_parent().add_child(bullet_instance)
	bullet_instance.global_position = bullet_position_node.global_position
	bullet_instance.set_scale(Vector2(2,2))
	
	bullet_instance.set_bullet(bullet_position_node.global_position, 
		bullet_type, dir, facing_right)
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

func shooting_directions(direction):
	match direction:
		"up":
			bullet_position_node.position = Vector2(0, -20)
			bullet_rotation = -90
			bullet_adjacent_1 = -100
			bullet_adjacent_2 = -95
			bullet_adjacent_3 = -85
			bullet_adjacent_4 = -80
		"up_left":
			bullet_position_node.position = Vector2(-8, -14)
			bullet_rotation = -135
			bullet_adjacent_1 = -145
			bullet_adjacent_2 = -140
			bullet_adjacent_3 = -130
			bullet_adjacent_4 = -125
		"up_right":
			bullet_position_node.position = Vector2(8, -14)
			bullet_rotation = -45
			bullet_adjacent_1 = -55
			bullet_adjacent_2 = -50
			bullet_adjacent_3 = -40
			bullet_adjacent_4 = -35
		"left":
			bullet_position_node.position = Vector2(-12, -1)
			bullet_rotation = 180
			bullet_adjacent_1 = 190
			bullet_adjacent_2 = 185
			bullet_adjacent_3 = 175
			bullet_adjacent_4 = 170
		"right":
			bullet_position_node.position = Vector2(12, -1)
			bullet_rotation = 0
			bullet_adjacent_1 = 10
			bullet_adjacent_2 = 5
			bullet_adjacent_3 = -5
			bullet_adjacent_4 = -10
		"down":
			bullet_position_node.position = Vector2(0, 20)
			bullet_rotation = 90
			bullet_adjacent_1 = 100
			bullet_adjacent_2 = 95
			bullet_adjacent_3 = 85
			bullet_adjacent_4 = 80
		"down_left":
			bullet_position_node.position = Vector2(-10, 7)
			bullet_rotation = 135
			bullet_adjacent_1 = 145
			bullet_adjacent_2 = 140
			bullet_adjacent_3 = 130
			bullet_adjacent_4 = 125
		"down_right":
			bullet_position_node.position = Vector2(10, 7)
			bullet_rotation = 45
			bullet_adjacent_1 = 55
			bullet_adjacent_2 = 50
			bullet_adjacent_3 = 40
			bullet_adjacent_4 = 35
		"lowered_left":
			bullet_position_node.position = Vector2(-17, 13)
			bullet_rotation = 180
			bullet_adjacent_1 = 190
			bullet_adjacent_2 = 185
			bullet_adjacent_3 = 175
			bullet_adjacent_4 = 170
		"lowered_right":
			bullet_position_node.position = Vector2(17, 13)
			bullet_rotation = 0
			bullet_adjacent_1 = 10
			bullet_adjacent_2 = 5
			bullet_adjacent_3 = -5
			bullet_adjacent_4 = -10
	

func flip_player():
	if(facing_right):
		facing_right = false
		animated_sprite_node.flip_h = true
	else:
		facing_right = true
		animated_sprite_node.flip_h = false

func _on_CoolDownTimer_timeout():
	can_shoot = true
