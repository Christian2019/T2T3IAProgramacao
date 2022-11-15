extends AnimatedSprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var finalx:int
export var finalx2:int
export var finalx3:int

var animation1=true
var animation2=false
var animation3=false
var dancemfer=false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func MOONWALK(): 
	animation1=false   
	if(animation2):
		play("WALK") 
		if(position.x<=finalx2):
			position.x+=3
		else:
			position.x-=3

func ROLL():  
	play("ROLL")
	if( position.x <=finalx):
		position.x+=2
	elif(position.x >=finalx):
		position.x-=2

func WALK():  
	animation2=false  
	if(animation3):
		play("WALK") 
		if(position.x < finalx3):
			position.x+=2
		elif(position.x >finalx3):
			position.x-=2
 

func play_dance():
	animation3=false;
	animation2=false 
	if(not animation1 and not animation2 and not animation3): 
		play("DANCE")
	
func _process(delta):
		if(animation1):
			ROLL()  
		animation2=true
		timerCreator("MOONWALK",30,[],true)    
		animation3=true
		timerCreator("WALK",50,[],true)     
		timerCreator("play_dance",70,[],true)     
	 

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
