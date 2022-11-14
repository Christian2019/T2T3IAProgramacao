extends Node2D

var start_music=false
export var actual_position=0

var stop=false

func select_mode(): 
	if(Input.is_action_pressed("Arrow_UP") and actual_position==1):
		actual_position=0
		$FinalScreen.get_node("Seleciona").position.x=196
		$FinalScreen.get_node("Seleciona").position.y=550  
	
	if(Input.is_action_pressed("Arrow_DOWN") and actual_position==0): 
		actual_position=1
		$FinalScreen.get_node("Seleciona").position.x=196
		$FinalScreen.get_node("Seleciona").position.y=600 

func _physics_process(delta: float) -> void:
	if($Menu_Animation.position.x > 513):
		$Menu_Animation.position.x-=180*Global.Inverse_MAX_FPS
	else:
		$Menu_Animation.position.x=513
		$Menu_Animation.visible=false
		$FinalScreen.visible=true
	$Menu_Animation.position.x=clamp($Menu_Animation.position.x,0,get_viewport_rect().size.x)

func _process(delta: float) -> void:
	if (stop):
		return
	select_mode() 
	if(actual_position==0):   
		$FinalScreen/Player1.set("custom_colors/font_color", Color(1.0, 1.0, 1.0, 1.0))
		$FinalScreen/Player2.set("custom_colors/font_color", Color(0.6,0.6,0.6,1.0))
		Global.players=1

	else:  
		$FinalScreen/Player2.set("custom_colors/font_color", Color(1.0, 1.0, 1.0, 1.0))
		$FinalScreen/Player1.set("custom_colors/font_color", Color(0.6,0.6,0.6,1.0))
		Global.players=2
	
	if ($FinalScreen.visible):
		if (!start_music):
			start_music=true
			$AudioStreamPlayer2D.play()
		if(Input.is_action_pressed("Start")):
			stop=true
			turnOn()
			timerCreator("changeToTransition_Screen",3,null,true)
			

func changeToTransition_Screen():
	get_tree().change_scene("res://Scenes/RootScenes/Transition_Screen.tscn")
	
func turnOn():
	timerCreator("turnOf",0.2,null,true)
	if(actual_position==0): 
		$FinalScreen/Player1.visible=true
	else:
		$FinalScreen/Player2.visible=true
		
func turnOf():
	timerCreator("turnOn",0.1,null,true)
	if(actual_position==0): 
		$FinalScreen/Player1.visible=false
	else:
		$FinalScreen/Player2.visible=false
	
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
