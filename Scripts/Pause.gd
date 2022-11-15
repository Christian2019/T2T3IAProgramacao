extends Node2D


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS

func _process(_delta):
	
	if (Input.is_action_just_pressed("Start")):
		if (!get_tree().paused):
			Global.MainScene.get_node("Pause/Pause").play()
		get_tree().paused = !get_tree().paused

