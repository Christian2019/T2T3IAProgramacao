extends Node2D


var speed=5
var pisca=false

var tempo=0
var senoTempo=0
var visibility=true
var videoStart

func _ready(): 
	videoStart=false
	timerCreator("playVideo",8,null,true)
	timerCreator("increaseMusicSound",93,null,true)
	timerCreator("reduceMusicSound",192,null,true)

func increaseMusicSound():
	$AudioStreamPlayer.volume_db=5

func reduceMusicSound():
	$AudioStreamPlayer.volume_db=-10
	
func playVideo():
	videoStart=true
	$VideoPlayer.play()
	$DanceParty/DancingSniper.playing=true
	$DanceParty/DancingSniper2.playing=true
	$DanceParty/DancingSoldier.playing=true
	$DanceParty/DancingSoldier2.playing=true
	
func flashText():
	if !pisca:
		if(senoTempo>0):
			visibility=true
		else:
			visibility=false
	else:
		visibility=true
		modulate.a=senoTempo
	
	$Obrigado.visible=visibility
func _physics_process(delta):
	if (videoStart):
		if ($VideoPlayer.paused):
			$VideoPlayer.paused=false
	tempo+=delta
	senoTempo=sin(tempo*speed)   
	flashText()


func _on_Timer_timeout() -> void:
	get_tree().change_scene("res://Scenes/RootScenes/StartScreen.tscn")

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
