extends Area2D

export(Array, Texture) var bullet_type_sprite_node

var bullet_type = 0;
# 0->normal 1->machinegun 2->spread 3->flamethrower 4->bullet pop

var sprite_node
var axis_node

var timer_node

var direction : Vector2
var stop = false

var playerName
var normal_speed = 1000
var flame_bullet_speed = 350
var angular_speed = 4
var angle = PI / 2
var radius = 50
var going_right = true

var dir_correction = 1
var start=true
var camera =  Global.MainScene.get_node("Camera2D")

func _ready():
	sprite_node = $Sprite
	axis_node = $Position2D
	timer_node = $Timer
	direction.x = 1
	direction.y = 0
	var new_parent = Global.MainScene.get_node("BulletsPlayer")
	get_parent().remove_child(self)
	new_parent.add_child(self)

func outOfScreen():
	var ext=600
	if (camera.global_position.x-ext>global_position.x or camera.global_position.x+ext<global_position.x
	or camera.global_position.y-ext>global_position.y or camera.global_position.y+ext<global_position.y):
		queue_free()
	
func sounds():
	var path
	if bullet_type==0 or bullet_type==1:
		path ="Sounds/Bullet01"
	elif bullet_type==2:
		path ="Sounds/Bullet2"
		if Global.MainScene.get_node(path).canSound:
			Global.MainScene.get_node(path).canSound=false
		else:
			return
	elif bullet_type==3:
		path ="Sounds/Bullet3"
	else:
		return
				
	playSound(path)

func playSound(path):
	
	var parent = Global.MainScene.get_node(path).get_children()
	
	for index in range(0,parent.size(),1):
		var child= parent[index]
		if !child.playing:
			child.play()
			return

func _process(delta):
	outOfScreen()
	if (start):
		start=false
		sounds()
	if not stop:
		if (bullet_type == 2 and scale.x<3):
			scale.x+=0.04
			scale.y+=0.04
		elif(scale.x>3):
			scale.x=3
			scale.y=3
		if bullet_type == 3:
			rotate_around_axis_node()
		else:
			position.x += direction.x * normal_speed * Global.Inverse_MAX_FPS
			position.y += direction.y * normal_speed * Global.Inverse_MAX_FPS

func rotate_around_axis_node():
	angle += PI * angular_speed * Global.Inverse_MAX_FPS
	rotation_degrees = 90
	var dx = sin(angle) * radius
	var dy = cos(angle) * radius
	
	position = dir_correction * Vector2(-dx, dir_correction * dy) + axis_node.position
	axis_node.position += direction * flame_bullet_speed * Global.Inverse_MAX_FPS

func set_bullet(position, type, dir, facing_right):
	direction.x = cos(deg2rad(dir))
	direction.y = sin(deg2rad(dir))
	axis_node.position = position + radius_position(direction)
	bullet_type = type
	sprite_node.texture = bullet_type_sprite_node[type]
	if facing_right:
		dir_correction = 1
	else:
		dir_correction = -1

func radius_position(dir):
	match dir:
		Vector2(-1, 0):
			angle = PI / 2
			return Vector2(-radius, 0)
		Vector2(1, 0):
			angle = PI / 2
			return Vector2(radius, 0)
		Vector2(0, -1):
			angle = 0
			return Vector2(0, -radius)
		Vector2(0, 1):
			angle = PI
			return Vector2(0, radius)
	
	if dir.y < 0:
		angle = PI/4
	else:
		angle = 3 * PI/4
	return dir * radius

func pop_bullet():
	$CollisionShape2D.queue_free()
	sprite_node.texture = bullet_type_sprite_node[4]
	stop = true
	timer_node.start()
	

func _on_Timer_timeout():
	queue_free()


func _on_BulletPlayer_area_entered(area: Area2D) -> void:
	if (area.get_parent().is_in_group("Enemy")):
		var enemy = area.get_parent()
		enemy.life-=1
		pop_bullet()
		if (enemy.life<=0):
			enemy.destroy()
			score(enemy)
			if Global.MainScene.get_node("Sounds/DeathEnemy").canSound:
				Global.MainScene.get_node("Sounds/DeathEnemy").canSound=false
				playSound("Sounds/DeathEnemy")
		else:
			if Global.MainScene.get_node("Sounds/Enemy_hit").canSound:
				Global.MainScene.get_node("Sounds/Enemy_hit").canSound=false
				playSound("Sounds/Enemy_hit")

	elif area.get_parent().is_in_group("Capsule"):
		playSound("Sounds/Enemy_hit")
		area.get_parent().explode()
		score(area.get_parent())
		pop_bullet()

	elif area.is_in_group("Turret"):
		playSound("Sounds/Enemy_hit")
		area.loose_life()		
		pop_bullet()
		if (area.name.substr(0, "ItemTurret".length())=="ItemTurret"):
			score(area)
		elif (area.life<=0):
			score(area)

func score(entity):
	var score = 0
	#print(entity.name)
	if (entity.name.substr(0, "ItemTurret".length())=="ItemTurret"):
		score = 500
	elif (entity.name.substr(0, "ItemFlyingCapsule".length())=="ItemFlyingCapsule"):
		score = 500
	elif (entity.name.substr(0, "Enemy_Bush".length())=="Enemy_Bush"):
		score = 500
	elif (entity.name.substr(0, "Sniper".length())=="Sniper"):
		score = 500
	elif (entity.name.substr(0, "Enemy_Cannon".length())=="Enemy_Cannon"):
		score = 500
	elif (entity.name.substr(0, "Enemy_WallTurret".length())=="Enemy_WallTurret"):
		score = 300
	elif (entity.name=="Cannon1" or entity.name=="Cannon2"):
		score = 1000
	elif (entity.name=="Door"):
		score = 10000
	
	if (playerName=="Player"):
		Global.player1Score+=score
	else:
		Global.player2Score+=score
