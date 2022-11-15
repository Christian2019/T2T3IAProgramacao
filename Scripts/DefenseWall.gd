extends Node2D

export (Texture) var destroyed_wall_sprite

var node_shoot_cannon_1
var node_shoot_cannon_2
var ready_cannon = false

var has_node_1 = true
var has_node_2 = true

func _ready():
	node_shoot_cannon_1 = $Parts/Cannon1
	node_shoot_cannon_2 = $Parts/Cannon2
	node_shoot_cannon_1.shoot()
	$Timer.start()
	

func _on_Timer_timeout():
	if ready_cannon:
		if not node_shoot_cannon_1.destroyed:
			node_shoot_cannon_1.shoot()
	else:
		if not node_shoot_cannon_2.destroyed:
			node_shoot_cannon_2.shoot()
	ready_cannon = !ready_cannon

func _on_Door_tree_exited():
	#$Wall.texture = destroyed_wall_sprite
	$Wall.visible = false
	#node_shoot_cannon_1.destroy_turret()
	#node_shoot_cannon_2.destroy_turret()
	node_shoot_cannon_1.queue_free()
	node_shoot_cannon_2.queue_free()
	$InFrontPlayerWall.visible = true
	$Timer.stop()
	apocalypse()

func apocalypse():
	print("Fim da fase")
	Global.MainScene.get_node("Player").endGame=true
	if (Global.players==2):
		Global.MainScene.get_node("Player2").endGame=true	
	#Global.MainScene.get_node("Camera2D").global_position.x=Global.MainScene.get_node("Camera2D").maxX
	creatExplosions()
	var soldiersRespawns = Global.MainScene.get_node("Enemies/SoldierRespawns").get_children()
	for index in range(0,soldiersRespawns.size(),1):
		var soldiers=soldiersRespawns[index].get_children()[0].get_children()
		for index2 in range(0,soldiers.size(),1):
			soldiers[index2].destroy()
	
	destroyChildrens("Enemies/WallTurrets")
	destroyChildrens("Enemies/Cannons")
	destroyChildrens("Enemies/Enemies_Bush")
	destroyChildrens("Enemies/Snipers")
	destroyChildrens("Bullets")
		
func destroyChildrens(path):
	if  Global.MainScene.get_node(path).get_child_count()==0:
			return
	var parent = Global.MainScene.get_node(path).get_children()
	for index in range(0,parent.size(),1):
		var child= parent[index]
		child.destroy()
		
func creatExplosions():
	activateExplosions($AnimatedSprite1)
	$Destroy.play()
	Global.MainScene.get_node("Sounds/MainMusic").stop()

	for index in range(1,9,1):
		timerCreator("activateExplosions",(index+1)*0.2,[get_node("AnimatedSprite"+str(index+1))],true)

func activateExplosions(animatedSprite):
	animatedSprite.visible=true
	animatedSprite.play("explosion")
	timerCreator("destroyExplosions",1.2,[animatedSprite],true)

func destroyExplosions(animatedSprite):
	animatedSprite.queue_free()
	
func timerCreator(functionName,time,parameters,create):
	if (create):
		var timer = Timer.new()
		if (parameters==null):
			timer.connect("timeout",self,functionName)
		else:
			timer.connect("timeout",self,functionName,parameters)
		timer.set_wait_time(time)
		timer.one_shot=true
		timer.autostart=true
		call_deferred("add_child",timer)
		
	
		var timer2 = Timer.new()
		timer2.connect("timeout",self,"timerCreator",["",0,[timer,timer2],false])
		timer2.set_wait_time(time+1)
		timer2.one_shot=true
		timer2.autostart=true
		call_deferred("add_child",timer2)
	else:
		remove_child(parameters[0])
		remove_child(parameters[1])


func _on_AnimatedSprite9_tree_exited() -> void:
	Global.MainScene.get_node("Sounds/EndGame").play()
	Global.MainScene.get_node("Player").startEndGame=true
	if (Global.players==2):
		Global.MainScene.get_node("Player2").startEndGame=true	
	
