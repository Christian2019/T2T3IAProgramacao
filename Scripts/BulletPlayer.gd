extends Area2D

export(Array, Texture) var bullet_type_sprite_node
export(Array, AudioStream) var bullet_hit_audio
var bullet_type = 0;
# 0->normal 1->machinegun 2->spread 3->flamethrower 4->bullet pop

var sprite_node
var axis_node
var hit_audio_node
var timer_node

var direction : Vector2
var stop = false

var player
var normal_speed = 1000
var flame_bullet_speed = 350
var angular_speed = 4
var angle = PI / 2
var radius = 50
var going_right = true

var dir_correction = 1

func _ready():
	sprite_node = $Sprite
	axis_node = $Position2D
	hit_audio_node = $HitAudio
	timer_node = $Timer
	direction.x = 1
	direction.y = 0

func _process(delta):
	if not stop:
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

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

	

func pop_bullet():
	$CollisionShape2D.queue_free()
	sprite_node.texture = bullet_type_sprite_node[4]
	stop = true
	hit_audio(1)
	timer_node.start()

func hit_audio(index):
	hit_audio_node.set_stream(bullet_hit_audio[index])
	hit_audio_node.play()

func _on_Timer_timeout():
	sprite_node.visible = false


func _on_HitAudio_finished():
	queue_free()


func _on_BulletPlayer_area_entered(area: Area2D) -> void:
	if (area.get_parent().is_in_group("Enemy")):
		var enemy = area.get_parent()
		enemy.life-=1
		pop_bullet()
		if (enemy.life<=0):
			enemy.destroy()
			
			# disconnect(signal: String, target: Object, ~~)

	"""		
	if area.is_in_group("Capsule"):
		area.explode()
		
	
	if area.is_in_group("Enemy"):
		area.queue_free() #chamar função animação de morte do inimigo
		pop_bullet()
	
	elif area.is_in_group("Turret"):
		area.loose_life()
		pop_bullet()
	"""
