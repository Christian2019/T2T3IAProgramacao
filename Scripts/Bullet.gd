extends Area2D

var speed = 500
export(Array, Texture) var bullet_type
var sprite
var direction : Vector2
var stop = false
var hit_player = false

func _ready():
	sprite = $Sprite
	direction.x = 1
	direction.y = 0

func _process(delta):
	if not stop:
		position += direction * speed * delta

func set_speed(speed):
	self.speed = speed

func set_bullet(speed, type, dir, hitplayer):
	self.speed = speed
	sprite.texture = bullet_type[type]
	direction.x = dir.x
	direction.y = dir.y
	self.hit_player = hit_player

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Bullet_body_entered(body):
	if "Enemy" in body.name:
		body.queue_free()
		stop = true
		sprite.texture = bullet_type[4]
		$Timer.start()


func _on_Timer_timeout():
	queue_free()
