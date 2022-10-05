extends Area2D

var speed = 500
export(Array, Texture) var bullet_type
var sprite
var velocity : Vector2
var hit_player = false

func _ready():
	sprite = $Sprite
	velocity.x = 1
	velocity.y = 0

func _process(delta):
	position += velocity * speed * delta

func set_speed(speed):
	self.speed = speed

func set_bullet(speed, type, dir, hitplayer):
	self.speed = speed
	sprite.texture = bullet_type[type]
	velocity.x = dir.x
	velocity.y = dir.y
	self.hit_player = hit_player  

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Bullet_body_entered(body):
	if "Enemy" in body.name:
		body.queue_free()
		queue_free()
