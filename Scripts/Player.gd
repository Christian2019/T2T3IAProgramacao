extends KinematicBody2D

export var speed = 400
var screen_size
var gravity=0
export var gravityForce=10
export var jumpForce=4
var onTheTile=false
var Tile_Floor
var Tile_Water


func _ready() -> void:
	screen_size= get_viewport_rect().size
	loadTiles()
	
func loadTiles():
		Tile_Floor= get_parent().get_node("Tiles/Floor").get_children()
		Tile_Water= get_parent().get_node("Tiles/Water").get_children()

func getFootPosition():
		var center= {"x":(position.x+$FootBoxCollision.position.x*scale.x),"y":(position.y+$FootBoxCollision.position.y*scale.y)}
		var extents= {"x":$FootBoxCollision.shape.extents.x*scale.x,"y":$FootBoxCollision.shape.extents.y*scale.y}
		return {"center":center,"extents":extents}

func getBodyPosition():
		var center= {"x":(position.x+$BodyBoxCollision.position.x*scale.x),"y":(position.y+$BodyBoxCollision.position.y*scale.y)}
		var extents= {"x":$BodyBoxCollision.shape.extents.x*scale.x,"y":$BodyBoxCollision.shape.extents.y*scale.y}
		return {"center":center,"extents":extents}
	
func gravityF():

	if (gravity>=0):
		var footPosition= getFootPosition()
		for index in gravity:
			footPosition.center.y+=1
			if (tileCollision(footPosition,Tile_Floor)||tileCollision(footPosition,Tile_Water)):
				gravity =0
				fit(footPosition)
				onTheTile=true
				return
	onTheTile=false
	position.y+=gravity
	gravity+=gravityForce*Fps.MAX_FPS

func tileCollision(objectCollisionShape,tileColissionShapes):
	var center
	var extents
	for index in range(tileColissionShapes.size()):
		center= {"x":tileColissionShapes[index].position.x,"y":tileColissionShapes[index].position.y}
		extents={"x":tileColissionShapes[index].shape.extents.x,"y":tileColissionShapes[index].shape.extents.y}
		if squareCollision(objectCollisionShape.center,objectCollisionShape.extents,center,extents):
			return true
	return false

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

func fit(footPosition):
	footPosition.center.y-=1
	while(tileCollision(footPosition,Tile_Floor)||tileCollision(footPosition,Tile_Water)):
		footPosition.center.y-=1
	position.y= footPosition.center.y+1-$FootBoxCollision.position.y*scale.y

func _process(delta: float) -> void:

	if Input.is_action_pressed("Escape"):
		get_tree().change_scene("res://Scenes/Prototypes/PrototypeMenu.tscn")
	
	#Funcao de gravidade	
	gravityF()
		
	#Pulo
	jump()
	
	#Movimento Lateral
	horizontal_Move()
	
	#Subir na plataforma se estiver na agua
	climb()
	
	#Mantem o personagem dentro da tela
	insideScreen()

func climb():
	var footPosition= getFootPosition()
	var bodyPosition = getBodyPosition()
	if (tileCollision(footPosition,Tile_Water)and
		tileCollision(bodyPosition,Tile_Floor)
	): 
		fit(footPosition)

func horizontal_Move():
	if Input.is_action_pressed("Arrow_RIGHT"):
		position.x += speed*Fps.MAX_FPS
	elif Input.is_action_pressed("Arrow_LEFT"):
			position.x -= speed*Fps.MAX_FPS
		

func jump():
	if (onTheTile and !tileCollision(getFootPosition(),Tile_Water)):
		#Drop
		if Input.is_action_pressed("Arrow_DOWN"):
			if Input.is_action_pressed("Jump"):
				var footPosition= getFootPosition()
				while(tileCollision(footPosition,Tile_Floor)):
					footPosition.center.y+=1
				if (!tileCollision(footPosition,Tile_Water)):
					position.y= footPosition.center.y+1-$FootBoxCollision.position.y*scale.y
					
		else:
			#Jump
			if Input.is_action_pressed("Jump"):
				position.y-=1
				gravity-=jumpForce

func insideScreen():
	var leftWidth= $BodyBoxCollision.shape.extents.x*scale.x
	var rightWidth =$BodyBoxCollision.shape.extents.x*scale.x
	var upHeight= $BodyBoxCollision.shape.extents.y*scale.y
	var downHeight = $BodyBoxCollision.shape.extents.y*scale.y
	position.x = clamp(position.x,0+leftWidth,screen_size.x-rightWidth)
	position.y = clamp(position.y,0+upHeight,screen_size.y-downHeight)

func _on_Timer_timeout() -> void:
	pass

