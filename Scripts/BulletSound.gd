extends Node2D

var canSound=true
var frame=0
var maxFrame=10

func _process(delta: float) -> void:
	if (!canSound):
		frame+=1
		if(frame==maxFrame):
			frame=0
			canSound=true

