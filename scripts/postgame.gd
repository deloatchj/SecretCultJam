extends Control

var losestate = GameManager.minesweeperlosecounter
var recentlose = GameManager.recentflag

func _physics_process(_delta):
	if Input.is_action_just_pressed("one"):
		$AnimationPlayer.play("fulltoone")
	if Input.is_action_just_pressed("two"):
		$AnimationPlayer.play("onetotwo")
	if Input.is_action_just_pressed("three"):
		$AnimationPlayer.play("twotothree")
	if Input.is_action_just_pressed("four"):
		$AnimationPlayer.play("threetofour")
	if Input.is_action_just_pressed("five"):
		$AnimationPlayer.play("fourtofive")
	if Input.is_action_just_pressed("fail"):
		$AnimationPlayer.play("final_fail")
	if Input.is_action_just_pressed("toggle"):
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _ready():
	var evil_cursor = load("res://cursors/evil_cursor.svg")
	Input.set_custom_mouse_cursor(evil_cursor)
	
	if losestate == 0:
		$AnimationPlayer.play("preserve_full")
	if losestate == 1:
		if recentlose == true:
			$AnimationPlayer.play("fulltoone")
		if recentlose == false:
			$AnimationPlayer.play("preserve_one")
			
	if losestate == 2:
		if recentlose == true:
			$AnimationPlayer.play("onetotwo")
		if recentlose == false:
			$AnimationPlayer.play("preserve_two")
			
	if losestate == 3:
		if recentlose == true:
			$AnimationPlayer.play("twotothree")
		if recentlose == false:
			$AnimationPlayer.play("preserve_three")
			
	if losestate == 4:
		if recentlose == true:
			$AnimationPlayer.play("threetofour")
		if recentlose == false:
			$AnimationPlayer.play("preserve_four")
			
	if losestate == 5:
		if recentlose == true:
			$AnimationPlayer.play("fourtofive")
		if recentlose == false:
			$AnimationPlayer.play("preserve_five")
	
	if losestate == 6:
		$AnimationPlayer.play("final_fail")
		
