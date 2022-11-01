extends KinematicBody2D

export (int) var speed = 250
export var rotation_speed = 1.5
export var gravity = 2500
export var jump_speed = 1000
export var  cont_jump=2		 
 

var velocity = Vector2()
var rotation_dir = 0 # ang. inicial de rotação

onready var target := position # alvo inicial é a própria posição
onready var player := $Animation

func _ready() -> void:
	player.rotation_degrees = 0
	player.stop()
	#target = position

func get_side_input():
 
	var speed_ajust : int = speed
	var jump_ajust: float = jump_speed
	
	if Input.is_key_pressed(KEY_SHIFT):
		#print("Shift")
		speed_ajust *= 2
		jump_ajust *= 1.3		
		
	velocity.x = Input.get_action_strength("ui_right")-Input.get_action_strength("ui_left")
	velocity.x = velocity.x * speed_ajust # = velocity.normalized() * speed
	
	if Input.is_action_pressed("ui_up") and is_on_floor():
		velocity.y = -jump_ajust
		get_tree().call_group("HUD", "updateScore", 2) 

func _process(delta: float) -> void:
	if Input.is_action_pressed("Escape"):
		get_tree().change_scene("res://Scenes/Prototypes/PrototypeMenu.tscn")
	
func _physics_process(delta):
	#get_8way_input()
	get_side_input()
	#get_rotate_input()
	#get_rotate_mouse_input()
	#calc_velocity_click()
	#rotation += rotation_dir * rotation_speed * delta
	#if position.distance_to(target) > 5:
	velocity.y += gravity * Fps.MAX_FPS
	velocity = move_and_slide(velocity, Vector2.UP)
