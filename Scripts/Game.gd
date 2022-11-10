extends Node2D

var player2 = preload("res://Scenes/Player.tscn")

func _ready() -> void:
	if (Global.players==2):
		var p2 = player2.instance()
		p2.name="Player2"
		add_child(p2)
