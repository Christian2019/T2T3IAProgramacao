extends Area2D

export (Array, Texture) var falcons

export var falcon_index = 0
var speed = 80
var vertical_force = -5
export var gravityForce = 6

var stop = false

var Tile_Floor
var onTheTile

func _ready():
	$Sprite.texture = falcons[falcon_index]
	Tile_Floor = get_parent().get_parent().get_node("Tiles/Floor").get_children()

func _process(delta):
	if stop:
		return
	
	gravity()
	horizontal_velocity()

func getGroundBoxPosition():
		var center= {"x":(position.x+$GroundBoxCollision.position.x*scale.x),"y":(position.y+$GroundBoxCollision.position.y*scale.y)}
		var extents= {"x":$GroundBoxCollision.shape.extents.x*scale.x,"y":$GroundBoxCollision.shape.extents.y*scale.y}
		return {"center":center,"extents":extents}

func gravity():
	if (vertical_force>=0):
		var groundPosition= getGroundBoxPosition()
		for index in vertical_force:
			groundPosition.center.y+=1
			if (tileCollision(groundPosition,Tile_Floor)):
				vertical_force = 0
				speed = 0
				fit(groundPosition)
				onTheTile=true
				return
	onTheTile=false
	
	position.y += vertical_force
	vertical_force += gravityForce * Global.Inverse_MAX_FPS

func tileCollision(objectCollisionShape,tileColissionShapes):
	var center
	var extents
	for index in range(tileColissionShapes.size()):
		center= {"x":tileColissionShapes[index].position.x,"y":tileColissionShapes[index].position.y}
		extents={"x":tileColissionShapes[index].shape.extents.x,"y":tileColissionShapes[index].shape.extents.y}
		if squareCollision(objectCollisionShape.center,objectCollisionShape.extents,center,extents):
			return true
	return false

func fit(footPosition):
	footPosition.center.y-=1
	while(tileCollision(footPosition,Tile_Floor)):
		footPosition.center.y-=1
	position.y= footPosition.center.y+1-$GroundBoxCollision.position.y*scale.y

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

func horizontal_velocity():
	position.x += speed * Global.Inverse_MAX_FPS

func _on_PickUp_area_entered(area):
	if area.is_in_group("Ground"):
		if vertical_force > 0:
			stop = true


func _on_PickUp_body_entered(body):
	if body.is_in_group("Player"):
		$CollisionShape2D.queue_free()
		$GroundBoxCollision.queue_free()
		body.bullet_type = falcon_index
		print("Arma player: ", body.bullet_type)
		queue_free()
