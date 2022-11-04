extends Area2D

export (Texture) var pop_sprite
var sprite
var speed = 400
var stop = false
var direction := Vector2(1,0)

var hit_enemy = true

func _ready():
	sprite = $Sprite

func _process(delta):
	
	if not stop:
		
		position += direction * speed * Global.Inverse_MAX_FPS

func change_direction(dir, rot):
	direction = dir
	rotation_degrees = rot

func _on_LaserBeam_body_entered(body):
	if hit_enemy:
		if "Enemy" in body.name:
			body.queue_free()
			
			sprite.texture = pop_sprite
			hit_enemy = false
			stop = true
			$Timer.start()
		elif "Turret" in body.name:
			body.loose_life()
		
			sprite.texture = pop_sprite
			hit_enemy = false
			stop = true
			$Timer.start()

func _on_VisibilityNotifier2D_screen_exited():
	if hit_enemy:
		get_parent().queue_free()

func _on_Timer_timeout():
	queue_free()
