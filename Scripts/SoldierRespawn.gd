extends Node2D

var creating =false
var Enemy_Backpack = preload("res://Scenes/Enemy_Backpack.tscn")

func _ready() -> void:
	pass 

func _process(delta: float) -> void:
	if ($Soldiers.get_children().size()<3 and playersCondition()):
		if (!creating):
			creating=true
			
			timerCreator("done",1,null,true)
			

func playersCondition():
	var camera =Global.MainScene.get_node("Camera2D")
	var cameraWidth = camera.cameraExtendsX*2
	var distanceToCamera = global_position.distance_to(camera.global_position)
	var minDistanceX = cameraWidth/2
	var maxDistanceX = cameraWidth

	if (distanceToCamera>minDistanceX and distanceToCamera<maxDistanceX ):
		return true
	return false
	
func done():
	creating=false
	
	var n = 3-$Soldiers.get_children().size()
	
	for index in range(0,n,1):
		var time=float(intRandom(1,10))/10
		timerCreator("create",time,null,true)
	
	
func create():
	
	var e = Enemy_Backpack.instance()
	e.scale.x=3
	e.scale.y=3
	$Soldiers.add_child(e)

#Sorteia um número inteiro >= ao minV e < maxV	
func intRandom(minV,maxV):
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	return int (rng.randf_range(minV, maxV))
	
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
