extends Area2D

export (Texture) var pop_sprite
export (Array, AudioStream) var bullet_hit_audio_stream
var sprite
var hit_audio_node
var speed = 400
var stop = false
var direction := Vector2(1,0)

var hit_enemy = true

func _ready():
	sprite = $Sprite
	hit_audio_node = $HitAudio

func _process(delta):
	
	if not stop:
		position += direction * speed * Fps.MAX_FPS

func change_direction(dir, rot):
	direction = dir
	rotation_degrees = rot

func _on_LaserBeam_body_entered(body):
	if hit_enemy:
		if body.is_in_group("Enemy"):
			body.queue_free()
			sprite.texture = pop_sprite
			hit_enemy = false
			stop = true
			$Timer.start()
			hit_audio(0)
		elif body.is_in_group("Turret"):
			body.loose_life()
			sprite.texture = pop_sprite
			hit_enemy = false
			stop = true
			$Timer.start()
			hit_audio(1)

func hit_audio(index):
	hit_audio_node.set_stream(bullet_hit_audio_stream[index])
	hit_audio_node.play()

func _on_VisibilityNotifier2D_screen_exited():
	if hit_enemy:
		get_parent().queue_free()

func _on_Timer_timeout():
	queue_free()
