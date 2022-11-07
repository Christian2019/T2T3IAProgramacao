extends Node2D


var speed=5
var pisca=false

var tempo=0
var senoTempo=0
var visibility=true

func flashText():
	if !pisca:
		if(senoTempo>0):
			visibility=true
		else:
			visibility=false
	else:
		visibility=true
		modulate.a=senoTempo

func _physics_process(delta):
	tempo+=delta
	senoTempo=sin(tempo*speed)
	if(Global.players==2):
		$FinalScreen/InfoP2.visible=true
		$FinalScreen/Lives2.visible=true
		$FinalScreen/Points2.visible=visibility
		$FinalScreen/Score2.visible=visibility
		

	$FinalScreen/Points.visible=visibility
	$FinalScreen/Score.visible=visibility
	
	flashText()


func _on_Timer_timeout() -> void:
	get_tree().change_scene("res://Scenes/Game/Game.tscn")
