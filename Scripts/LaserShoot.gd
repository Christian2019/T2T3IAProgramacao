extends Node2D

var speed = 400
var direction := Vector2(1,0)
var camera =  Global.MainScene.get_node("Camera2D")

func _ready() -> void:
	var new_parent = Global.MainScene.get_node("BulletsPlayer")
	get_parent().remove_child(self)
	new_parent.add_child(self)
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

func _process(delta: float) -> void:
	outOfScreen()
	
func outOfScreen():
	var ext=600
	if (camera.global_position.x-ext>global_position.x or camera.global_position.x+ext<global_position.x
	or camera.global_position.y-ext>global_position.y or camera.global_position.y+ext<global_position.y):
		queue_free()
