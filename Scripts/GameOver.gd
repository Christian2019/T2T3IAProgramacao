extends Node2D

var up = true

func _ready() -> void:
	$FinalScreen/Flash/ScoreP1.text=str(Global.player1Score)
	$FinalScreen/Flash/ScoreP2.text=str(Global.player2Score)
	turnOn()
	if (Global.players==2):
		$FinalScreen/Player2.visible=true
		$FinalScreen/Flash/ScoreP2.visible=true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Arrow_DOWN") or Input.is_action_just_pressed("Arrow_UP"):
		up=!up
	changeVisibility()
	
	if Input.is_action_just_pressed("Start"):
		if (up):
			get_tree().change_scene("res://Scenes/RootScenes/Game.tscn")
		else:
			get_tree().change_scene("res://Scenes/RootScenes/StartScreen.tscn")

func changeVisibility():
	if(up):
		$FinalScreen/SelectUp.visible=true
		$FinalScreen/SelectDown.visible=false
	else:
		$FinalScreen/SelectUp.visible=false
		$FinalScreen/SelectDown.visible=true

func turnOn():
	timerCreator("turnOf",0.4,null,true)
	$FinalScreen/Flash.visible=true
	
func turnOf():
	timerCreator("turnOn",0.2,null,true)
	$FinalScreen/Flash.visible=false
	
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
