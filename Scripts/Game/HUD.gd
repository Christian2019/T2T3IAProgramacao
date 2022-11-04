extends Node2D

var lives = []
var life = preload("res://Scenes/Life.tscn")
var medalStartY=-290
var medalStartX=-476

func _ready() -> void:
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

