extends Control

var evil : bool

var kawaii_cursor = load("res://cursors/kawaii_cursor.svg")
var evil_cursor = load("res://cursors/evil_cursor.svg")

func _ready():
	evil = false
	
func detect(evilstate):
	if evilstate == false:
		$KawaiiMenu.visible = true
		$KawaiiAudio.play()
		Input.set_custom_mouse_cursor(kawaii_cursor)
		
		$EvilMenu.visible = false
		$EvilAudio.stop()
		
	elif evilstate == true:
		$EvilMenu.visible = true
		$EvilAudio.play()
		Input.set_custom_mouse_cursor(evil_cursor)
		
		$KawaiiMenu.visible = false
		$KawaiiAudio.stop()

func _unhandled_input(_event):
	if Input.is_action_just_pressed("toggle"):
		evil = !evil
	detect(evil)

func _on_quit_pressed():
	get_tree().quit()
