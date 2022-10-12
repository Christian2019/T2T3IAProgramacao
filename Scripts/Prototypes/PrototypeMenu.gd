extends Sprite

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
