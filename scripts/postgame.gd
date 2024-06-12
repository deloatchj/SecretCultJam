extends Control

var losestate = GameManager.minesweeperlosecounter
var recentlose = GameManager.recentflag

func _physics_process(_delta):
	GameManager.game_over = false
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
		GameManager.recentflag = false
		get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _ready():
	var evil_cursor = load("res://cursors/evil_cursor.svg")
	Input.set_custom_mouse_cursor(evil_cursor)
	if losestate == 0:
		$AnimationPlayer.play("preserve_full")
		GameManager.evil = false

	if losestate == 1:
		if recentlose == true:
			$AnimationPlayer.play("fulltoone")
			GameManager.evil = true
		if recentlose == false:
			$AnimationPlayer.play("preserve_one")
			GameManager.evil = false
			
	if losestate == 2:
		if recentlose == true:
			$AnimationPlayer.play("onetotwo")
			GameManager.evil = true
		if recentlose == false:
			$AnimationPlayer.play("preserve_two")
			GameManager.evil = false
			
	if losestate == 3:
		if recentlose == true:
			$AnimationPlayer.play("twotothree")
			GameManager.evil = true
		if recentlose == false:
			$AnimationPlayer.play("preserve_three")
			GameManager.evil = false
			
	if losestate == 4:
		if recentlose == true:
			$AnimationPlayer.play("threetofour")
			GameManager.evil = true
		if recentlose == false:
			$AnimationPlayer.play("preserve_four")
			GameManager.evil = false
			
	if losestate == 5:
		if recentlose == true:
			$AnimationPlayer.play("fourtofive")
			GameManager.evil = true
		if recentlose == false:
			$AnimationPlayer.play("preserve_five")
			GameManager.evil = false
			
	if losestate == 6:
		$AnimationPlayer.play("final_fail")
		GameManager.evil = true

func _on_button_pressed():
	GameManager.recentflag = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")


func _on_continue_pressed():
	GameManager.recentflag = false
	get_tree().change_scene_to_file("res://scenes/bad_ending.tscn")
