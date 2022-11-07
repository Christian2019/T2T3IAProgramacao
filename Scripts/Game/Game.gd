extends Node2D

var player2 = preload("res://Scenes/Player2.tscn")

func _ready() -> void:
	if (Global.players==2):
		add_child(player2.instance())
