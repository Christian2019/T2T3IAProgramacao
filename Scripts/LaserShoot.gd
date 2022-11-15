extends Node2D

var speed = 400
var direction := Vector2(1,0)

func _ready() -> void:
	var path ="Sounds/Bullet4"
	
	var parent = Global.MainScene.get_node(path).get_children()
	
	for index in range(0,parent.size(),1):
		var child= parent[index]
		if !child.playing:
			child.play()
			return

func set_rotation(rotation):
	rotation_degrees = rotation

func _on_Timer_timeout():
	queue_free()
	
