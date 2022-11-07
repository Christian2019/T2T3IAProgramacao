extends Node2D


# declara a posicao do seletor do menu
#Posicao zero é de valor (196,550)
#Posicao um é de valor (196,600) 
export var actual_position=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

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
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	select_mode() 
	if(actual_position==0):   
		$FinalScreen.get_node("1Player").set("custom_colors/font_color", Color(1.0, 1.0, 1.0, 1.0))
		$FinalScreen.get_node("2Player").set("custom_colors/font_color", Color(0.6,0.6,0.6,1.0))

	else:  
		$FinalScreen.get_node("2Player").set("custom_colors/font_color", Color(1.0, 1.0, 1.0, 1.0))
		$FinalScreen.get_node("1Player").set("custom_colors/font_color", Color(0.6,0.6,0.6,1.0))
	
	
		if(Input.is_action_pressed("Start")):
			get_tree().change_scene("res://Scenes/Prototypes/PrototypeMenu.tscn")
	
