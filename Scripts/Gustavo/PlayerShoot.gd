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

func _process(delta):
	if Input.is_action_pressed("Escape"):
		get_tree().change_scene("res://Scenes/Prototypes/PrototypeMenu.tscn")
	move()
	jump()
	change_shoot()
	shoot()

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
		position.y-=1
		
	elif Input.is_action_pressed("ui_down"):
		if is_jumping:
			shooting_directions("down")
		else:
			if facing_right:
				shooting_directions("lowered_right")
			else:
				shooting_directions("lowered_left")
			animated_sprite_node.play("idle_lowered")
		position.y+=1
		
	elif Input.is_action_pressed("ui_left"):
		if facing_right:
			flip_player()
		shooting_directions("left")
		if not is_jumping:
			if is_shooting:
				animated_sprite_node.play("run_shoot")
			else:
				animated_sprite_node.play("run")
		position.x-=1
		
	elif Input.is_action_pressed("ui_right"):
		if not facing_right:
			flip_player()
		shooting_directions("right")
		if not is_jumping:
			if is_shooting:
				animated_sprite_node.play("run_shoot")
			else:
				animated_sprite_node.play("run")
		position.x+=1
		
	else:
		if facing_right:
			shooting_directions("right")
		else:
			shooting_directions("left")
		if not is_jumping:
			animated_sprite_node.play("idle")

func jump():
	if Input.is_action_just_pressed("Jump"):
		is_jumping = !is_jumping
	if is_jumping:
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
				#cool_down_timer_node.start()
			
			#can_shoot = false
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
