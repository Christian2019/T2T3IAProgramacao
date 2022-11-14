extends Node2D

export (Array, Texture) var falcons

var falcon_index = 0
var speed = 100
var vertical_force = -6
export var gravityForce = 6

var stop = false

var Tile_Floor
var onTheTile
var firstTime=true

func _ready():
	$Sprite.texture = falcons[falcon_index]
	Tile_Floor = Global.MainScene.get_node("Tiles/Floor").get_children()

	
func _process(delta):
	if stop:
		return
	if (onTheTile):
		stop=true
		return
	gravity()
	horizontal_velocity()

func getGroundBoxPosition():
		var center= {"x":($GroundBoxCollision/CollisionShape2D.global_position.x),"y":($GroundBoxCollision/CollisionShape2D.global_position.y)}
		var extents= {"x":$GroundBoxCollision/CollisionShape2D.shape.extents.x*$GroundBoxCollision/CollisionShape2D.global_scale.x,"y":$GroundBoxCollision/CollisionShape2D.shape.extents.y*$GroundBoxCollision/CollisionShape2D.global_scale.y}
		return {"center":center,"extents":extents}

func gravity():
	if (vertical_force>=0):
		var groundPosition= getGroundBoxPosition()
		for index in vertical_force:
			groundPosition.center.y+=1
			if (tileCollision(groundPosition,Tile_Floor)):
				vertical_force = 0
				speed = 0
				onTheTile=true
				return
	onTheTile=false
	global_position.y += vertical_force
	vertical_force += gravityForce * Global.Inverse_MAX_FPS

func tileCollision(objectCollisionShape,tileColissionShapes):
	var center
	var extents
	for index in range(tileColissionShapes.size()):
		center= {"x":tileColissionShapes[index].global_position.x,"y":tileColissionShapes[index].global_position.y}
		extents={"x":tileColissionShapes[index].shape.extents.x*tileColissionShapes[index].global_scale.x,"y":tileColissionShapes[index].shape.extents.y*tileColissionShapes[index].global_scale.y}
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

func horizontal_velocity():
	global_position.x += speed * Global.Inverse_MAX_FPS

func _on_Body_area_entered(area: Area2D) -> void:
	if (area.get_parent().is_in_group("Player")):
		var score = 1000
		print("ItemPickUp")
		
		if (area.get_parent().name=="Player"):
			Global.player1Score+=score
		else:
			Global.player2Score+=score
			
		if (falcon_index==0):
			area.get_parent().shootCDTimer=area.get_parent().shootCDTimerItem
		else:	
			area.get_parent().bullet_type=falcon_index
		queue_free()
