extends Node2D

var partesVetor:Array;
var destroy=false
var player
var player1
var player2
var firstTime=true 

func _ready(): 
	get_node("Ponte0/AnimatedSprite").play("Normal")
	get_node("Ponte1/AnimatedSprite").play("default")
	get_node("Ponte2/AnimatedSprite").play("default")
	get_node("Ponte3/AnimatedSprite").play("Normal")
	get_node("Ponte0/Explosion").play("None")
	get_node("Ponte1/Explosion").play("None")
	get_node("Ponte2/Explosion").play("None")
	get_node("Ponte3/Explosion").play("None")
	
func closePlayer():
	if (Global.players==2):
		if (global_position.distance_to(player2.global_position)<global_position.distance_to(player1.global_position)):
				 player = player2
		else:
			player = player1
func firstLoad():
	if (firstTime):
		firstTime=false	
		player1 = Global.MainScene.get_node("Player")
		player = player1
		if (Global.players==2):
			player2 = Global.MainScene.get_node("Player2")

 
func destroyBlock(index):
	get_node("Ponte"+str(index)+"/Explosion").play("Explosion")
	get_node("Ponte"+str(index)+"/Area2D").queue_free()
	var timer=0.6
	if(index==0 or index ==3):
		get_node("Ponte"+str(index)+"/AnimatedSprite").animation="Quebrado"  
		timerCreator("changeToDestroyed",timer,[index],true)
	else:
		get_node("Ponte"+str(index)+"/AnimatedSprite").queue_free()
		timerCreator("changeToNothing",timer,[index],true)

func changeToDestroyed(index):
		get_node("Ponte"+str(index)+"/Explosion").queue_free()

func changeToNothing(index):
	get_node("Ponte"+str(index)).queue_free()

func _process(delta: float) -> void:
		firstLoad()
		closePlayer()
		if(destroy == false):
			if(player.global_position.x >get_node("Ponte0/Position2D").global_position.x):
				 destroy=true
				 destroyBlock(0)
				 timerCreator("destroyBlock",1,[1],true)
				 timerCreator("destroyBlock",2,[2],true)
				 timerCreator("destroyBlock",3,[3],true)
			 
func timerCreator(functionName,time,parameters,create):
	if (create):
		var timer = Timer.new()
		if (parameters==null):
			timer.connect("timeout",self,functionName)
		else:
			timer.connect("timeout",self,functionName,parameters)
		timer.set_wait_time(time)
		timer.one_shot=true
		timer.autostart=true
		call_deferred("add_child",timer)
		
	
		var timer2 = Timer.new()
		timer2.connect("timeout",self,"timerCreator",["",0,[timer,timer2],false])
		timer2.set_wait_time(time+1)
		timer2.one_shot=true
		timer2.autostart=true
		call_deferred("add_child",timer2)
	else:
		remove_child(parameters[0])
		remove_child(parameters[1])

 
