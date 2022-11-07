extends Node2Dextends Node2Dextends Sprite

func _ready() -> void:
	pass # Replace with function body.




func _on_JumpMove_pressed() -> void:
	get_tree().change_scene("res://Scenes/Prototypes/JumpMovePrototype.tscn")


func _on_Enemies_pressed() -> void:
	$Normal.visible=false
	$Enemies.visible=true


func _on_Back_pressed() -> void:
	$Normal.visible=true
	$Enemies.visible=false


func _on_Wall_turret_pressed() -> void:
	get_tree().change_scene("res://Scenes/Prototypes/Enemies/WallTurret.tscn")


func _on_Cannon_pressed() -> void:
	get_tree().change_scene("res://Scenes/Prototypes/Enemies/Cannon.tscn")


func _on_Shots_pressed() -> void:
	get_tree().change_scene("res://Scenes/Gustavo/Animations.tscn")


func _on_Start_Screen_pressed() -> void:
	get_tree().change_scene("res://Scenes/Mateus/StartScreen.tscn")


func _on_Sniper_pressed() -> void:
	get_tree().change_scene("res://Scenes/Mateus/StandShooterTest.tscn")


func _on_SniperBush_pressed() -> void:
	get_tree().change_scene("res://Scenes/Mateus/StandGunnerTest.tscn")


func _on_Soldier_pressed() -> void:
	get_tree().change_scene("res://Scenes/Mateus/MochileiroTeste.tscn")
