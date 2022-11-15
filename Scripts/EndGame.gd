extends Node2D


var speed=5
var pisca=false

var tempo=0
var senoTempo=0
var visibility=true

func _ready(): 
	$MusicaFundo.play()
	$Timer.start()
	
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
	tempo+=delta
	senoTempo=sin(tempo*speed)   
	flashText()


func _on_Timer_timeout() -> void:
	get_tree().change_scene("res://Scenes/RootScenes/StartScreen.tscn")
