extends Node2D

var creating =false
var Enemy_Backpack = preload("res://Scenes/Enemy_Backpack.tscn")

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	if (get_children().size()<3 and playersCondition()):
		if (!creating):
			creating=true
			timerCreator("done",0.5,null,true)
			

func playersCondition():
	var cameraPosition =get_parent().get_parent().get_node("Camera2D").global_position
	var cameraExt = get_parent().get_parent().get_node("Camera2D").cameraExtendsX
	if (global_position.x<cameraPosition.x-cameraExt or global_position.x>cameraPosition.x+cameraExt ):
		return true
	return false
	"""
	var minDistance = get_parent().get_parent().get_node("Camera2D").cameraExtendsX
	var maxDistance = minDistance*2
	#print (global_position.distance_to(get_parent().get_parent().get_node("Player").global_position))
	if(Global.players==2):
		if (global_position.distance_to(get_parent().get_parent().get_node("Player").global_position)>minDistance and
		global_position.distance_to(get_parent().get_parent().get_node("Player2").global_position)>minDistance):
			if (global_position.distance_to(get_parent().get_parent().get_node("Player").global_position)<maxDistance and
		global_position.distance_to(get_parent().get_parent().get_node("Player2").global_position)<maxDistance):
				#print("entrou")
				return true
	else:
		if (global_position.distance_to(get_parent().get_parent().get_node("Player").global_position)>minDistance):
			if (global_position.distance_to(get_parent().get_parent().get_node("Player").global_position)<maxDistance):
				#print("entrou")
				return true
	return false
	"""
func done():
	creating=false
	var e = Enemy_Backpack.instance()
	e.scale.x=3
	e.scale.y=3
	add_child(e)
	
	
func timerCreator(functionName,time,parameters,create):
	if (create):
		var timer = Timer.new()
		if (parameters==null):
			timer.connect("timeout",self,functionName)
		else:
			timer.connect("timeout",self,functionName,parameters)
		timer.set_wait_time(time)
		add_child(timer)
		timer.one_shot=true
		timer.start()
	
		var timer2 = Timer.new()
		timer2.connect("timeout",self,"timerCreator",["",0,[timer,timer2],false])
		timer2.set_wait_time(time+1)
		add_child(timer2)
		timer2.one_shot=true
		timer2.start()
	else:
		remove_child(parameters[0])
		remove_child(parameters[1])
