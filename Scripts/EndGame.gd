extends Node2D



func _ready() -> void:
	$Player1.text= "P1 Score: "+str(Global.player1Score)+"/29500"
	$Player2.text= "P2 Score: "+str(Global.player2Score)+"/29500"


func _on_Timer_timeout() -> void:
	get_tree().change_scene("res://Scenes/RootScenes/StartScreen.tscn")
