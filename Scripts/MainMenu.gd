extends Node2D

var start_music=false
export var actual_position=0

func _ready() -> void:
	pass 

func select_mode(): 
	if(Input.is_action_pressed("Arrow_UP") and actual_position==1):
		actual_position=0
		$FinalScreen.get_node("Seleciona").position.x=196
		$FinalScreen.get_node("Seleciona").position.y=550  
	
	if(Input.is_action_pressed("Arrow_DOWN") and actual_position==0): 
		actual_position=1
		$FinalScreen.get_node("Seleciona").position.x=196
		$FinalScreen.get_node("Seleciona").position.y=600 

func _physics_process(delta: float) -> void:
	if($Menu_Animation.position.x > 513):
		$Menu_Animation.position.x-=180*Global.Inverse_MAX_FPS
	else:
		$Menu_Animation.position.x=513
		$Menu_Animation.visible=false
		$FinalScreen.visible=true
	$Menu_Animation.position.x=clamp($Menu_Animation.position.x,0,get_viewport_rect().size.x)

func _process(delta: float) -> void:

	select_mode() 
	if(actual_position==0):   
		$FinalScreen.get_node("1Player").set("custom_colors/font_color", Color(1.0, 1.0, 1.0, 1.0))
		$FinalScreen.get_node("2Player").set("custom_colors/font_color", Color(0.6,0.6,0.6,1.0))
		Global.players=1

	else:  
		$FinalScreen.get_node("2Player").set("custom_colors/font_color", Color(1.0, 1.0, 1.0, 1.0))
		$FinalScreen.get_node("1Player").set("custom_colors/font_color", Color(0.6,0.6,0.6,1.0))
		Global.players=2
	
	if ($FinalScreen.visible):
		if (!start_music):
			start_music=true
			$AudioStreamPlayer2D.play()
		if(Input.is_action_pressed("Start")):
			get_tree().change_scene("res://Scenes/RootScenes/TelaTransicao.tscn")
	
