extends Node2D


# declara a posicao do seletor do menu
#Posicao zero é de valor (196,550)
#Posicao um é de valor (196,600) 
export var actual_position=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func select_mode(): 
	
	if(Input.is_action_pressed("ui_up") and actual_position==1):
		actual_position=0
		$Seleciona.position.x=196
		$Seleciona.position.y=550  
	
	if(Input.is_action_pressed("ui_down") and actual_position==0): 
		actual_position=1
		$Seleciona.position.x=196
		$Seleciona.position.y=600 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	select_mode() 
	if(actual_position==0):   
		$"1Player".set("custom_colors/font_color", Color(1.0, 1.0, 1.0, 1.0))
		$"2Player".set("custom_colors/font_color", Color(0.6,0.6,0.6,1.0))
		if(Input.is_action_pressed("ui_accept")):
			print("Vai para cena Singleplayer")
	else:  
		$"2Player".set("custom_colors/font_color", Color(1.0, 1.0, 1.0, 1.0))
		$"1Player".set("custom_colors/font_color", Color(0.6,0.6,0.6,1.0))
		if(Input.is_action_pressed("ui_accept")):
			print("Vai para cena multiplayer")
