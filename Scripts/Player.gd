extends KinematicBody2D

export var speed = 400
var screen_size
var gravity=0
export var gravityForce=10
export var jumpForce=4
func _ready() -> void:
	screen_size= get_viewport_rect().size
	
func gravityF(delta):
	if (gravity>=0):
		var centerA= {"x":(position.x+$FootBoxCollision.position.x*scale.x),"y":(position.y+$FootBoxCollision.position.y*scale.y)}
		var extentsA= {"x":$FootBoxCollision.shape.extents.x*scale.x,"y":$FootBoxCollision.shape.extents.y*scale.y}
		for index in gravity:
			centerA.y+=index
			if floorCollision(centerA,extentsA):
				gravity =0
				fit(centerA,extentsA)
				return
	
	position.y+=gravity
	gravity+=gravityForce*delta
	
	
func onTheFloor():
	if (gravity<0):
		return false
	var centerA= {"x":(position.x+$FootBoxCollision.position.x*scale.x),"y":(position.y+$FootBoxCollision.position.y*scale.y)}
	var extentsA= {"x":$FootBoxCollision.shape.extents.x*scale.x,"y":$FootBoxCollision.shape.extents.y*scale.y}
	if floorCollision(centerA,extentsA):
		fit(centerA,extentsA)
		return true
	return false

func fit(centerA,extentsA):
	centerA.y-=1
	while(floorCollision(centerA,extentsA)):
		centerA.y-=1
	position.y= centerA.y+1-$FootBoxCollision.position.y*scale.y
		
	
func floorCollision(centerA,extentsA):
	var allFloorShapes= get_parent().get_node("Tiles/Floor").get_children()
	var centerB
	var extentsB
	for index in range(allFloorShapes.size()):
		centerB= {"x":allFloorShapes[index].position.x,"y":allFloorShapes[index].position.y}
		extentsB={"x":allFloorShapes[index].shape.extents.x,"y":allFloorShapes[index].shape.extents.y}
		if squareCollision(centerA,extentsA,centerB,extentsB):
			return true
	
	return false
	
func lastFloorCollision(centerA,extentsA):
	var allFloorShapes= get_parent().get_node("Tiles/LastFloor").get_children()
	var centerB
	var extentsB
	for index in range(allFloorShapes.size()):
		centerB= {"x":allFloorShapes[index].position.x,"y":allFloorShapes[index].position.y}
		extentsB={"x":allFloorShapes[index].shape.extents.x,"y":allFloorShapes[index].shape.extents.y}
		if squareCollision(centerA,extentsA,centerB,extentsB):
			return true
	
	return false
		

func _process(delta: float) -> void:
	if (!get_parent().visible):
		return
		
		
	if (!onTheFloor()):
		gravityF(delta)
	else:
		if Input.is_action_pressed("ui_accept"):
			position.y-=1
			gravity-=jumpForce
	
	
	#drop
		if Input.is_action_pressed("ui_down"):
				var centerA= {"x":(position.x+$FootBoxCollision.position.x*scale.x),"y":(position.y+$FootBoxCollision.position.y*scale.y)}
				var extentsA= {"x":$FootBoxCollision.shape.extents.x*scale.x,"y":$FootBoxCollision.shape.extents.y*scale.y}
				if (!lastFloorCollision(centerA,extentsA)):
						while(floorCollision(centerA,extentsA)):
							centerA.y+=1
						position.y= centerA.y+1-$FootBoxCollision.position.y*scale.y
	
	horizontal_Move(delta)
	

#    var centerB= {"x":get_parent().get_node("Tiles/Floor/CollisionShape2D").position.x,"y":get_parent().get_node("Tiles/Floor/CollisionShape2D").position.y}
#		var extentsB= {"x":get_parent().get_node("Tiles/Floor/CollisionShape2D").shape.extents.x,"y":get_parent().get_node("Tiles/Floor/CollisionShape2D").shape.extents.y}

#	if squareCollision(centerA,extentsA,centerB,extentsB):
#		print("certo")

	
	#verifica se o pe do player esta no chao
	
	#se estiver ele pode pular, caso contrario ele deve cair
	
	#pulo quando aplicado a colisao com chao so eh considerada quando estiver em queda
	
	#matem o personagem dentro da tela
	position.x = clamp(position.x,0,screen_size.x)
	position.y = clamp(position.y,0,screen_size.y)

func horizontal_Move(delta):
	if Input.is_action_pressed("ui_right"):
		position.x += speed*delta
	elif Input.is_action_pressed("ui_left"):
			position.x -= speed*delta
	
		

func squareCollision(centerA,extentsA,centerB,extentsB):
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


func _on_Timer_timeout() -> void:
	pass
	"""
	var centerA= {"x":(position.x+$FootBoxCollision.position.x*scale.x),"y":(position.y+$FootBoxCollision.position.y*scale.y)}
	var extentsA= {"x":$FootBoxCollision.shape.extents.x*scale.x,"y":$FootBoxCollision.shape.extents.y*scale.y}
	var centerB= {"x":get_parent().get_node("Tiles/Floor/CollisionShape2D").position.x,"y":get_parent().get_node("Tiles/Floor/CollisionShape2D").position.y}
	var extentsB= {"x":get_parent().get_node("Tiles/Floor/CollisionShape2D").shape.extents.x,"y":get_parent().get_node("Tiles/Floor/CollisionShape2D").shape.extents.y}
	print (centerA,extentsA,centerB,extentsB)
	"""
