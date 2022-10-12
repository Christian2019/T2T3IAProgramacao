extends Area2D

var speed = 500
export(Array, Texture) var bullet_type_sprite
var bullet_type = 0;
var sprite
var direction : Vector2
var stop = false
var hit_player = false
var axis

var angle = PI / 2
var radius = 50
var sin_cos45 = 0.7071
var angular_speed = 1
var going_right = true

var dir_correction = 1

func _ready():
	sprite = $Sprite
	axis = $Position2D
	direction.x = 1
	direction.y = 0

func _process(delta):
	if not stop:
		position += direction * speed * delta

		if bullet_type == 3:
			rotate_around_axis(delta)
		else:
			position += direction * speed * delta
		position += direction * speed * delta

func rotate_around_axis(delta):
	angle += PI * angular_speed * delta
	rotation_degrees = 90
	var dx = sin(angle) * radius
	var dy = cos(angle) * radius
	
	position = dir_correction * Vector2(-dx, dir_correction * dy) + axis.position
	axis.position += direction * speed * delta

func set_bullet(position, speed, type, dir, facing_right, hitplayer):
	direction = dir
	axis.position = position + radius_position(dir)
	self.speed = speed
	bullet_type = type
	sprite.texture = bullet_type_sprite[type]
	if facing_right:
		dir_correction = 1
	else:
		dir_correction = -1
	self.hit_player = hit_player

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


func _on_Bullet_body_entered(body):
	if "Enemy" in body.name:
		stop = true
		sprite.texture = bullet_type_sprite[4]
		$Timer.start()
		body.queue_free()


func _on_Timer_timeout():
	queue_free()
