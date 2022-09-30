extends KinematicBody2D

export var speed = 400
var screen_size
var isJumping=false
var onTheFloor=false
var gravity=0


func _ready() -> void:
	screen_size= get_viewport_rect().size

func _process(delta: float) -> void:
	if (!get_parent().visible):
		return
	
	horizontal_Move(delta)
	var centerA= {"x":(position.x-14),"y":(position.y+54)}
	var extentsA= {"x":15,"y":1}
	var centerB= {"x":get_parent().get_node("Tiles/Floor/CollisionShape2D").position.x,"y":get_parent().get_node("Tiles/Floor/CollisionShape2D").position.y}
	var extentsB= {"x":get_parent().get_node("Tiles/Floor/CollisionShape2D").shape.extents.x,"y":get_parent().get_node("Tiles/Floor/CollisionShape2D").shape.extents.y}

#	var extentsA= {"x":$FootBoxColision/CollisionShape2D.shape.extents.x,"y":$FootBoxColision/CollisionShape2D.shape.extents.y}
	
	#var centerA= {"x":(position.x+$FootBoxColision/CollisionShape2D.getposition),"y":(position.y+$FootBoxColision/CollisionShape2D.position.y)}
#	var centerB= {"x":get_parent().get_node("Tiles/Floor/CollisionShape2D").position.x,"y":get_parent().get_node("Tiles/Floor/CollisionShape2D").position.y}
#	var extentsB= {"x":get_parent().get_node("Tiles/Floor/CollisionShape2D").shape.extents.x,"y":get_parent().get_node("Tiles/Floor/CollisionShape2D").shape.extents.y}

	if squareColision(centerA,extentsA,centerB,extentsB):
		print("certo")

	#collisions()
	#verifica se o pe do player esta no chao
	
	#se estiver ele pode pular, caso contrario ele deve cair
	
	#pulo quando aplicado a colisao com chao so eh considerada quando estiver em queda
	
	#matem o personagem dentro da tela
	position.x = clamp(position.x,0,screen_size.x)
	position.y = clamp(position.y,0,screen_size.y)

func horizontal_Move(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x=1
	elif Input.is_action_pressed("ui_left"):
		velocity.x=-1
	elif Input.is_action_pressed("ui_up"):
		velocity.y=-1
	elif Input.is_action_pressed("ui_down"):
		velocity.y=+1
	else:
		velocity.x=0
		velocity.y=0

	for index in speed:
		if !onTheFloor:
			position.x += velocity.x*delta
			position.y += velocity.y*delta
	
	#move_and_slide(velocity,Vector2(0,0),false,4,0.785,true)

func collisions():
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		print(collision.collider.name)
		

func squareColision(centerA,extentsA,centerB,extentsB):
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

func _on_Floor_area_entered(area: Area2D) -> void:
	pass
	#print(area.name+"Entrou")
	#onTheFloor=true

func _on_Floor_area_exited(area: Area2D) -> void:
	pass
	#print(area.name+"Saiu")


func _on_Timer_timeout() -> void:
	var centerA= {"x":(position.x+$FootBoxColision/CollisionShape2D.position.x),"y":(position.y+$FootBoxColision/CollisionShape2D.position.y)}
	#var centerA= {"x":$FootBoxColision/CollisionShape2D.get_global_transform_with_canvas().x,"y":(position.y+$FootBoxColision/CollisionShape2D.position.y)}
	var extentsA= {"x":$FootBoxColision/CollisionShape2D.shape.extents.x,"y":$FootBoxColision/CollisionShape2D.shape.extents.y}
	var centerB= {"x":get_parent().get_node("Tiles/Floor/CollisionShape2D").position.x,"y":get_parent().get_node("Tiles/Floor/CollisionShape2D").position.y}
	var extentsB= {"x":get_parent().get_node("Tiles/Floor/CollisionShape2D").shape.extents.x,"y":get_parent().get_node("Tiles/Floor/CollisionShape2D").shape.extents.y}
	print (centerA,extentsA,centerB,extentsB)
