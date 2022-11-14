extends Node2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Start"):
		returnToMenu()

func returnToMenu():
	get_tree().change_scene("res://Scenes/RootScenes/StartScreen.tscn")

func _on_VideoPlayer_finished() -> void:
	returnToMenu()
