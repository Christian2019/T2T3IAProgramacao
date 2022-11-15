extends Node2D

var lives = []
var lives2 = []
var life = preload("res://Scenes/Life.tscn")
var life2 = preload("res://Scenes/Life2.tscn")
var medalStartY=-290
var medalStartX=-476
var medalStartY2=-290
var medalStartX2=376
var twoPlayersMode=false

func _ready() -> void:
	if Global.players==2:
		twoPlayersMode=true
	pass 

func _process(delta: float) -> void:
	
	var player_lives =get_parent().get_parent().get_node("Player").lives
	if (lives.size()!=player_lives):
		for n in $Lives.get_children():
			$Lives.remove_child(n)
			n.queue_free()
		lives.clear()
		for index in range(0,player_lives,1):
			var medal = life.instance()
			medal.position.y=medalStartY
			medal.position.x=medalStartX+30*index
			$Lives.add_child(medal)
			lives.append(medal)
	if (twoPlayersMode):
		var player2_lives =get_parent().get_parent().get_node("Player2").lives
		if (lives2.size()!=player2_lives):
			for n in $Lives2.get_children():
				$Lives2.remove_child(n)
				n.queue_free()
			lives2.clear()
			for index in range(0,player2_lives,1):
				var medal2 = life2.instance()
				medal2.position.y=medalStartY2
				medal2.position.x=medalStartX2+30*index
				$Lives2.add_child(medal2)
				lives2.append(medal2)
