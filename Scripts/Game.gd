extends Node2D

var player2 = preload("res://Scenes/Player.tscn")
var startGame=false

func _ready() -> void:
	Global.player1Score=0
	Global.player2Score=0
	if (Global.players==2):
		var p2 = player2.instance()
		p2.name="Player2"
		add_child(p2)


func _on_Timer_timeout() -> void:
	print("player1Score: ",Global.player1Score)
	print("player2Score: ",Global.player2Score)
	return
