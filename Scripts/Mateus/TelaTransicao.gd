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
	#if(player2):
		#$FinalScreen/Points2.visible=visibility
	$FinalScreen/Points.visible=visibility
	$FinalScreen/Score.visible=visibility
	
	#$FinalScreen/Points2.visible=visibility
	#$FinalScreen/Score2.visible=visibility
	flashText()
