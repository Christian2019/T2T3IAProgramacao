extends Area2D

export (PackedScene) var cannon_bullet

var life = 6
var destroyed = false

func loose_life():
	life -= 1
	#print("Perdeu vida: ", life)
	if life <= 0:
		destroy_turret()

func destroy_turret():
	if destroyed:
		return
	
	destroyed = true
	
	$CollisionShape2D.queue_free()
	
	$Sprite.set_frame(2)

func shoot():
	var bullet_instance = cannon_bullet.instance()
	get_parent().add_child(bullet_instance)
	bullet_instance.global_position = $ShootBullet.global_position
