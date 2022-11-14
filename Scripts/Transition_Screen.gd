extends Node2D

func _ready() -> void:
	turnOn()
	if (Global.players==2):
		$FinalScreen/InfoP2.visible=true
		$FinalScreen/Lives2.visible=true
		$FinalScreen/Flash/Points2.visible=true

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

func _on_Timer_timeout() -> void:
	get_tree().change_scene("res://Scenes/RootScenes/Game.tscn")
