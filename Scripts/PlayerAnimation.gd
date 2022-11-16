extends AnimatedSprite

export var finalx:int
export var finalx2:int
export var finalx3:int

enum states{MOONWALK,ROLL,WALK,DANCE,IDLE}
var state = states.ROLL
var wait=true
func _ready():
	timerCreator("start",8,null,true)  
	state=states.ROLL
	timerCreator("changeState",30,[states.MOONWALK],true)    
	timerCreator("changeState",50,[states.WALK],true)     
	timerCreator("changeState",73,[states.DANCE],true)
	timerCreator("changeState",90,[states.IDLE],true)
	timerCreator("changeState",121,[states.ROLL],true)
	timerCreator("changeState",141,[states.MOONWALK],true)    
	timerCreator("changeState",161,[states.WALK],true)     
	timerCreator("changeState",181,[states.DANCE],true)
	timerCreator("changeState",201,[states.IDLE],true)   
	

	
	
func changeState(s):
	state=s

func start():
	wait=false

func MOONWALK(): 
	play("WALK") 
	if(position.x<=finalx2):
		position.x+=3
	else:
		position.x-=3

func ROLL():  
	play("ROLL")
	if( position.x <=finalx):
		position.x+=5
	elif(position.x >=finalx):
		position.x-=5

func WALK():  
	play("WALK") 
	if(position.x < finalx3):
		position.x+=2


func _process(delta):
	if (wait):
		return
	stateController()
		   
	 
func stateController():
	global_position.y=474
	if (state==states.ROLL):
		global_position.y=514
		ROLL()
	elif (state==states.MOONWALK):
		MOONWALK()
	elif (state==states.WALK):
		WALK()
	elif (state==states.DANCE):
		play("DANCE")
	elif (state==states.IDLE):
		play("Idle")

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


