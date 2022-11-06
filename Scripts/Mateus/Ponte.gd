extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var partesVetor:Array;
var destroy=false 
# Called when the node enters the scene tree for the first time.
func _ready(): 
	pass # Replace with function body.
func destroyBlock(index):
	if(index==0 or index ==3):
		get_node("Ponte"+str(index)+"/AnimatedSprite").animation="Quebrado"
		get_node("Ponte"+str(index)+"/CollisionShape2D").queue_free()
	else:
		get_node("Ponte"+str(index)).queue_free()

func _physics_process(delta):  
		if(destroy == false):
			if(get_parent().get_node("./Player").global_position.x >(get_node("Ponte0/CollisionShape2D").global_position.x - get_node("Ponte0/CollisionShape2D").shape.extents.x)):
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
